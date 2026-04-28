@isTest
private class AnimalLocatorTest {
	
    @isTest
    static void getAnimalNameByIdTest(){
        // Set mock callout class
    	Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
       
        String actualValue = AnimalLocator.getAnimalNameById(1);
        String expectedValue = 'chicken';
        Assert.areEqual(expectedValue, actualValue);
    }
}