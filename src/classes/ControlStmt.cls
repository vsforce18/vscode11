public class ControlStmt {
	public void controlIf(){
		system.debug('************ Entered into controlIf() ************');
		Integer i = 10;
		if(i==10)
		{
			system.debug('************ Now inside if ************');
		}
		system.debug('************ Leaving from controlIf() ************');
	}
	
	public void controlFor1(){
		system.debug('************ Entered into controlFor1() ************');
		
		for(Integer i=1; i<=10; i++)
		{
			system.debug('************ Now inside for: ' + i);
		}
		system.debug('************ Leaving from controlFor1() ************');
	}
}