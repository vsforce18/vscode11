/**
* Description: Test methods for Contact related Triggers, Controllers code coverage 
*
*   Modification Log : 
---------------------------------------------------------------------------
    Developer               Date                Description
---------------------------------------------------------------------------
    Venkat Mallipeddi       03/11/2018          Created
******************************************************************************************/

@isTest
private class TestContact{
    /**
     * Description: Create test data which can be used in all test methods of the same class 
     */
    @testSetup public static void testData(){
        //Create Accounts
        List<Account> accList = new List<Account>();
        for(Integer i=0; i<200; i++){
            accList.add(new Account(Name='Test Acc'+i, NumberOfEmployees=i));
        }
        insert accList;
        
        //Create Contacts
        List<Contact> conList = new List<Contact>();
        for(Integer i=0; i<200; i++)
            conList.add(new Contact(AccountId=accList[i].Id, LastName='LN'+i, FirstName='FN'+i, Email='con'+i+'@gmail.com', Description='Test description'+i, MobilePhone='2001003000'));
        insert conList;
        
        //Create Opportunities
        List<Opportunity> oppList = new List<Opportunity>();
        for(Integer i=0; i<200; i++)
            oppList.add(new Opportunity(AccountId=accList[i].Id, Amount=100, Name='Opp'+i, StageName='Prospecting', Description='Test description'+i, CloseDate=Date.today().addDays(i)));
        insert oppList;
        
        //Create OpportunityContactRoles
        List<OpportunityContactRole> oppConRoleList = new List<OpportunityContactRole>();
        for(Integer i=0; i<198; i++)
            oppConRoleList.add(new OpportunityContactRole(OpportunityId=oppList[i].Id, ContactId=conList[i+1].Id, Role='Advisor'));
        insert oppConRoleList;
    }
    
    /**
     * Description: Code coverage for ContactTriggerHandler for the Owner who are modifing their own records 
     */
    @isTest public static void testContactTrg(){
        List<Account> accList = [Select Id, Name, NumberOfEmployees from Account];
        List<Contact> conList = [Select Id, AccountId, Account.Name, Account.NumberOfEmployees, FirstName, LastName, Email, MobilePhone, Fax, Description, Title from Contact];
        List<Opportunity> oppList = [Select Id, Name, AccountId, Account.Name, StageName, CloseDate, Description, OwnerId from Opportunity];
        List<OpportunityContactRole> oppConRoleList = [Select Opportunity.Owner.Name, Opportunity.Owner.Email, Opportunity.OwnerId, Opportunity.AccountId, Opportunity.Name, OpportunityId, ContactId, Contact.Name From OpportunityContactRole];
        
        for(Integer i=0; i<20; i++){
            conList[i].AccountId = accList[i+2].Id;
        }
        update conList;
        
        List<Contact> cList = [select Id from Contact];
        system.assertEquals(180, [select count() from Contact]);
        List<Lead> leadList = [select Id, Company from Lead];
        system.assertEquals(20, leadList.size());
    }
    
    /**
     * Description: Code coverage for ContactTriggerHandler for the users modifing some other users records 
     */
    @isTest public static void testContactTrgRunas(){
        List<Account> accList = [Select Id, Name, NumberOfEmployees from Account];
        List<Contact> conList = [Select Id, AccountId, Account.Name, Account.NumberOfEmployees, FirstName, LastName, Email, MobilePhone, Fax, Description, Title from Contact];
        List<Opportunity> oppList = [Select Id, Name, AccountId, Account.Name, StageName, CloseDate, Description, OwnerId from Opportunity];
        List<OpportunityContactRole> oppConRoleList = [Select Opportunity.Owner.Name, Opportunity.Owner.Email, Opportunity.OwnerId, Opportunity.AccountId, Opportunity.Name, OpportunityId, ContactId, Contact.Name From OpportunityContactRole];
        
        //Setup test data
        //Create a unique UserName
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        //This code runs as the system user
        Profile p = [select Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias='standt', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        				LocaleSidKey='en_US', ProfileId=p.Id, TimeZoneSidKey='America/Los_Angeles', UserName=uniqueUserName);
        system.Test.startTest();
        System.runAs(u){
            for(Integer i=0; i<20; i++){
                conList[i].AccountId = accList[i+2].Id;
            }
            update conList;
            
            List<Contact> cList = [select Id from Contact];
            system.assertEquals(180, [select count() from Contact]);
            List<Lead> leadList = [select Id, Company from Lead];
            system.assertEquals(20, leadList.size());
        }
        new ContactTriggerHandler().setFirstrun(true);
        system.Test.stopTest();
    }
    
    /**
     * Description: Test class for custom ContactCnt controller
     */
    @isTest public static void testContactCnt(){
        Contact con = [Select Id, AccountId, Account.Name, Account.NumberOfEmployees, FirstName, LastName, Email, MobilePhone, Fax, Description, Title from Contact where IsDeleted=false limit 1];
        ContactCnt.deleteContact(con.Id);
    }
}