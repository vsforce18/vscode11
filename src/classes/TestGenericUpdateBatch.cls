/**
 * Description: Test class to cover GenericUpdateBatch, InvokeBatch, GenericBatchSch apex classes
 */
@isTest public class TestGenericUpdateBatch{
    /**
     * Description: Generate test data required for various test methods in this class
     */
    @testSetup static void generateData(){
        //Get Record Type
        Id rtId;
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get('Account').getDescribe();
        List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
        for(Schema.RecordTypeInfo rtInfo : recordTypeInfo){
            if('Customer Account'.equalsIgnoreCase(rtInfo.getName()))
                rtId = rtInfo.getRecordTypeId();
        }
        //Create Accounts
        List<Account> accList = new List<Account>();
        for(Integer i=0; i<200; i++){
            Account acc = new Account(Name='Acc'+i, Enterprise_Account_Status__c=null, RecordTypeId=rtId);
            if(i<100)
                acc.Gold_Account__c=false;
            else
                acc.Gold_Account__c=true;
            accList.add(acc);
        }
        insert accList;
    }
    
    /**
     * Description: Coverage for GenericUpdateBatch, InvokeBatch, GenericBatchSch apex classes
     */
    @isTest public static void testGenericBatch(){
        Test.startTest();
        //Batch Class
        Database.executeBatch(new GenericUpdateBatch('Account', 'Gold_Account__c', 'true', 'Enterprise_Account_Status__c', 'Gold', 'Customer Account'));
        //Apex class
        InvokeBatch.invokeBatch();
        
        //Schedule class
        String sch = '0 59 8 * * ?';
        String schJobId = system.schedule('Generic Update Job', sch, new GenericUpdateBatchSch());
        //stem.schedule('Generic Update Job', sch, sh1);
        Test.stopTest();
    }
}