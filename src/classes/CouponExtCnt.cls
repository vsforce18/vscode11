public class CouponExtCnt {
    //public List<Coupon__c> couponList {get; set;}
    public static final Integer PAGE_SIZE = 25;
    public Integer totalRecCount {get;set;} //Holds total coupons records count
    private Integer swapPgNumber; //temp variable holds pageNumber on page sorting
    
    public transient List<Coupon__c> couponList {get;private set;} //Coupons list to display to in the table
    
    public CouponExtCnt(Apexpages.StandardController std){
        totalRecCount = 0;
        pageNumber = 0;
        couponList = new List<Coupon__c>();
        
        initialLoad();
    }
    
    public ApexPages.StandardSetController couponSetCnt {get; set;}
    public void initialLoad(){
        String queryStr = 'Select Id, Name, Affiliate_Link__c, Categories__c, Coupon_Code__c, Coupon_Type__c, Coupon_Value__c, Description__c, Direct_Link__c, End_Date_Time__c, Label__c, Merchant__c, Merchant__r.Name, Merchant_Id__c, Restrictions__c, Start_Date_Time__c, Status__c from Coupon__c';
        if(string.isNotBlank(queryStr)){
            couponSetCnt = new ApexPages.StandardSetController(Database.getQueryLocator(queryStr + ' order by Name ' + sortDir +' LIMIT 10000'));
        }
        if(null!=couponSetCnt && couponSetCnt.getResultSize()>0){
            totalRecCount = couponSetCnt.getResultSize();
            couponSetCnt.setPageSize(PAGE_SIZE);
            couponList = (List<Coupon__c>)couponSetCnt.getRecords();
            pageNumber = couponSetCnt.getPageNumber() ;
        }else{
            pageNumber = couponSetCnt.getResultSize();
            couponSetCnt = null;
        }
        
        if(swapPgNumber>0 && swapPgNumber!=pageNumber && couponSetCnt!=null) {
            couponSetCnt.setPageNumber(swapPgNumber);
            swapPgNumber = 0;
        }
	}
    
    // the current sort direction. defaults to asc
    public String sortDir{
        get{
            if(sortDir==null){
                sortDir='desc';
            }
            return sortDir;
		}
        set;
    }
    
    // returns the page number of the current page set
    public Integer pageNumber{
        get{
            return (null!=couponSetCnt? (couponSetCnt.getResultSize()==0 ? 0:couponSetCnt.getPageNumber()): 0);
        }
        set;
    }
    
    // indicates whether there are more records after the current page set.
    public Boolean hasNext{
        get{
            return (couponSetCnt!=null?couponSetCnt.getHasNext() : false);
        }
        set;
    }
    
    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious{
        get{
            return (null!=couponSetCnt?couponSetCnt.getHasPrevious() : false);
        }
        set;
	}
    
    // returns the first page of interaction records
    public void first(){
        couponSetCnt.first();
        couponList = (List<Coupon__c>)couponSetCnt.getRecords();
	}
    
    // returns the last page of interaction records
    public void last(){
        couponSetCnt.last();
        couponList = (List<Coupon__c>)couponSetCnt.getRecords();
	}
    
    // returns the previous page of interaction records
    public void previous(){
        couponSetCnt.previous();
        couponList = (List<Coupon__c>)couponSetCnt.getRecords();
    }
    
    // returns the next page of interaction records
    public void next(){
        couponSetCnt.next();
        couponList= (List<Coupon__c>)couponSetCnt.getRecords();
	}
}