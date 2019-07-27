public class EmployeeTriggerHandler {
	
	public void beforeInsert(List<Employee__c> newEmpList)
	{
		system.debug('************* Entered into beforeInsert() of ' + EmployeeTriggerHandler.class);
		
		for(Employee__c emp : newEmpList)
		{
			emp.Active__c = true;
		}
		
		system.debug('************* Leaving from beforeInsert() of ' + EmployeeTriggerHandler.class);
	}

}