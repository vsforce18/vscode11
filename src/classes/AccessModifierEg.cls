public class AccessModifierEg {
	public void demoPublic(){
		AccessM1 a = new AccessM1();
		//system.debug('********** i value from AccessM: '+ a.i);
		//system.debug('********** j value from AccessM: '+ a.j);
		
		system.debug('********** sum of i+j :  ');
		a.add();
		
	}
}