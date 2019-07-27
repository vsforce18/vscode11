public class Car {
	public Integer noOfGears = 4;
	public String model;
	public Double speed;
	
	//Constructor (Default constructor)
	public Car()
	{
		system.debug('Entered into the Car() constructor');
		this.noOfGears = 5;
		this.model = 'BMW';
		this.speed = 120;
		system.debug('The values of instance variables are:\n' 
					+ 'Model: ' + model
					+ '\nNo Of Gears: ' + noOfGears
					+ '\nSpeed: '+ speed);
		system.debug('Leaving from the Car() constructor');
	}
	
	//Constructor with Arguments
	public Car(Integer noOfGears, String model, Double speed)
	{
		system.debug('Entered into the Car(param1, param2, param3) constructor');
		this.noOfGears = noOfGears;
		this.model = model;
		this.speed = speed;
		system.debug('The values of instance variables are:\n' 
					+ 'Model: ' + model
					+ '\nNo Of Gears: ' + noOfGears
					+ '\nSpeed: '+ speed);
		system.debug('Leaving from the Car(param1, param2, param3) constructor');
	}
	
	public static void carStaticMethod(){
		system.debug('************** This is static method, and can be invoked without creating an object of a class');
	}
	
	//Instance method
	public String carDetails()
	{
		String str = '******* Car details::\nModel='+ model + '\nNo Of Gears='+ noOfGears;
		system.debug(str);
		return str;
	}
	
	
	
	//Instance method with Arugments/Parameters
	public void carInfo(String model1, Integer noOfGears1) 
	{
		system.debug('******* Car Info::\nModel='+ model1 + '\nNo Of Gears='+ noOfGears1);
	}
	
	
	//Method overloading
	public void carInfo(String model, Integer noOfGears, Double speed)
	{
		this.noOfGears = noOfGears;
		this.model = model;
		speed = speed;
		system.debug('******* Car Info OVERLOADING::\nModel='+ model + '\nNo Of Gears='+ noOfGears + '\nSpeed=' + speed);
	}
}