public class RSSFeed{
    public class Channel{
        //public String category {get;set;}
        //public String channelUrl {get;set;}
        public String copyright {get;set;}
        public String description {get;set;}
        public String language {get;set;}
        public String link {get;set;}
        public String title {get;set;}
        //public String author {get;set;}
        //public String docs {get;set;}
        public RSSFeed.Image image {get;set;} //Channel Image
        public list<RSSFeed.Item> items {get;set;} //Channel Items
        
        public Channel(){
            items = new list<RSSFeed.Item>();
        }
    }
    
    public class Image{
        public String link {get;set;}
        public String title {get;set;}
        public String url {get;set;}
    }
    
    public class Item{
        public String author {get;set;} //public String creator {get;set;}
        public String category {get;set;}
        public String comments {get;set;}
        public String description {get;set;}
        public String guid {get;set;}
        public String link {get;set;}
        public String pubDate {get;set;}
        public String source {get;set;}
        public String title {get;set;}
        //Custom parsed text fields based on RSS Data
        public String price {get;set;}
        
        /*public Date getPublishedDate() {
            Date result = (pubDate != null) ? Date.valueOf(pubDate.replace('T', ' ').replace('Z','')) : null;
            return result;
        }
        public DateTime getPublishedDateTime() {
            DateTime result = (pubDate != null) ? DateTime.valueOf(pubDate.replace('T', ' ').replace('Z','')) : null;
            return result;
        }*/
    }
}