public with sharing class CollectionEg {
	
	/*
	1. List is ordered
	2. List Allow duplicates
	3. Allows null values
	*/ 
	public void listEg(){
		system.debug('********** Entered into listEg() *********');
		List<Integer> intList = new List<Integer>();
		
		system.debug('********** 1. List value: ' + intList);
		//intList[0] = 10;
		intList.add(10);
		intList.add(20);
		intList.add(30);
		intList.add(10);
		intList.add(null);
		
		system.debug('********** 2. List value: ' + intList);
		
		//Adding at a particular index
		intList.add(50);
		system.debug('********** 3. List value: ' + intList);
		
		intList.clear();
		system.debug('********** 3-0. List value: ' + intList);
		
		system.debug('********** 4. List value at index 4: ' + intList.get(4));
		system.debug('********** Leaving from listEg() *********');
	}
	
	/*
	1. Set is UNordered
	2. Set Donot Allow duplicates
	3. Allows null values
	*/ 
	public void setEg(){
		system.debug('********** Entered into setEg() *********');
		Set<Integer> intSet = new Set<Integer>();
		
		system.debug('********** 1. Set value: ' + intSet);
		//intSet[0] = 10;
		intSet.add(10);
		intSet.add(20);
		intSet.add(30);
		intSet.add(10);
		intSet.add(null);
		
		system.debug('********** 2. Set value: ' + intSet);
		
		//Adding at a particular index
		intSet.add(50);
		system.debug('********** 3. Set value: ' + intSet);
		
		
		system.debug('********** 4. Set value at index 4: ' + intSet);
		system.debug('********** Leaving from setEg() *********');
	}
	
	
	/*
	Map example
	1. Order is not guaranted
	2. All keys are Unique and values can be duplicated
	3. 
	*/
	public void mapEg(){
		system.debug('************** Entered into mapEg() ***************');
		Map<String, String> colorMap = new Map<String, String>();
		
		system.debug('************** Map vlaue-1: ' + colorMap);
		colorMap.put('RED', 'You color is RED');
		colorMap.put('GRE', 'You color is GREEN');
		colorMap.put('YEL', 'You color is YELLOW');
		system.debug('************** Map vlaue-2: ' + colorMap);
		
		//Get elements from map based on Map
		String val = colorMap.get('GRE');
		system.debug('**************** Value of GRE=' + val);
		
		//Get all SET of Keys in a Map
		Set<String> colorKeySet = colorMap.keySet();
		system.debug('**************** All keys: ' + colorKeySet);
		
		//Get all LIST of Values in a Map
		List<String> colorValues = colorMap.values();
		system.debug('**************** All values: ' + colorValues);
		
		system.debug('************** Leaving from mapEg() ***************');
	}
}