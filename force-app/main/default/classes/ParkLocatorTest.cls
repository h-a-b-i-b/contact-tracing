@isTest
private class ParkLocatorTest {
	
    @isTest
    static void countryTest(){
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        List<String> response = ParkLocator.country('India');
        List<String> expected = new List<String>{'Anamudi Shola National Park', 'Anshi National Park', 'Bandipur National Park'};

        Assert.areEqual(expected, response);
    }
}