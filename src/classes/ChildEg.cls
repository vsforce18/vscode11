public class ChildEg extends ParentEg
{
	public void childMethod(){
		system.debug('************ Entered into childMethod() of ChildEg: ' +  i);
		/*ParentEg p = new ParentEg();
		p.add();
		*/
		add();
		system.debug('************ Leaving from childMethod() of ChildEg');
	}
	
	//Over ridden method [Over riding]
	public override void add(){
		system.debug('********** Sum in add() of ChildEg');
	}
}