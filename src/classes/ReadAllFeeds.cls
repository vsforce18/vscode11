public class ReadAllFeeds {
    public void readAllFeeds(){
        /*
         * 1. Get all feed URLs
         * 2. Get each feed Items
         * 3. Save into All_Deals__c object
         */
        //Integer pi = 0;
        List<Feed_Channel__c> allChList = new List<Feed_Channel__c>();
		List<Feed_Item__c> allDealsList = new List<Feed_Item__c>();
        Map<Integer, List<Feed_Item__c>> pi2DealsMap = new Map<Integer, List<Feed_Item__c>>();
        for(Feed_Channel__c feed : [select Id, Name, Category__c, Company_Name__c, Copyright__c, Description__c, Img_Link__c, Img_Title__c, Img_URL__c, Language__c, Link__c, RSS_Feed_URL__c, Sub_Category__c, Title__c from Feed_Channel__c order by Company_Name__c asc]){
            //pi += 1;
            //RSSFeed.Channel rssFeedChannel = RSSFeedReader.getRSSData(feed.RSS_Feed_URL__c);
            RSSFeed.Channel rssFeedChannel = (new RSSFeedReaderStream()).getRSSData(feed.RSS_Feed_URL__c);
            //Process each Feed URL
            
            //Channel - Update Channel information for each feed url
            feed.Copyright__c = rssFeedChannel.copyright;
            feed.Description__c = rssFeedChannel.description;
            feed.Language__c = rssFeedChannel.language;//TODO: Might need to do more processing
            feed.Link__c = rssFeedChannel.link;
            feed.Title__c = rssFeedChannel.title;
            
            //Image - Update Channel Image information for each feed url
            RSSFeed.Image feedImg = rssFeedChannel.image;
            if(null!=feedImg){
                feed.Img_Link__c = feedImg.link;
                feed.Img_Title__c = feedImg.title;
                feed.Img_URL__c = feedImg.url;
            }
            allChList.add(feed);
            
            //Item - Create/Update new Items for each Channel
            List<RSSFeed.Item> feedItems = rssFeedChannel.items;
            //List<Feed_Item__c> eachChDealsList = new List<Feed_Item__c>();
            if(null!=feedItems && !feedItems.isEmpty()){
                for(RSSFeed.Item item : feedItems){
                    Feed_Item__c deal = new Feed_Item__c();
                    deal.Feed_Channel__c = feed.Id; //Parent Feed Channel
                    deal.Author__c = item.author;
                    //deal.Category__c = item.;
                    //deal.Comments__c = item.;
                    deal.Description__c = item.description;
                    deal.Guid__c = item.guid;
                    deal.Link__c = item.link;
                    if(String.isNotBlank(item.pubDate))
                    	deal.PubDate__c = (DateTime)Json.deserialize('"'+item.pubDate+'"', DateTime.class);
                    deal.Source__c = item.source;
                    deal.Title__c = item.title;
                    
                    //All Custom formatted fields
                    deal.Price__c = Double.valueOf(item.price);
                    allDealsList.add(deal);
                    //eachChDealsList.add(deal);
                }
                //pi2DealsMap.put(pi, eachChDealsList);
            }
        }
        
        //Create all Feed Channel records
        update allChList;
        
        /*//Associate each Channel to items
        for(All_Feed_Channel__c ch : allChList){
            for(All_Deals__c allDeal : pi2DealsMap.get(ch.Process_Index__c.intValue())){
                allDeal.All_Feed_Channel__c = ch.Id;
                allDealsList.add(allDeal);
            }
        }*/
        
        //Create all Deals records
        insert allDealsList;
    }
}