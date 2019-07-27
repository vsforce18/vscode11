public with sharing class EmployeeExtCnt {
    public Employee__c emp {get; set;}
    
    public Boolean sec2Flag {get; set;}
    
    public EmployeeExtCnt(ApexPages.StandardController controller) {
        system.debug('********* Entered into EmployeeExtCnt() ***********: ' + emp);
        //SObject sobj = controller.getRecord();
        //emp = (Employee__c)sobj;
        
        emp = (Employee__c) controller.getRecord();
        sec2Flag = false;
        system.debug('********* Leaving from EmployeeExtCnt() ***********: ' + emp);
    }
    
    public PageReference save(){
        system.debug('********* Entered into Save() ***********: ' + emp);
        
        try{
            emp = null;
            insert emp;
        }catch(Exception e){
            Apexpages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Unable to insert a record');
            ApexPages.addMessage(msg);
            system.debug('****************** Exception: '+ e);
        }
        
        system.debug('********* Leaving from Save() ***********: ' + emp);
        return null;
    }
    
    public PageReference showHideSection()
    {
        system.debug('************** Entered into showHideSection() ***********');
        //if(emp.EmpType__c == 'Part-time')
            sec2Flag = true;
        
        system.debug('************** Leaving from showHideSection() ***********');
        return null;
    }
    
    
    
    
}