public class AccountCustCnt {
    public List<Account> accList {get; set;}
    
    public AccountCustCnt(){
        accList = [select Name, AccountNumber, AccountSource from Account limit 10];
    }
    
    public PageReference saveAcc(){
        accList = null;
        try{
            insert accList;
        }catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, 'You made records as null');
            ApexPages.addMessage(msg);
        }
        return null;
    }
}