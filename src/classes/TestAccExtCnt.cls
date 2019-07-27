@isTest
public class TestAccExtCnt {
    public static testmethod void testEmpCnt(){
        PageReference pf = Page.EmpExtCnt;
        Test.setCurrentPage(pf);
        
        Employee__c emp = new Employee__c(First_Name__c='Venkat', Last_Name__c='Test');
        insert emp;
        
        ApexPages.StandardController std = new ApexPages.StandardController(emp);
        EmployeeExtCnt extCnt = new EmployeeExtCnt(std);
        extCnt.save();
        
        system.assertEquals('sdfasf', emp.First_Name__c);
    }
    
    @istest
    public static void testTrigger(){
        //Employee__c emp = new Employee__c(First_Name__c='Fn', Last_Name__c='LN');
        //insert emp;
        
        List<Employee__c> empList = new List<Employee__c>();
        for(Integer i=0; i<120; i++)
        {
            Employee__c emp = new Employee__c(First_Name__c='Fn'+i, Last_Name__c='LN'+i);
            insert emp;
            empList.add(emp);
        }
        //Till now 120 DML Statements
        system.test.startTest();
        //A new context of Governor limits started from line 30
        insert empList;
        //NEW Limits ended
        
        User u = new User(UserName='testusr@gmail.com', FirstName='Venkat', LastName='Mentis', USerRoleId='00E1a000000LkOo', ProfileId='00e1a000000qtOL');
        insert u;
        system.runAs(u){
            system.debug('********* Running a new user testusr@gmail.com **********');
            Employee__c emp = new Employee__c();
            insert emp;
        }
        system.test.stopTest();
        //Again 
        //insert emp;
        //121
        system.assertEquals(200, empList.size());
    }
}