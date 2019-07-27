public virtual class ParentEg
{
	protected Integer i = 10;
	public Integer j = 20;
	
	public virtual void add(){
		system.debug('********** Sum in add() of ParentEg is: ' + (i+j));
	}
}