public without sharing class eDealsCnt {
    public List<e_Electronic__c> dList {get; set;}
    public String cg {get; set;}
    public String scg {get; set;}
    public String orderBy {get; set;}
    public String orderDir {get; set;}
    public String orderFld {get; set;}
    
    public eDealsCnt(){
        cg = Apexpages.currentPage().getParameters().get('cg');
        scg = Apexpages.currentPage().getParameters().get('scg');
        orderBy = Apexpages.currentPage().getParameters().get('orderBy');
        String obQry = '';
        system.debug('******** Now in eDealsCnt() values: ' + cg + '\t:' + scg + '\t:' + orderBy + '\tDirection: '+ orderDir);
        if(String.isBlank(orderDir)){
            orderFld = 'p';
            orderDir = 'ASC';
            orderBy = 'p';
            obQry = ' Price_Final__c ';
        }
        /*if(String.isBlank(orderBy))
            obQry = ' Price_Final__c ';
        else */if(String.isNotBlank(orderBy)){
            if(orderBy=='b'){//Brand
            	orderFld = 'b';
                obQry = ' Company__c ';
            }else if(orderBy=='s'){//Store
                orderFld = 's';
            	obQry = ' Merchant__r.Name ';
            }else if(orderBy=='t'){//Title
                orderFld = 't';
            	obQry = ' Title__c ';
            }else if(orderBy=='p'){//Price
                orderFld = 'p';
            	obQry = ' Price_Final__c ';
            }
        }
        system.debug('******** Now in eDealsCnt() values-2: ' + cg + '\t:' + scg + '\t:' + orderBy + '\tDirection: '+ orderDir);
        List<eCategory__mdt> ctList = [Select Category__c, Category_No__c, Sub_Category__c, Sub_Category_No__c from eCategory__mdt];
        Map<String, String> ctMap = new Map<String, String>();
        Map<String, String> sctMap = new Map<String, String>();
        for(eCategory__mdt ct : ctList){
            ctMap.put(ct.Category__c.replaceAll('[a-zA-Z-]', '').trim(), ct.Category__c.replaceAll('[0-9]', ''));
            sctMap.put(ct.Sub_Category__c.replaceAll('[a-zA-Z-]', '').trim(), ct.Sub_Category__c.replaceAll('[0-9]', ''));
        }
        /*dList = [Select Id, Name, Category__c, Company__c, Deal_Link__c, Description__c, Merchant__c, Img_Link__c, Img_Title__c, Img_URL__c, Price_Actual__c,
         			Price_Discounted__c, Price_Final__c, Sub_Category__c, Title__c from e_Electronic__c 
                 	where Deal_Link_Status__c='Working' limit 1999];
        */
        String qry = 'Select Id, Name, Category__c, Company__c, Company__r.Name, Deal_Link__c, Description__c, Merchant__c, Img_Link__c, Img_Title__c, Img_URL__c, Merchant__r.Name, Price_Actual__c,' 
            		+ 'Price_Discounted__c, Price_Final__c, Sub_Category__c, Title__c from e_Electronic__c '
            		+ 'where Deal_Link_Status__c=\'Working\'';
        String ct='', sct='';
        if(String.isNotBlank(cg)){
            qry += ' AND Category__c=\'' + ctMap.get(cg) + '\'';
        }
        if(String.isNotBlank(scg)){
            qry += ' AND Sub_Category__c=\'' + sctMap.get(scg) + '\'';
        }
        qry += ' Order by ' + obQry + orderDir;
        qry += ' limit 1999';
        system.debug('*********** The query: '+ qry);
        dList = Database.query(qry);
        system.debug('*********** The query results: '+ dList);
    }
    
    public PageReference orderByAction(){
        system.debug('******** Now in orderByAction() ');
        String cg = Apexpages.currentPage().getParameters().get('cg');
        String scg = Apexpages.currentPage().getParameters().get('scg');
        String orderBy = Apexpages.currentPage().getParameters().get('ob');
        system.debug('******** Now in orderByAction() values: ' + cg + '\t:' + scg + '\t:' + orderBy + '\tDirection: '+ orderDir);
        String obQry = '';
        if(String.isBlank(orderDir)){
            orderFld = 'p';
            orderDir = 'ASC';
            orderBy = 'p';
            obQry = ' Price_Final__c ';
            system.debug('******* Now in IFF DIR: ' + orderDir);
        }else if(orderDir=='ASC'){
            orderDir = 'DESC';
            system.debug('******* Now in ELSE DIR: ' + orderDir);
        }else{
            orderDir = 'ASC';
            system.debug('******* Now in ELSE ASC: ' + orderDir);
        }
        if(String.isBlank(orderBy)){
            orderFld = 'p';
            obQry = ' Price_Final__c ';
        }else if(String.isNotBlank(orderBy)){
            if(orderBy=='b'){//Brand
            	orderFld = 'b';
                obQry = ' Company__r.Name ';
            }else if(orderBy=='s'){//Store
                orderFld = 's';
            	obQry = ' Merchant__r.Name ';
            }else if(orderBy=='t'){//Title
                orderFld = 't';
            	obQry = ' Title__c ';
            }else if(orderBy=='p'){//Price
                orderFld = 'p';
            	obQry = ' Price_Final__c ';
            }
        }
        List<eCategory__mdt> ctList = [Select Category__c, Category_No__c, Sub_Category__c, Sub_Category_No__c from eCategory__mdt];
        Map<String, String> ctMap = new Map<String, String>();
        Map<String, String> sctMap = new Map<String, String>();
        for(eCategory__mdt ct : ctList){
            ctMap.put(ct.Category__c.replaceAll('[a-zA-Z-]', '').trim(), ct.Category__c.replaceAll('[0-9]', ''));
            sctMap.put(ct.Sub_Category__c.replaceAll('[a-zA-Z-]', '').trim(), ct.Sub_Category__c.replaceAll('[0-9]', ''));
        }
        /*dList = [Select Id, Name, Category__c, Company__c, Deal_Link__c, Description__c, Merchant__c, Img_Link__c, Img_Title__c, Img_URL__c, Price_Actual__c,
         			Price_Discounted__c, Price_Final__c, Sub_Category__c, Title__c from e_Electronic__c 
                 	where Deal_Link_Status__c='Working' limit 1999];
        */
        String qry = 'Select Id, Name, Category__c, Company__c, Company__r.Name, Deal_Link__c, Description__c, Merchant__c, Img_Link__c, Img_Title__c, Img_URL__c, Merchant__r.Name, Price_Actual__c,' 
            		+ 'Price_Discounted__c, Price_Final__c, Sub_Category__c, Title__c from e_Electronic__c '
            		+ 'where Deal_Link_Status__c=\'Working\'';
        String ct='', sct='';
        if(String.isNotBlank(cg)){
            qry += ' AND Category__c=\'' + ctMap.get(cg) + '\'';
        }
        if(String.isNotBlank(scg)){
            qry += ' AND Sub_Category__c=\'' + sctMap.get(scg) + '\'';
        }
        qry += 'Order by ' + obQry + orderDir;
        qry += ' limit 1999';
        system.debug('*********** The query: '+ qry);
        dList = Database.query(qry);
        system.debug('*********** The query results: '+ dList);
        system.debug('******** Leaving from orderByAction() ');
        return null;
    }
    
    
}