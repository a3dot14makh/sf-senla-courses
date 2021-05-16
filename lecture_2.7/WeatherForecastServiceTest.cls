@IsTest
private class WeatherForecastServiceTest {
    
    @TestSetup
    private static void setup() {
        TestDataFactory.createSpacePoints();
    }

    @IsTest
    private static void testGetActualForecastsForSpacePoints() {
        List<Space_Point__c> spacePoints = SpacePointManager.getAll();

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        List<Weather_Daily_Forecast__c> actualForecasts = WeatherForecastService.getActualForecastsForSpacePoints(
            spacePoints
        );
        Test.stopTest();

        System.assertEquals(2, spacePoints.size());
        System.assertEquals(4, actualForecasts.size());
        System.assertEquals(actualForecasts[0].Date__c, actualForecasts[2].Date__c);
        System.assertEquals(actualForecasts[1].Date__c, actualForecasts[3].Date__c);
    }

    @IsTest
    private static void testGetActualForecastsForSpacePoints_ResponseError() {
        List<Space_Point__c> spacePoints = new List<Space_Point__c>{
            new Space_Point__c(Name = 'Brest', Latitude__c = 52.05, Longitude__c = 23.72)
        };
        String expectedMessage = Constants.RESPONSE_STATUS_CODE_500 + ' ' + Constants.RESPONSE_STATUS_ERROR;

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        try {
            List<Weather_Daily_Forecast__c> actualForecasts = WeatherForecastService.getActualForecastsForSpacePoints(
                spacePoints
            );
        } catch (WeatherForecastService.WeatherForecastException ex) {
            System.AssertEquals(expectedMessage, ex.getMessage());
        }
        Test.stopTest();
    }
}
