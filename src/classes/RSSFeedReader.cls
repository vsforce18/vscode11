public class RSSFeedReader{
	public static RSSFeed.Channel getRSSData(string feedURL){
        feedURL = 'http://www.tigerdirect.com/xml/rsstigercat5116.xml';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(feedURL);
        req.setMethod('GET');
        req.setTimeout(10000);
    
        Dom.Document doc = new Dom.Document();
        Http h = new Http();
        if(!Test.isRunningTest()){
            HttpResponse res = h.send(req);
            doc = res.getBodyDocument();
		}/*else{
            String xmlString = '<?xml version="1.0" encoding="utf-8" ?><rss version="2.0" xmlns:os="http://a9.com/-/spec/opensearch/1.1/"><channel><title>salesforce.com - Bing News</title><link>http://www.bing.com/news</link><description>Search Results for salesforce.com at Bing.com</description><category>News</category><os:totalResults>3370</os:totalResults><os:startIndex>0</os:startIndex><os:itemsPerPage>10</os:itemsPerPage><os:Query role="request" searchTerms="salesforce.com" /><copyright>These XML results may not be used, reproduced or transmitted in any manner or for any purpose other than rendering Bing results within an RSS aggregator for your personal, non-commercial use. Any other use requires written permission from Microsoft Corporation. By using these results in any manner whatsoever, you agree to be bound by the foregoing restrictions.</copyright><image><url>http://www.bing.com/s/a/rsslogo.gif</url><title>Bing</title><link>http://www.bing.com/news</link></image><docs>http://www.rssboard.org/rss-specification</docs><item><title>Salesforce.com Makes Friends With CIOs - Information Week</title><guid>http://informationweek.com/news/cloud-computing/software/232602782</guid><link>http://informationweek.com/news/cloud-computing/software/232602782</link><description>Parade of CIOs at CloudForce shows how social networking inroads are making Salesforce.com a larger part of the IT infrastructure. Salesforce.com isn&apos;t just for sales forces anymore. Its Chatter app has opened a social networking avenue into the enterprise ...</description><pubDate>2012-03-19T15:21:47Z</pubDate><source>Information Week</source></item></channel></rss>';
			doc.load(xmlString);
		}*/
    
        Dom.XMLNode rss = doc.getRootElement();
        //first child element of rss feed is always channel
        Dom.XMLNode channel = rss.getChildElements()[0];
    
        RSSFeed.Channel result = new RSSFeed.Channel();
    
        list<RSSFeed.Item> rssItems = new list<RSSFeed.Item>();
    
        //for each node inside channel
        for(Dom.XMLNode elements : channel.getChildElements()) {
            if('title' == elements.getName()) {
                result.title = elements.getText();
            }
            if('link' == elements.getName()) {
                result.link = elements.getText();
            }
            if('description' == elements.getName()) {
                result.description = elements.getText();
            }
            if('copyright' == elements.getName()) {
                result.copyright = elements.getText();
            }
            if('language' == elements.getName()) {
                result.language = elements.getText();
            }
            /*if('category' == elements.getName()) {
                result.category = elements.getText();
            }
            if('docs' == elements.getName()) {
                result.docs = elements.getText();
            }*/
            if('image' == elements.getName()) {
                RSSFeed.Image img = new RSSFeed.Image();
                //for each node inside image
                for(Dom.XMLNode xmlImage : elements.getChildElements()) {
                    if('url' == xmlImage.getName()) {
                        img.url = xmlImage.getText();
                    }
                    if('title' == xmlImage.getName()) {
                        img.title = xmlImage.getText();
                    }
                    if('link' == xmlImage.getName()) {
                        img.link = xmlImage.getText();
                    }
                }
                result.image = img;
            }
    
            if('item' == elements.getName()) {
                RSSFeed.Item rssItem = new RSSFeed.Item();
                //for each node inside item
                for(Dom.XMLNode xmlItem : elements.getChildElements()) {
                    system.debug('*********** Item Name: '+ xmlItem + '\n' + xmlItem.getNodeType());
                    if('title' == xmlItem.getName()) {
                        rssItem.title = xmlItem.getText();
                    }
                    if('guid' == xmlItem.getName()) {
                        rssItem.guid = xmlItem.getText();
                    }
                    if('link' == xmlItem.getName()) {
                        rssItem.link = xmlItem.getText();
                    }
                    if('description' == xmlItem.getName()) {
                        system.debug('*********** The description-1: '+ xmlItem.getText());
                        rssItem.description = xmlItem.getText();
                        system.debug('*********** The description-2: '+ xmlItem.getText());
                    }
                    if('pubDate' == xmlItem.getName() || 'date' == xmlItem.getName()) {
                        rssItem.pubDate = xmlItem.getText();
                    }
                    if('source' == xmlItem.getName()){
                        rssItem.source = xmlItem.getText();
                    }
                    if('creator' == xmlItem.getName()){
                        rssItem.author = xmlItem.getText();
                    }
                }
                //for each item, add to rssItem list
                rssItems.add(rssItem);
            }
        }
        //finish RSSFeed.Channel object by adding the list of all rss items
        result.items = rssItems;
        return result;
    }
}