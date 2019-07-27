@RestResource(urlMapping='/emp/details')
global class MySOAPRS {
    @HttpGet
    global static void getEmployee(){
        system.debug('*********** Now in getEmployee() '+ MySOAPWS.class);
    }
    
    @HttpPost
    global static void getEmployee1(){
        system.debug('*********** Now in getEmployee1() '+ MySOAPWS.class);
    }
}