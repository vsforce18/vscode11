/**
* Description:  All DB operations across triggers and controllers is implemented here
*       1. Insert: Record Creation and error handling is handled here
*       2. Delete: Record Deletion and error handling is handled here
*
*   Modification Log : 
---------------------------------------------------------------------------
    Developer               Date                Description
---------------------------------------------------------------------------
    Venkat Mallipeddi       03/10/2018          Created
******************************************************************************************/

public without sharing class DatabaseUtility{
    /**
    * Record creation and handling errors associated to the insertion is handled
    *
    * @param sobjList		Records toe be created
    * @param sobjName		Name of the object into which records are going to be created
    * @param clsName		Apex ClassName from where it is invoked
    * @param methodName		Apex method name from where it is invoked
    */
    public static void createRecords(List<sObject> sobjList, String sobjName, String clsName, String methodName){
        //List<ErrorLog__c> errorsList = new List <ErrorLog__c> ();
        Database.SaveResult[] dbResult = Database.insert(sobjList, false);
        for(Integer i=0; i<dbResult.size(); i++){
            if (!dbResult[i].isSuccess()) {
                /*
                Create an Error object and write into error object.
				for(Database.Error err : dbResult[i].getErrors()){
                    ErrorLog__c errLog = new ErrorLog__c(Message__c= 'Error: ' +err.getStatusCode() + ';  Field: '+err.getFields() + ';  Error Messages: ' +err.getMessage() + ';  Failed Record: '+ sobjList[i]);
                    errorsList.add(errLog);
                }*/
            }
        }
        /*if(!errorsList.isEmpty()){
            DatabaseUtility.createRecords(errorsList, 'ErrorLog__c', 'DatabaseUtility', 'createRecords');
        }*/
    }
    
    /**
    * Record deletion and handling errors associated to the insertion is handled
    *
    * @param sobjList		Records toe be created
    * @param sobjName		Name of the object into which records are going to be created
    * @param clsName		Apex ClassName from where it is invoked
    * @param methodName		Apex method name from where it is invoked
    */
    public static void deleteRecords(List<sObject> sobjList, String sobjName, String clsName, String methodName){
        //List<ErrorLog__c> errorsList = new List <ErrorLog__c> ();
        Database.DeleteResult[] dbResult = Database.delete(sobjList, false);
        for(Integer i=0; i<dbResult.size(); i++){
            if (!dbResult[i].isSuccess()) {
                /*
                Create an Error object and write into error object.
				for(Database.Error err : dbResult[i].getErrors()){
                    ErrorLog__c errLog = new ErrorLog__c(Message__c= 'Error: ' +err.getStatusCode() + ';  Field: '+err.getFields() + ';  Error Messages: ' +err.getMessage() + ';  Failed Record: '+ sobjList[i]);
                    errorsList.add(errLog);
                }*/
            }
        }
        /*if(!errorsList.isEmpty())
            DatabaseUtility.createRecords(errorsList, 'ErrorLog__c', 'DatabaseUtility', 'deleteRecords');
        */
    }
}