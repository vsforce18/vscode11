public class StaticEg
{
	public static integer i = 10; //Static
	public static String str = 'This is non-static string'; //Instance
	
	static{
		system.debug('*************** This is static context **************');	
	}
	
	public static void demoStatic()
	{
		system.debug('************* Now in demoStatic() method **************\n');
		system.debug(i + '\n');
		system.debug(str);
	}
}