public with sharing class AccounExtCnt {

    public AccounExtCnt(ApexPages.StandardController controller) {
        Account acc = (Account) controller.getRecord();
        List<Contact> conList = acc.contacts;
    }

}