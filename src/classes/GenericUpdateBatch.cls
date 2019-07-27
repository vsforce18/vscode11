/**
 * Description: Update records on various objects based on custom meta-data configuration.
 * 
 * Modification Log:
 * --------------------------------------------------------------------------------------
 * Date			Verion	Developer Name		Description
 * -------------------------------------------------------------------------------------- 
 * 05/21/2018	1.0		Venkat Mallipeddi	Created: Update various sobject records based on source and target field values
 * 
 */
global class GenericUpdateBatch implements Database.Batchable<sObject>, Database.Stateful{
    private String srcObj; //It is Source and Target sObject records to update
    private String srcFld; //It is Source field for criteria
    private String targetFld; //It is Target field to update
    private String srcVal; //It has Source field value to filter records eligible for update
    private String targetVal; //It has Target field value to update with
    private Id rtId; //IT has Source RecordType value to filter records eligible for update
    private String qryStr; //Construct query dynamically
    
    /**
     * Description: Constructor to initialize parameters like sObject, Source & Target fields and their values
     */
    public GenericUpdateBatch(String srcObj, String srcFld, String srcVal, String targetFld, String targetVal, String rtName){
        system.debug('Entered into GenericUpdateBatch() of '+ GenericUpdateBatch.class);
        //Get recordtypeid based on RecordType Name from an sObject
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(srcObj).getDescribe();
        List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
        for(Schema.RecordTypeInfo rtInfo : recordTypeInfo){
            if(rtName.equalsIgnoreCase(rtInfo.getName()))
                this.rtId = rtInfo.getRecordTypeId();
        }
        this.srcObj = srcObj;
        this.srcFld = srcFld;
        this.srcVal = srcVal;
        this.targetFld = targetFld;
        this.targetVal = targetVal;
        system.debug('************ The constructor-2: ' + srcObj + '\t' + srcFld + '\t' +targetFld + '\t' + targetVal + '\trtName: ' + rtName);
        system.debug('Leaving from GenericUpdateBatch() of '+ GenericUpdateBatch.class);
    }
    
    /**
     * Description: Execute query and return result set to execute method
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('Entered into start() of '+ GenericUpdateBatch.class);
        system.debug('Leaving from start() of '+ GenericUpdateBatch.class);
        return Database.getQueryLocator(getQuery());
    }
    
    /**
     * Description: Perform actual busniess logic to update records
     */
    global void execute(Database.BatchableContext bc, List<sObject> recList){
        system.debug('Entered into execute() of '+ GenericUpdateBatch.class);
        SObjectType objToken = Schema.getGlobalDescribe().get(srcObj);
		DescribeSObjectResult objDef = objToken.getDescribe();
		Map<String, SObjectField> fields = objDef.fields.getMap();
		for(sObject rec: recList){
			rec.put(targetFld, targetVal);
		}
		Database.update(recList, false);
        system.debug('Leaving from execute() of '+ GenericUpdateBatch.class);
    }
    
    /**
     * Description: Finally if any Email Alert etc. right now nothing is performed.
     */
    global void finish(Database.BatchableContext bc){
        system.debug('Entered into finish() of '+ GenericUpdateBatch.class);
        
        system.debug('Leaving from finish() of '+ GenericUpdateBatch.class);
    }
    
    /**
     * Description: Construct dynamic query
     */
    private String getQuery(){
        system.debug('Entered into getQuery() of '+ GenericUpdateBatch.class);
        String whereStr = 'RecordTypeId= \'' + this.rtId + '\'';
        if(null==this.srcVal)
            whereStr += ' AND ' + this.srcFld + '=null';
        else if(null!=this.srcVal && (this.srcVal.isNumeric() || 'true'.equalsIgnoreCase(this.srcVal) || 'false'.equalsIgnoreCase(this.srcVal)))
            whereStr += ' AND ' + this.srcFld + '='+ this.srcVal + '';
        else
            whereStr += ' AND ' + this.srcFld + '=\''+ this.srcVal + '\'';
        qryStr = 'select Id, Name, ' + this.targetFld + ' from ' + this.srcObj + ' where ' + whereStr;
        system.debug('Leaving from getQuery() of '+ GenericUpdateBatch.class);
        return qryStr;
    }
}