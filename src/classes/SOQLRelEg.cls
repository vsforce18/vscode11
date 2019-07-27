public with sharing class SOQLRelEg {
	public void child2Parent(){
		system.debug('************** Entered into child2Parent() of '+ SOQLRelEg.class);
		
		//Standard Object
		List<Contact> conList = [select FirstName, LastName, AccountId, Account.Name from Contact limit 2];
		for(Contact c : conList){
			String accName = c.Account.Name;
			system.debug('********** Contact con: '+ c.FirstName + '\t' + c.LastName  
			+ '\t => ' + c.AccountId + '\t' + c.Account.Name);
		}
		
		
		//Custom Object
		List<Emp_Address__c> empAddrList = [select City__c, State__c, Employee__c, Employee__r.First_Name__c from Emp_Address__c limit 2];
		for(Emp_Address__c addr : empAddrList){
			system.debug('********** Employee Address: '+ addr.City__c + '\t' + addr.State__c 
			+ '\t => ' + addr.Employee__c + '\t' + addr.Employee__r.First_Name__c);
		}
		
		Account acc = [select Name from Account order by CreatedDate desc limit 1];
		//Id accId = acc.Id;
		
		List<Contact> conList1 = [select FirstName, LastName from Contact where AccountId = :acc.Id];
		
		/*
		1. Get Contacts - writes SOQL to get contacts
		2. Use for loop and iterate over the contact's Account Id in as set
		3. Iterate over each Contact and get the Account details from Step 2 and print
		*/
		system.debug('************** Leaving from child2Parent() of '+ SOQLRelEg.class);
	}
	
	
	public void parent2Child(){
		system.debug('************** Entered into parent2Child() of '+ SOQLRelEg.class);
		
		//Custom Object
		List<Employee__c> empList = [select First_Name__c, Last_Name__c, (select City__c, State__c from Emp_Addressess__r) from Employee__c limit 2];
		for(Employee__c emp : empList){
			String fn = emp.First_Name__c;
			List<Emp_Address__c> empAddList = empList[0].Emp_Addressess__r;
			
			system.debug('********** Employee Details: '+ fn + '\t' + emp.Last_Name__c); 
		}
		/*
		1	Venkat
			NJ
			NY
		2	Mentis
			No child records
		3
		*/	
		
		
		
		//Standard Object
		//List<Account> accList = [select Name, AccountNumber, (select FirstName, LastName from Contacts) from Account limit 2];
		//List<Contact> conList = accList[0].Contacts;
		system.debug('************** Leaving from parent2Child() of '+ SOQLRelEg.class);
	}

}