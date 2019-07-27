public without sharing class CM_DatabaseUtility implements Queueable{
    public String jsonStr;
    public String sobjName;
    public String clsName;
    public String methodName;
    
    public CM_DatabaseUtility(String jsonStr, String sobjName, String clsName, String methodName){
        this.jsonStr = jsonStr;
        this.sobjName = jsonStr;
        this.clsName = clsName;
        this.methodName = methodName;
    }
    
    public void execute(QueueableContext context){
        createRecords(this.jsonStr, this.sobjName, this.clsName, this.methodName);
    }
    
	/**
    * Record creation and handling errors associated to the insertion is handled
    *
    * @param sobjList		Records toe be created
    * @param sobjName		Name of the object into which records are going to be created
    * @param clsName		Apex ClassName from where it is invoked
    * @param methodName		Apex method name from where it is invoked
    */
    public static void createRecords(String jsonStr, String sobjName, String clsName, String methodName){
        List<Coinmarket_History__c> sobjList = new List<Coinmarket_History__c>();
        sobjList =  (list<Coinmarket_History__c>)JSON.deserializeStrict(jsonStr, List<Coinmarket_History__c>.class);
    	system.debug('************** The values: ' + sobjList);
        Database.SaveResult[] dbResult = Database.insert(sobjList, false);
        for(Integer i=0; i<dbResult.size(); i++){
            if (!dbResult[i].isSuccess()) {
            }
        }
    }
}