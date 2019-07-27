public class CM_WSListings{
    /**
     * Description: Coinmarket to get list of all Tickets and their ids
     */
    public static void cmGetList(){
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http h = new Http();
        
        String pageSize = '10';
        String endpoint = 'https://api.coinmarketcap.com/v2/listings/';
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        res = h.send(req);
        system.debug('************ The response-Listings: ' + res.getBody());
        String resStr = res.getBody();
        CM_TickerListingData tickerData = (CM_TickerListingData)JSON.deserialize(resStr, CM_TickerListingData.class);
        system.debug('************ The response-Listings-1: ' + tickerData);
        List<CM_TicketListings> tickerList = tickerData.data;
        system.debug('************ The response-Listings-2: ' + tickerList);
        List<Account> accList = new List<Account>();
        for(CM_TicketListings cmTicker: tickerList){
            //Account acc = new Account(Name=cmTicker.name, TickerSymbol=cmTicker.symbol, Ticker_Id__c=cmTicker.id, Website_slug__c=cmTicker.website_slug);
            accList.add(new Account(Name=cmTicker.name, TickerSymbol=cmTicker.symbol, Ticker_Id__c=cmTicker.id, Website_slug__c=cmTicker.website_slug, RecordTypeId='0121a000000eTHs'));//TODO:RecordTypeId hardcoding
        }
        if(!accList.isEmpty())
        	insert accList;
    }
    
    /**
     * Description: Coinmarket to get pricechange based on ticker ids
     */
    public static void cmGetTickerPriceChange(){
        system.debug('******* Entered into cmGetTickerPriceChange() of ' + CM_WSListings.class);
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http h = new Http();
        
        String pageSize = '5';
        String endpoint = 'https://api.coinmarketcap.com/v2/ticker/?start=1&limit=' + pageSize + '&sort=id';
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        res = h.send(req);
        system.debug('************ The response-Listings: ' + res.getBody());
        String resStr = res.getBody();
        CMTickerDO tickerDO = (CMTickerDO)JSON.deserialize(resStr, CMTickerDO.class);
        system.debug('************ The response-Listings-1: ' + tickerDO);
        
        Map<String, Account> accMap = new Map<String, Account>();
        for(Account acc : [select Id, Name, Ticker_Id__c from Account where RecordTypeId = '0121a000000eTHs']){
            accMap.put(acc.Ticker_Id__c, acc);
        }
        //List<CMTickerDO.Ticker> tickerList = new List<CMTickerDO.Ticker>();
        List<Coinmarket_History__c> cmHisList = new List<Coinmarket_History__c>();
        CMTickerDO.Metadata tickerMetadata = new CMTickerDO.Metadata();
        JSONParser jsonParser = JSON.createParser(res.getBody());
        //JSONParser jsonParser = JSON.createParser(abcStr);
        while(jsonParser.nextToken() != null){
            system.debug('************ JSON-0: ' + jsonParser.getCurrentToken());
            if(jsonParser.getCurrentToken() == JSONToken.START_OBJECT){//START_ARRAY
                system.debug('************ JSON-0-1: ' );
                while(jsonParser.nextToken() != JSONToken.END_OBJECT){//END_ARRAY
                    system.debug('************ JSON-1: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText());
                                 //+ '\n' + jsonParser.nextToken() + '\t' + jsonParser.nextValue());
                    //Data
                    if((jsonParser.getCurrentToken() == JSONToken.FIELD_NAME) && (jsonParser.getText() == 'data')){
                        system.debug('************ JSON-2: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText());
                        system.debug('************ JSON-2-1: ' + jsonParser.nextToken());
                        system.debug('************ JSON-2-11: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText());
                        system.debug('************ JSON-2-2: ' + jsonParser.nextToken());
                        system.debug('************ JSON-2-21: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText());
                        //system.debug('************ JSON-3-3: ' + jsonParser.nextToken());
                        //system.debug('************ JSON-3-31: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText());
                        while(jsonParser.nextToken() != JSONToken.END_OBJECT && '{'==jsonParser.getText()){
                            system.debug('************ JSON-4-0: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText());
                            CMTickerDO.Ticker obj = (CMTickerDO.Ticker)jsonParser.readValueAsStrict(CMTickerDO.Ticker.class);
                            system.debug('************ JSON-4-1: ' + obj);
                            CMTickerDO.Quotes quote = obj.quotes;
                            system.debug('************ JSON-4-2: ' + quote);
                            Integer lastUpdateMilli = obj.last_updated;
                            system.debug('************ JSON-4-3: ' + lastUpdateMilli);
                            //DateTime dt = DateTime.newInstance(Long.valueOf(lastUpdateMilli+''));
                            DateTime dt = datetime.newInstanceGmt(1970, 1, 1, 0, 0, 0);
                            DateTime dateTimeValue = dt.addSeconds(lastUpdateMilli);
                            system.debug('************ The response-Listings-1: ' + dateTimeValue);
                            
                            String curr = 'USD';
                            if(null!=quote.eur)
                                curr = 'EUR';
                            else if(null!=quote.inr)
                                curr = 'INR';
                            
                            Coinmarket_History__c cmHis = new Coinmarket_History__c(Account__c=accMap.get(obj.id+'').Id, Circulating_Supply__c=obj.circulating_supply, Last_Updated__c=dateTimeValue, Max_Supply__c=obj.max_supply, 
                                                                                    Currency__c=curr, Rank__c=obj.rank, Total_Supply__c=obj.total_supply, Market_Cap__c=quote.usd.market_cap, 
                                                                                    Percent_Change_1h__c=quote.usd.percent_change_1h, Percent_Change_24h__c=quote.usd.percent_change_24h, 
                                                                                    Percent_Change_7h__c=quote.usd.percent_change_7d, Price__c=quote.usd.price, Volume_24h__c=quote.usd.volume_24h);
                            //tickerList.add(obj);
                            cmHisList.add(cmHis);
                            system.debug('************ JSON-4-1: ' + obj + '\ncmHis: ' + cmHis);
                            jsonParser.nextToken();
                        }
                        system.debug('************ JSON-5: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText() + '\n\ncmHisList: '+ cmHisList);
                        
                        //Metadata
                        if((jsonParser.getCurrentToken() == JSONToken.FIELD_NAME) && (jsonParser.getText() == 'metadata')){
                            system.debug('************ JSON-5: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText());
                            jsonParser.nextToken();
                            tickerMetadata = (CMTickerDO.Metadata)jsonParser.readValueAsStrict(CMTickerDO.Metadata.class);
                            system.debug('************ JSON-5-1: ' + tickerMetadata);
                        }
                        //CMTickerDO tickerDO = (CMTickerDO)JSON.deserialize(jsonParser.getText(), CMTickerDO.class);
                        //system.debug('************ JSON-2-1: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText());
                    }
                        
                    /*if((jsonParser.getCurrentToken() == JSONToken.FIELD_NAME) &&(jsonParser.getText() == 'Key')){
                        system.debug('************ The response-Listings-2: ' + jsonParser.nextToken());
                    }
                    system.debug('************ JSON-END: ' + jsonParser.getCurrentToken() + '\t' + jsonParser.getText() 
                                 + '\n' + jsonParser.nextToken() + '\t' + jsonParser.nextValue());
                    */
                }
            }
        }
        
        
        /*CMTickerDO tickerDO = (CMTickerDO)JSON.deserialize(resStr, CMTickerDO.class);
        system.debug('************ The response-Listings-1: ' + tickerDO);
        /*List<CM_TicketListings> tickerList = tickerDO.data;
        system.debug('************ The response-Listings-2: ' + tickerList);
        List<Account> accList = new List<Account>();
        for(CM_TicketListings cmTicker: tickerList){
            //Account acc = new Account(Name=cmTicker.name, TickerSymbol=cmTicker.symbol, Ticker_Id__c=cmTicker.id, Website_slug__c=cmTicker.website_slug);
            accList.add(new Account(Name=cmTicker.name, TickerSymbol=cmTicker.symbol, Ticker_Id__c=cmTicker.id, Website_slug__c=cmTicker.website_slug, RecordTypeId='0121a000000eTHs'));//TODO:RecordTypeId hardcoding
        }*/
        if(!cmHisList.isEmpty())
        	insert cmHisList;
        system.debug('******* Leaving from cmGetTickerPriceChange() of ' + CM_WSListings.class + '\ncmHisList: ' + cmHisList);
    }
}