global class MySOAPWS {
    static webservice void getEmployee(String empId){
        system.debug('*********** Now in getEmployee() '+ MySOAPWS.class);
    }
}