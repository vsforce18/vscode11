public with sharing class ArrayEg {

	public void arrayEg(){
		system.debug('************ Entered into arrayEg() ************');
		Integer[] iArray = new Integer[5];
		
		system.debug('************ 1. Value: ' + iArray);
		//Adding values into an Array
		iArray[0] = 10;
		iArray[1] = 20;
		iArray[2] = 40;
		iArray[3] = 50;
		iArray[4] = 60;
		
		system.debug('************ 2. Value: ' + iArray);
		
		system.debug('************ 3. Value at index 2: ' + iArray[2]);
		iArray[5] = 70;
		system.debug('************ Leaving arrayEg() ************');
	}
}