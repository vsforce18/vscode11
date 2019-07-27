public class AccessM1 {
	private integer i = 10;
	private integer j = 20;
	
	public void add(){
		system.debug('********* Entered into add() of AccessM1 Modified1');
		integer sum = i + j;
		system.debug('********* Leaving from add() of AccessM1 : ' + sum);
	}
	
}