public with sharing class SOQLEg {
	public void insertEg(){
		system.debug('******** Entered into insertEg() of '+ SOQLEg.class);
		
		/*//1. Approach
		Employee__c emp = new Employee__c();
		emp.First_name__c = 'FN Apex1';
		emp.Last_name__c = 'Solutions';
		
		insert emp;
		*/
		
		//2. Approach
		Employee__c emp = new Employee__c(First_name__c='FN Inside', Last_Name__c='LN');
		insert emp;
		
		//Bulkify your code
		List<Employee__c> insertEmpList = new List<Employee__c>(); 
		for(integer i=0; i<150; i++){
			Employee__c emp1 = new Employee__c(First_name__c='FN Inside'+i, Last_Name__c='LN');
			insert emp1;
			//insertEmpList.add(emp1);
		}
		insert insertEmpList;
		
		system.debug('******** INSERTED Employee details are:\n'+ emp);
		
		
		system.debug('******** Leaving from insertEg() of '+ SOQLEg.class);
	}
	
	public void retrieveData(){
		system.debug('******** Entered into retrieveData() of '+ SOQLEg.class);
		/*
		List<Employee__c> empList = [select Name, First_name__c, Last_Name__c, Date_of_Birth__c from Employee__c];
		system.debug('*************** All Employees are:\n' + empList);
		
		//Get record based on INdex from collection
		Employee__c emp = empList[0];
		system.debug('****************************'
					+'\nId: '+ emp.Id
					+'\nFirst Name: '+ emp.First_Name__c
					+'\nDate of Birth: '+ emp.Date_of_Birth__c);
		
		//1. Traditional for... loop
		for(Integer i=0; i<empList.size(); i++)
		{
			system.debug('****************************'
					+'\nId: '+ empList[i].Id
					+'\nFirst Name: '+ empList[i].First_Name__c
					+'\nDate of Birth: '+ empList[i].Date_of_Birth__c);
		}
		
		
		//2. For loop with SOQL
		List<Account> accList = [select Name, AccountNumber from Account];
		for(Account acc : accList)
		{
			system.debug('**************************** Account'
					+'\nId: '+ acc.Id
					+'\nAccount Name: '+ acc.Name);
		}
		*/
		
		//3. For loop with SOQL
		for(Account acc : [select Name, AccountNumber from Account])
		{
			system.debug('**************************** Account'
					+'\nId: '+ acc.Id
					+'\nAccount Name: '+ acc.Name);
		}
		system.debug('******** Leaving from retrieveData()');
	}
	
	
	public void updateEg(String accName){
		system.debug('******** Entered into updateEg() of '+ SOQLEg.class);
		
		Integer i=1;
		List<Account> accList = [select Name from Account where Name = :accName];
		system.debug('******** Actual Account details are:\n'+ accList);
		for(Account acc : accList){
			acc.Name = 'Apex Account'+i;
			i++;
		}
		
		//Insert new row and add that row to the collection and do Upsert
		update accList;
		
		system.debug('******** UPDATED Account details are:\n'+ accList);
		
		
		system.debug('******** Leaving from updateEg() of '+ SOQLEg.class);
	}
}