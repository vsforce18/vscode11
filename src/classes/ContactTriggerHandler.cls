/**
* Description:  On Account changed or contact deleted for converting back as Lead all logic is handled here.
*       1. After Insert: a. Get all Contacts who's accounts are modified
						b. Create Lead records for each Contact
						c. Get all OpportunityContactRole records matching AccountId and Contact
						d. Delete matched OpportunityContactRole records
						e. Delete Contact
*
*   Modification Log : 
---------------------------------------------------------------------------
    Developer               Date                Description
---------------------------------------------------------------------------
    Venkat Mallipeddi       03/10/2018          Created
******************************************************************************************/
public with sharing class ContactTriggerHandler{
    public static Boolean firstRun = true;
    
    /**
     * Description: Initialize on creating new instance.
     */
    public ContactTriggerHandler(){
        system.debug('Entered into ContactTriggerHandler() of ' + ContactTriggerHandler.class);
        system.debug('Leaving from ContactTriggerHandler() of ' + ContactTriggerHandler.class);
    }
    
    /**
     * Description: After updating as Contact, perform creating Leads, deleting opportunitycontactroles and contact
     * 
     * @param oldConMap		Map of old contacts being updated
     * @param newConMap		Map of new contacts being updated
     */
    public void onAfterUpdate(Map<Id, Contact> oldConMap, Map<Id, Contact> newConMap){
        if(firstRun){
            firstRun = false;
            system.debug('Entered into onAfterUpdate() of ' + ContactTriggerHandler.class);
            Set<Id> accIdSet = new Set<Id>(); //Get all old Accounts of the contact
            
            Map<Id, Id> con2AccIdMap = new Map<Id, Id>(); //Get Contacts for which account is updated with ContactId=>old AccountId
            List<Lead> leadList = new List<Lead>();
            List<Contact> conList = new List<Contact>();
            for(Contact newCon : newConMap.values()){
                if(newCon.AccountId!=oldConMap.get(newCon.Id).AccountId){//null==newCon.AccountId && 
                    accIdSet.add(oldConMap.get(newCon.Id).AccountId);
					if(null!=oldConMap.get(newCon.Id).AccountId)
						con2AccIdMap.put(newCon.Id, oldConMap.get(newCon.Id).AccountId);
                    conList.add(oldConMap.get(newCon.Id));
                }
            }
            if(!conList.isEmpty())
				process2LeadConversion(conList, con2AccIdMap);
            
            //Delete Contact after Lead is created
			DatabaseUtility.deleteRecords([select Id from Contact where Id IN :conList], 'Contact', 'ContactTriggerHandler', 'onAfterUpdate');
			system.debug('Leaving from onAfterUpdate() of ' + ContactTriggerHandler.class);
        }
    }
    
    /**
     * Description: Creating Leads, Deleting OpportunityContactRole and Contacts is handled here
     * 
     * @param conList		Takes list of contacts whos account is changed.
     * @param con2AccIdMap	Takes map of old ContactId to old AccountId
     */
	public void process2LeadConversion(List<Contact> conList, Map<Id, Id> con2AccIdMap){
		system.debug('Entered into process2LeadConversion() of ' + ContactTriggerHandler.class);
		//Create Leads
		List<Lead> leadList = getLeads(conList, con2AccIdMap.values());
		//insert leadList;
		DatabaseUtility.createRecords(leadList, 'Lead', 'ContactTriggerHandler', 'process2LeadConversion');
		
		//If Old Account is Blank then no need to delete OpportunityContactRoles
		if(!con2AccIdMap.isEmpty()){
			List<OpportunityContactRole> oppConRoleList = [Select Opportunity.Owner.Name, Opportunity.Owner.Email, Opportunity.OwnerId, Opportunity.AccountId, Opportunity.Name, OpportunityId, ContactId, Contact.Name From OpportunityContactRole where Opportunity.AccountId IN :con2AccIdMap.values() aND ContactId IN :con2AccIdMap.keySet() AND Opportunity.IsClosed=false];
			
			Map<Id, List<OpportunityContactRole>> userid2oppConRoleMap = new Map<Id, List<OpportunityContactRole>>();
			for(OpportunityContactRole oppConRole : oppConRoleList){
                system.debug('*********** Trigger-1: '+ UserInfo.getUserId() + '\t' + oppConRole.Opportunity.OwnerId);
				if(UserInfo.getUserId() != oppConRole.Opportunity.OwnerId){
                    system.debug('*********** Trigger-2: '+ userid2oppConRoleMap + '\t' + oppConRole.Opportunity.OwnerId);
					if(userid2oppConRoleMap.containsKey(oppConRole.Opportunity.OwnerId)){
                        system.debug('*********** Trigger-5: '+ UserInfo.getUserId() + '\t' + oppConRole.Opportunity.OwnerId);
						List<OpportunityContactRole> tempOppConList = userid2oppConRoleMap.get(oppConRole.Opportunity.OwnerId);
						tempOppConList.add(oppConRole);
						userid2oppConRoleMap.put(oppConRole.Opportunity.OwnerId, tempOppConList);
					}else{
                        system.debug('*********** Trigger-4 ELSE: '+ userid2oppConRoleMap + '\t' + oppConRole.Opportunity.OwnerId);
						userid2oppConRoleMap.put(oppConRole.Opportunity.OwnerId, new List<OpportunityContactRole>{oppConRole});
					}
				}   
			}
			
			//Send email
			List<Messaging.SingleEmailMessage> oppMailList = new List<Messaging.SingleEmailMessage>();
			for(Id usrId : userid2oppConRoleMap.keySet()){
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				//mail.setToAddresses(new List<String>{(null!=usr.Email?usr.Email:'')});
				mail.setTargetObjectId(usrId);
				mail.setUseSignature(false);
				mail.setSaveAsActivity(false);
				mail.setSubject('Opportunity Contacts deleted');
				String str = 'The following changes happened on below Opportunities and Contacts: ';
				for(OpportunityContactRole oppRole : userid2oppConRoleMap.get(usrId)){
					system.debug('********* con role list: '+ oppRole);
					str += oppRole.Opportunity.Name + ' - ' + oppRole.Contact.Name + '\n';
				}
				mail.setPlainTextBody(str);
				oppMailList.add(mail);
			}
			if(!oppMailList.isEmpty() && !Test.isRunningTest())
				Messaging.sendEmailResult[] sendEmailResults = Messaging.sendEmail(oppMailList, true);
			
			DatabaseUtility.deleteRecords(oppConRoleList, 'OpportunityContactRole', 'ContactTriggerHandler', 'process2LeadConversion');
		}
		system.debug('Leaving from process2LeadConversion() of ' + ContactTriggerHandler.class);
	}
    
    /**
     * Description: Create new Leads for all contacts whos Account is changed.
     * 
     * @param conList		Takes list of contacts whos account is changed.
     * @param accIdList		Takes list of old AccountIds, used for deleting OpportunityContactRoles associated with Contact and Account
     * 
     * @param leadList		Returns List of newly created Leads
     */
    public List<Lead> getLeads(List<Contact> conList, List<Id> accIdList){
        system.debug('Entered into getLeads() of ' + ContactTriggerHandler.class);
        List<Lead> leadList = new List<Lead>();
        List<Contact_Lead_Field_Map__mdt> fldMdtList = [select DeveloperName, MasterLabel, Contact__c, Contact_Fields__c, Lead__c, Lead_Fields__c, Contact_Field__c, Lead_Field__c from Contact_Lead_Field_Map__mdt];
        Map<String, String> con2LeadFldMap = new Map<String, String>();
        for(Contact_Lead_Field_Map__mdt fld : fldMdtList)
            con2LeadFldMap.put(fld.Contact_Field__c, fld.Lead_Field__c);
        
        //Get AccountName, Number of Employees field data for each Contact
        Map<Id, Account> accMap = new Map<Id, Account>([Select Name, NumberOfEmployees from Account where Id IN :accIdList]);
        
        for(Contact con : conList){
            Lead newLead = new Lead();
            for(Contact_Lead_Field_Map__mdt fld : fldMdtList){
                if(null!=con.get(fld.Contact_Field__c)){
                	if('AccountId'==fld.Contact_Field__c){
                    	Account acc = accMap.get((Id)con.get(fld.Contact_Field__c));
                        if(null!=acc){
                            newLead.put('Company', String.isNotBlank((String)acc.get('Name'))?(String)acc.get('Name'):'');
                            if(String.isNotBlank((String)acc.get('Name')))
                               newLead.put('NumberOfEmployees', Integer.valueOf(acc.get('NumberOfEmployees')));
                        }
                    }else
                    	newLead.put(fld.Lead_Field__c, con.get(fld.Contact_Field__c));
                }
            }
            leadList.add(newLead);
        }
        system.debug('Leaving from getLeads() of ' + ContactTriggerHandler.class);
        return leadList;
	}
    
    /**
    * Description: Avoids recurssion in after update trigger
    *       
    * @param firstRun    set to true if trigger is executed
    */
    public void setFirstrun(Boolean firstRun){
        firstRun = firstRun;
    }
}