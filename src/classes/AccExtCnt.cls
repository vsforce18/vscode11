public with sharing class AccExtCnt {
    public Boolean flag {get; set;}
    
    public AccExtCnt(ApexPages.StandardController controller) {
        flag = false;
    }
    
    public PageReference displaySec(){
        system.debug('************* displaySec START *********** : '+ flag);
        flag = true;
        system.debug('************* displaySec END ***********');
        return null;
    }
}