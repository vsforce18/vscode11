/**
* Description:  On click of Convert to Lead button, perform deletion of OpportunityContactRoles, create Lead
*
*   Modification Log : 
---------------------------------------------------------------------------
    Developer               Date                Description
---------------------------------------------------------------------------
    Venkat Mallipeddi       03/11/2018          Created
******************************************************************************************/
global without sharing class ContactCnt{
    /**
     * Description: Delete Contact, OpportunityContactRoles and create Lead when custom Convert to Lead button is clicked on Classic and Lightning experience.
     * 
     * @param conId		Contact Id
     */
	WebService static void deleteContact(Id conId){
        system.debug('Entered into deleteContact() of ' + ContactCnt.class);
        List<Contact> conList = [select Id, FirstName, LastName, Description, AccountId, LeadSource, DoNotCall, Email, Fax, HasOptedOutOfEmail, HasOptedOutOfFax, MailingCity, MailingCountry, MailingPostalcode, MailingState, MailingStreet, MobilePhone, OwnerId, Phone, Title from Contact where Id=:conId];
        if(!conList.isEmpty()){
            Map<Id, Id> con2AccIdMap = new Map<Id, Id>(); //Get Contacts for which account is updated with ContactId=>old AccountId
            if(null!=conList[0].AccountId)
                con2AccIdMap.put(conList[0].Id, conList[0].AccountId);
        
			ContactTriggerHandler conTrg = new ContactTriggerHandler();
        	conTrg.process2LeadConversion(conList, con2AccIdMap);
        	delete [select Id from Contact where Id=:conId];
        }
        system.debug('Leaving from deleteContact() of ' + ContactCnt.class);
	}
}