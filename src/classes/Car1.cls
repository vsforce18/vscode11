@isTest
public class Car1 {
	public static TestMethod void carTesting()
    {
        system.debug('********** Entered into carTesting() *************');
        Car c = new Car();
        c = new Car(4, 'BMW', 120);
        c.carDetails();
        c.carInfo('Toyota', 5, 110);
        system.debug('********** Leaving from carTesting() *************');
    }
}