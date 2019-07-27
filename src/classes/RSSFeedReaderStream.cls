public class RSSFeedReaderStream{
	public RSSFeed.Channel result = null;
	public List<RSSFeed.Item> rssItems = null;
    
    public RSSFeedReaderStream(){
        result = new RSSFeed.Channel();
		rssItems = new List<RSSFeed.Item>();
    }
    
    public RSSFeed.Channel getRSSData(String feedURL){
        feedURL = 'http://www.tigerdirect.com/xml/rsstigercat5116.xml';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(feedURL);
        req.setMethod('GET');
        req.setTimeout(10000);
    	
        Xmlstreamreader reader;
        Dom.Document doc = new Dom.Document();
        Http h = new Http();
        if(!Test.isRunningTest()){
            HttpResponse res = h.send(req);
            system.debug('************* The response-1: '+ res);
            //res = res.getBody();
            system.debug('************* The response-2: '+ res.getBody());
            system.debug('************* The response-3: '+ res.getXmlStreamReader());
            system.debug('************* The response-3-1: '+ res.getBodyDocument());
            reader = res.getXmlStreamReader();
            system.debug('************* The response-4: '+ reader);
		}/*else{
            String xmlString = '<?xml version="1.0" encoding="utf-8" ?><rss version="2.0" xmlns:os="http://a9.com/-/spec/opensearch/1.1/"><channel><title>salesforce.com - Bing News</title><link>http://www.bing.com/news</link><description>Search Results for salesforce.com at Bing.com</description><category>News</category><os:totalResults>3370</os:totalResults><os:startIndex>0</os:startIndex><os:itemsPerPage>10</os:itemsPerPage><os:Query role="request" searchTerms="salesforce.com" /><copyright>These XML results may not be used, reproduced or transmitted in any manner or for any purpose other than rendering Bing results within an RSS aggregator for your personal, non-commercial use. Any other use requires written permission from Microsoft Corporation. By using these results in any manner whatsoever, you agree to be bound by the foregoing restrictions.</copyright><image><url>http://www.bing.com/s/a/rsslogo.gif</url><title>Bing</title><link>http://www.bing.com/news</link></image><docs>http://www.rssboard.org/rss-specification</docs><item><title>Salesforce.com Makes Friends With CIOs - Information Week</title><guid>http://informationweek.com/news/cloud-computing/software/232602782</guid><link>http://informationweek.com/news/cloud-computing/software/232602782</link><description>Parade of CIOs at CloudForce shows how social networking inroads are making Salesforce.com a larger part of the IT infrastructure. Salesforce.com isn&apos;t just for sales forces anymore. Its Chatter app has opened a social networking avenue into the enterprise ...</description><pubDate>2012-03-19T15:21:47Z</pubDate><source>Information Week</source></item></channel></rss>';
			doc.load(xmlString);
		}*/
    	
        //RSSFeed.Channel result = new RSSFeed.Channel();
        //list<RSSFeed.Item> rssItems = new list<RSSFeed.Item>();
    	//CHARACTERS, COMMENT, CDATA, SPACE, ENTITY_REFERENCE, DTD valid for getText() 
        //for each node inside channel
        while(reader.hasNext()){
            system.debug('******** The Start-1: '+ reader.getEventType());
            if(reader.getEventType() == XmlTag.START_ELEMENT){
                system.debug('******** The Start-2: '+ reader.getLocalName());
                if('rss' == reader.getLocalName()){
                    system.debug('******** The rss: ');//+ reader.getText());
                    //reader.next();
                }
                if('channel' == reader.getLocalName()){
                    system.debug('******** The Channel: ');//+ reader.getText());
                    //result.title = reader.getText();
					result = parseChannel(reader);
                }
            }
            system.debug('******** The Start-3: ');//+ reader.getLocalName());
            reader.next();
            system.debug('******** The Start-4: ');//+ reader.getLocalName());
        } 
        
        //finish RSSFeed.Channel object by adding the list of all rss items
        //result.items = rssItems;
        return result;
    }
	
	private RSSFeed.Channel parseChannel(XmlStreamReader reader){
		system.debug('************ The values START: ' + reader + '\n\n' + result + '\n\n'+ reader.getLocalName());
		boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement){
            system.debug('******** The channel reader-1: '+ reader + '\n' + reader.getEventType() + '\n' + reader.getLocalName());
            if(reader.getEventType() == XmlTag.END_ELEMENT){
                break;
            }else if(reader.getEventType() == XmlTag.START_ELEMENT){
                String elementName = reader.getLocalName();
                if('title' == reader.getLocalName()){
                    system.debug('******** The channel title-1: ');//+ reader.getLocalName());
                    //reader.next();
                    result.title = readCharacters(reader);
                    system.debug('******** The channel title-2: ');// + reader.getText());//+ reader.getLocalName());
                }else if('link' == reader.getLocalName()){
                    result.link = readCharacters(reader);
                }else if('description' == reader.getLocalName()){
                    result.description = readCharacters(reader);
                }else if('copyright' == reader.getLocalName()){
                    result.copyright = readCharacters(reader);
                }else if('language' == reader.getLocalName()){
                    result.language = readCharacters(reader);
                }else if('image' == reader.getLocalName()){//Parse Image inside Channel
                    result.image = parseImage(reader);
                }else if('item' == reader.getLocalName()){//Parse Items inside Channel
                    //result.items = parseItem(reader);
                    RSSFeed.Item item = parseItem(reader);
                    rssItems.add(item);
                }
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if(reader.hasNext()){
                reader.next();
            }else{
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        result.items = rssItems;
		system.debug('************ The values END: ' + reader + '\n\n' + result);
        return result;
    }
    
    private RSSFeed.Image parseImage(XmlStreamReader reader){
        system.debug('Entered into parseImage() of ' + RSSFeedReaderStream.class 
                     +'\nThe values START: ' + reader + '\n\n' + result + '\n\n'+ reader.getLocalName());
        RSSFeed.Image img = new RSSFeed.Image();
		boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement){
            system.debug('******** The Image reader-1: '+ reader + '\n' + reader.getEventType() + '\n' + reader.getLocalName());
            if(reader.getEventType() == XmlTag.END_ELEMENT){
                break;
            }else if(reader.getEventType() == XmlTag.START_ELEMENT){
                String elementName = reader.getLocalName();
                if('title' == reader.getLocalName()){
                    system.debug('******** The Image title-1: ');
                    img.title = readCharacters(reader);
                    system.debug('******** The Image title-2: ');
                }else if('url' == reader.getLocalName()){
                    img.url = readCharacters(reader);
                }else if('link' == reader.getLocalName()){
                    img.link = readCharacters(reader);
                }
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if(reader.hasNext()){
                reader.next();
            }else{
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        system.debug('Leaving from parseImage() of ' + RSSFeedReaderStream.class + reader + '\n\n' + result);
        return img;
    }
    
    
    private RSSFeed.Item parseItem(XmlStreamReader reader){
        system.debug('Entered into parseItem() of ' + RSSFeedReaderStream.class 
                     +'\nThe values START Items: ' + reader + '\n\n' + result + '\n\n'+ reader.getLocalName());
        RSSFeed.Item rssItem = new RSSFeed.Item();
		boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement){
            system.debug('******** The Item reader-1: '+ reader + '\n' + reader.getEventType() + '\n' + reader.getLocalName());
            if(reader.getEventType() == XmlTag.START_ELEMENT){
                String elementName = reader.getLocalName();
                if('title' == reader.getLocalName()){
                    String finalTitle = '';
                    String title = readCharacters(reader);
                    //check if title contains price or not
                    if(title.indexOf('-')!=-1){
                        String price = title.substringAfterLast('-');
                        if(String.isNotBlank(price)){
                        	rssItem.price = price;
                            system.debug('******* The price: '+ price);
                        	//TODO: Store country based on Price symbol
                        }
                        title = title.substringBeforeLast('-');
                        system.debug('******* The title: '+ title);
                    } 
                    rssItem.title = title;
                }else if('guid' == reader.getLocalName()){
                    rssItem.guid = readCharacters(reader);
                }else if('link' == reader.getLocalName()){
                    rssItem.link = readCharacters(reader);
                }else if('description' == reader.getLocalName()){
                    system.debug('*********** The description-1: ');//+ reader.getText());
                    rssItem.description = readCharacters(reader);
                    system.debug('*********** The description-2: ');
                }else if('pubDate' == reader.getLocalName() || 'date' == reader.getLocalName()){
                    rssItem.pubDate = readCharacters(reader);
                }else if('source' == reader.getLocalName()){
                    rssItem.source = readCharacters(reader);
                }else if('creator' == reader.getLocalName()){
                    system.debug('*********** The creator-1: ');
                    rssItem.author = readCharacters(reader);
                    system.debug('*********** The creator-2: ');
                }
            }else if(reader.getEventType() == XmlTag.END_ELEMENT){
                break;
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if(reader.hasNext()){
                reader.next();
            }else{
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        system.debug('Leaving from parseItem() of ' + RSSFeedReaderStream.class + reader + '\n\n' + rssItem);
        return rssItem;
    }
    
    
    private String readCharacters(XMLStreamReader reader){
        system.debug('Entered into readCharacters() of '+ RSSFeedReaderStream.class + '\t' + reader);
        String result = '';
        while(reader.hasNext()){
            Integer eventType = reader.next();
            system.debug('******** The eventype: '+ eventType + '\t' + reader.getEventType());
            if(reader.getEventType() == XmlTag.CHARACTERS){
                system.debug('******** Now in readCharacters-1: '+ reader.getText());
                result += reader.getText();
            }else if(reader.getEventType() == XmlTag.CDATA){
                system.debug('******** Now in readCharacters-2: '+ reader.getText());
                result += reader.getText();
            }else if(reader.getEventType() == XmlTag.END_ELEMENT){
                break;
            }
        }
        system.debug('Leaving from readCharacters() of '+ RSSFeedReaderStream.class + '\t' + reader);
        return result;
    }
}