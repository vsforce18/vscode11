global class CoinMarketBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    //private static Integer startIndex = 1;
    private static List<Coinmarket_History__c> cmHisList = new List<Coinmarket_History__c>();
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug(LoggingLevel.ERROR, '******* Entered into start() of ' + CoinMarketBatch.class);
        return Database.getQueryLocator('select Name, TickerSymbol from Account where RecordType.Name=\'Coinmarket\'');
    }
	global void execute(Database.BatchableContext bc, List<sObject> sobjList){
        system.debug('******* Entered into execute() of ' + CoinMarketBatch.class + '\t' + sobjList.size());
        //startIndex = 1;
        Integer lmt = 100;
        for(Integer i=1; i<=sobjList.size(); i=i+lmt){
            //startIndex = i;
            system.debug(LoggingLevel.ERROR, '******* Entered into execute()-1: ' + i + '\t' + lmt);
            cmGetTickerPriceChange(i, lmt);
        }
        system.debug(LoggingLevel.ERROR, '******* Leaving from execute() of ' + cmHisList.size());
        if(!cmHisList.isEmpty())
        	insert cmHisList;
        	//CM_DatabaseUtility.createRecords(JSON.serializePretty(cmHisList), 'Coinmarket_History__c', 'CoinMarketBatch', 'cmGetTickerPriceChange');
        	//new CM_DatabaseUtility(JSON.serializePretty(cmHisList), 'Coinmarket_History__c', 'CoinMarketBatch', 'cmGetTickerPriceChange');
        	//System.enqueueJob(new CM_DatabaseUtility(JSON.serializePretty(cmHisList), 'Coinmarket_History__c', 'CoinMarketBatch', 'cmGetTickerPriceChange'));

        system.debug('******* Leaving from execute() of ' + CoinMarketBatch.class);
    }
    
    global void finish(Database.BatchableContext bc){
        system.debug('******* Entered into finish() of ' + CoinMarketBatch.class);
        system.debug('******* Leaving from finish() of ' + CoinMarketBatch.class);
    }
    
    /**
     * Description: Coinmarket to get pricechange based on ticker ids
     */
    public static void cmGetTickerPriceChange(Integer startIndex, Integer lmt){
        system.debug('******* Entered into cmGetTickerPriceChange() of ' + CM_WSListings.class + '\n' + startIndex + '\t' + lmt);
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http h = new Http();
        
        //String pageSize = '100';
        String endpoint = 'https://api.coinmarketcap.com/v2/ticker/?start=' + startIndex + '&limit=' + lmt + '&sort=id';
        system.debug(LoggingLevel.ERROR, '******* Entered into cmGetTickerPriceChange()-1' + endpoint);
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        res = h.send(req);
        //system.debug('************ The response-Listings: ' + res.getBody());
        String resStr = res.getBody();
        CMTickerDO tickerDO = (CMTickerDO)JSON.deserialize(resStr, CMTickerDO.class);
        //system.debug('************ The response-Listings-1: ' + tickerDO);
        
        Map<String, Account> accMap = new Map<String, Account>();
        for(Account acc : [select Id, Name, Ticker_Id__c from Account where RecordTypeId = '0121a000000eTHs']){
            accMap.put(acc.Ticker_Id__c, acc);
        }
        //List<CMTickerDO.Ticker> tickerList = new List<CMTickerDO.Ticker>();
        CMTickerDO.Metadata tickerMetadata = new CMTickerDO.Metadata();
        JSONParser jsonParser = JSON.createParser(res.getBody());
        //JSONParser jsonParser = JSON.createParser(abcStr);
        while(jsonParser.nextToken() != null){
            //system.debug('************ JSON-0: ' + jsonParser.getCurrentToken());
            if(jsonParser.getCurrentToken() == JSONToken.START_OBJECT){//START_ARRAY
                //system.debug('************ JSON-0-1: ' );
                while(jsonParser.nextToken() != JSONToken.END_OBJECT){//END_ARRAY
                    //system.debug('************ JSON-1: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText());
                                 //+ '\n' + jsonParser.nextToken() + '\t' + jsonParser.nextValue());
                    //Data
                    if((jsonParser.getCurrentToken() == JSONToken.FIELD_NAME) && (jsonParser.getText() == 'data')){
                        /*system.debug('************ JSON-2: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText());
                        system.debug('************ JSON-2-1: ' + jsonParser.nextToken());
                        system.debug('************ JSON-2-11: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText());
                        system.debug('************ JSON-2-2: ' + jsonParser.nextToken());
                        system.debug('************ JSON-2-21: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText());
                        //system.debug('************ JSON-3-3: ' + jsonParser.nextToken());
                        //system.debug('************ JSON-3-31: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText());
                        */
                        jsonParser.nextToken();
                        jsonParser.nextToken();
                        while(jsonParser.nextToken() != JSONToken.END_OBJECT && '{'==jsonParser.getText()){
                            //system.debug('************ JSON-4-0: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText());
                            CMTickerDO.Ticker obj = (CMTickerDO.Ticker)jsonParser.readValueAsStrict(CMTickerDO.Ticker.class);
                            system.debug(LoggingLevel.ERROR, '************ JSON-4-1: ' + obj);
                            CMTickerDO.Quotes quote = null;
                            if(null!=obj.quotes)
                            	quote = obj.quotes;
                            //system.debug('************ JSON-4-2: ' + quote);
                            Integer lastUpdateMilli;
                            DateTime dateTimeValue = null;
                            if(null!=obj.last_updated && obj.last_updated>0){
                            	lastUpdateMilli = obj.last_updated;
                            	//system.debug('************ JSON-4-3: ' + lastUpdateMilli);
                            	//DateTime dt = DateTime.newInstance(Long.valueOf(lastUpdateMilli+''));
                            	DateTime dt = datetime.newInstanceGmt(1970, 1, 1, 0, 0, 0);
                                if(lastUpdateMilli>0)
                            		dateTimeValue = dt.addSeconds(lastUpdateMilli);
                            	//system.debug('************ The response-Listings-1: ' + dateTimeValue);
                        	}
                            String curr = 'USD';
                            if(null!=quote.eur)
                                curr = 'EUR';
                            else if(null!=quote.inr)
                                curr = 'INR';
                            
                            /*public Integer id {get; set;}
        public String name {get; set;}
        public String symbol {get; set;}
        public String website_slug {get; set;}
        public Integer rank {get; set;}
        public Decimal circulating_supply {get; set;}
        public Decimal total_supply {get; set;}
        public Decimal max_supply {get; set;}
        public Integer last_updated {get; set;}
        public CMTickerDO.Quotes quotes {get; set;}
*/                            

                            
                            
                            /*Coinmarket_History__c cmHis = new Coinmarket_History__c(Account__c=accMap.get(obj.id+'').Id, Circulating_Supply__c=(null!=obj.circulating_supply && obj.circulating_supply>0?obj.circulating_supply:0), Last_Updated__c=dateTimeValue, Max_Supply__c=(null!=obj.max_supply && obj.max_supply>0?obj.max_supply:0), 
                                                                                    Currency__c=curr, Rank__c=(null!=obj.rank && obj.rank>0?obj.rank:0), Total_Supply__c=(null!=obj.total_supply && obj.total_supply>0?obj.total_supply:0), Market_Cap__c=(null!=quote.usd.market_cap && quote.usd.market_cap>0?quote.usd.market_cap:0), 
                                                                                    Percent_Change_1h__c=(null!=quote.usd.percent_change_1h && quote.usd.percent_change_1h>0?quote.usd.percent_change_1h:0), Percent_Change_24h__c=(null!=quote.usd.percent_change_24h && quote.usd.percent_change_24h>0?quote.usd.percent_change_24h:0), 
                                                                                    Percent_Change_7h__c=(null!=quote.usd.percent_change_7d && quote.usd.percent_change_7d>0?quote.usd.percent_change_7d:0), Price__c=(null!=quote.usd.price && quote.usd.price>0?quote.usd.price:0), Volume_24h__c=(null!=quote.usd.volume_24h && quote.usd.volume_24h>0?quote.usd.volume_24h:0));
                            */
                            
                            if(null!=obj.id && accMap.containsKey(obj.id+'')){
                                Coinmarket_History__c cmHis = new Coinmarket_History__c();
                            	cmHis.Account__c = accMap.get(obj.id+'').Id;
                                cmHis.Circulating_Supply__c = (null!=obj.circulating_supply && obj.circulating_supply>0?obj.circulating_supply:0);
                                if(null!=dateTimeValue)
                                    cmHis.Last_Updated__c=dateTimeValue;
                                cmHis.Max_Supply__c=(null!=obj.max_supply && obj.max_supply>0?obj.max_supply:0);
                                cmHis.Currency__c=curr;
                                cmHis.Rank__c=(null!=obj.rank && obj.rank>0?obj.rank:0);
                                cmHis.Total_Supply__c=(null!=obj.total_supply && obj.total_supply>0?obj.total_supply:0);
                                cmHis.Market_Cap__c=(null!=quote.usd.market_cap && quote.usd.market_cap>0?quote.usd.market_cap:0);
                                cmHis.Percent_Change_1h__c=(null!=quote.usd.percent_change_1h && quote.usd.percent_change_1h>0?quote.usd.percent_change_1h:0);
                                cmHis.Percent_Change_24h__c=(null!=quote.usd.percent_change_24h && quote.usd.percent_change_24h>0?quote.usd.percent_change_24h:0);
                                cmHis.Percent_Change_7h__c=(null!=quote.usd.percent_change_7d && quote.usd.percent_change_7d>0?quote.usd.percent_change_7d:0);
                                cmHis.Price__c=(null!=quote.usd.price && quote.usd.price>0?quote.usd.price:0);
                                cmHis.Volume_24h__c=(null!=quote.usd.volume_24h && quote.usd.volume_24h>0?quote.usd.volume_24h:0);
                                
                                //tickerList.add(obj);
                                cmHisList.add(cmHis);
                            }
                            //system.debug('************ JSON-4-1: ' + obj + '\ncmHis: ' + cmHis);
                            jsonParser.nextToken();
                        }
                        //system.debug('************ JSON-5: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText() + '\n\ncmHisList: '+ cmHisList);
                        
                        //Metadata
                        if((jsonParser.getCurrentToken() == JSONToken.FIELD_NAME) && (jsonParser.getText() == 'metadata')){
                            //system.debug('************ JSON-5: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText());
                            jsonParser.nextToken();
                            tickerMetadata = (CMTickerDO.Metadata)jsonParser.readValueAsStrict(CMTickerDO.Metadata.class);
                            //system.debug('************ JSON-5-1: ' + tickerMetadata);
                        }
                    }
                }
            }
        }
        /*if(!cmHisList.isEmpty())
        	//insert cmHisList;
        	//CM_DatabaseUtility.createRecords(JSON.serializePretty(cmHisList), 'Coinmarket_History__c', 'CoinMarketBatch', 'cmGetTickerPriceChange');
        	//new CM_DatabaseUtility(JSON.serializePretty(cmHisList), 'Coinmarket_History__c', 'CoinMarketBatch', 'cmGetTickerPriceChange');
        	System.enqueueJob(new CM_DatabaseUtility(JSON.serializePretty(cmHisList), 'Coinmarket_History__c', 'CoinMarketBatch', 'cmGetTickerPriceChange'));
		*/
        system.debug('******* Leaving from cmGetTickerPriceChange() of ' + CM_WSListings.class + '\ncmHisList: ' + cmHisList);
    }
}