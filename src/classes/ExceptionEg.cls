public class ExceptionEg {
	
	public void exceptionDemo(){
		system.debug('*********** Entered into exceptionDemo() **********');
		double result;
		Car c;
		try{
			system.debug('***** Now in Try-1');
			result = 10/0;
			system.debug('***** Now in Try-2');
			//c.carDetails();
		}
		//system.debug('Catch started'); // You cannot add any statements with in try and catch blocks
		
		/*catch(MathException me)
		{
			system.debug('***** Now in MathException: ' + me);
		}*/
		catch(NullPointerException ne)
		{
			system.debug('***** Now in NullPointerException: ' + ne);
		}
		catch(Exception e)
		{
			system.debug('***** Now in Exception: ' + e);
			//throw Exception('');
		}
		system.debug('*********** Result is: ' + result);
		
		system.debug('*********** Leaving from exceptionDemo() **********');
	}
	
}