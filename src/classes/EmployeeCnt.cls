public class EmployeeCnt {
    public Employee__c emp {get; set;}
    
    public EmployeeCnt(){
        system.debug('*********** Entered into EmployeeCnt() of EmployeeCnt **********: '+ emp);
        if(emp == null)
            emp = new Employee__c();
        system.debug('*********** Leaving from EmployeeCnt() of EmployeeCnt **********: '+ emp);
    }
    
    public PageReference save(){
        system.debug('*********** Entered into save() of EmployeeCnt **********: '+ emp);
        
        insert emp;
        
        system.debug('*********** Leaving from save() of EmployeeCnt **********: '+ emp);
        return null;
    }
}