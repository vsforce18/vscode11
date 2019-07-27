public class CMTickerDO {
    public Data data {get; set;}
    public Metadata metadata {get; set;}
    
    public class Data{
        //public List<Ticker> ticker {get; set;}
        public Ticker str1 {get; set;}
        public Ticker str2 {get; set;}
        public Ticker str3 {get; set;}
        public Ticker str4 {get; set;}
        public Ticker str5 {get; set;}
    }
    
    public class Ticker{
        public Integer id {get; set;}
        public String name {get; set;}
        public String symbol {get; set;}
        public String website_slug {get; set;}
        public Integer rank {get; set;}
        public Decimal circulating_supply {get; set;}
        public Decimal total_supply {get; set;}
        public Decimal max_supply {get; set;}
        public Integer last_updated {get; set;}
        public CMTickerDO.Quotes quotes {get; set;}
    }
    
    public class Quotes{
        //public Price price {get; set;}
        public CMTickerDO.Price usd {get; set;}
        public CMTickerDO.Price eur {get; set;}
        public CMTickerDO.Price inr {get; set;}
    }
        
    public class Price{
        public Double price {get; set;}
        public Double volume_24h {get; set;}
        public Double market_cap {get; set;}
        public Double percent_change_1h {get; set;}
        public Double percent_change_24h {get; set;}
        public Double percent_change_7d {get; set;}
    }
    
    public class Metadata{
        public Integer timestamp {get; set;}
        public String error {get; set;}
        public String num_cryptocurrencies {get; set;}
    }
}