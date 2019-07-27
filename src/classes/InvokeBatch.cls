/**
 * Description: Update records on various objects based on custom meta-data configuration.
 * 
 * Modification Log:
 * --------------------------------------------------------------------------------------
 * Date			Verion	Developer Name		Description
 * -------------------------------------------------------------------------------------- 
 * 05/21/2018	1.0		Venkat Mallipeddi	Created: Invoke batch from this class.
 * NOTE: If want to schedule this every day, we can use schedule class
 */
public class InvokeBatch{
    public static void invokeBatch(){
        system.debug('Entered into invokeBatch() of ' + InvokeBatch.class);
        for(Batch_Map__mdt bMap : [select DeveloperName, Active__c, sObj__c, Source_Fld__c, Source_Fld__r.QualifiedApiName, Source_Fld_Val__c, Target_Fld__c, Target_Fld__r.QualifiedApiName, Target_Fld_Val__c, Record_Type_Name__c from Batch_Map__mdt where Active__c=true limit 99]){
            if(bMap.Active__c && String.isNotBlank(bMap.sObj__c) && String.isNotBlank(bMap.Source_Fld__c) 
               && String.isNotBlank(bMap.Target_Fld__c) && String.isNotBlank(bMap.Target_Fld_Val__c) 
               && String.isNotBlank(bMap.Record_Type_Name__c))
            	Database.executeBatch(new GenericUpdateBatch(bMap.sObj__c, bMap.Source_Fld__r.QualifiedApiName, bMap.Source_Fld_Val__c, bMap.Target_Fld__r.QualifiedApiName, bMap.Target_Fld_Val__c, bMap.Record_Type_Name__c	));
        }
        system.debug('Leaving from invokeBatch() of ' + InvokeBatch.class);
    }
}