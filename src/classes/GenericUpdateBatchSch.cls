/**
 * Description: Update records on various objects based on custom meta-data configuration using schedule job.
 * 
 * Modification Log:
 * --------------------------------------------------------------------------------------
 * Date			Verion	Developer Name		Description
 * -------------------------------------------------------------------------------------- 
 * 05/21/2018	1.0		Venkat Mallipeddi	Created: Invoke batch class to execute at regular intervals of time
 * 
 */
global class GenericUpdateBatchSch implements System.Schedulable{
    /**
     * Description: Execute batch apex to run at scheduled intervals based on custom meta-data
     */
    global void execute(System.SchedulableContext sc){
        system.debug('Entered into execute() of '+ GenericUpdateBatchSch.class);
        for(Batch_Map__mdt bMap : [select DeveloperName, Active__c, sObj__c, Source_Fld__c, Source_Fld__r.QualifiedApiName, Source_Fld_Val__c, Target_Fld__c, Target_Fld__r.QualifiedApiName, Target_Fld_Val__c, Record_Type_Name__c from Batch_Map__mdt where Active__c=true limit 99]){
            if(bMap.Active__c && String.isNotBlank(bMap.sObj__c) && String.isNotBlank(bMap.Source_Fld__c) 
               && String.isNotBlank(bMap.Target_Fld__c) && String.isNotBlank(bMap.Target_Fld_Val__c) 
               && String.isNotBlank(bMap.Record_Type_Name__c))
            	Database.executeBatch(new GenericUpdateBatch(bMap.sObj__c, bMap.Source_Fld__r.QualifiedApiName, bMap.Source_Fld_Val__c, bMap.Target_Fld__r.QualifiedApiName, bMap.Target_Fld_Val__c, bMap.Record_Type_Name__c	));
        }
        system.debug('Leaving from execute() of '+ GenericUpdateBatchSch.class);
    }
}