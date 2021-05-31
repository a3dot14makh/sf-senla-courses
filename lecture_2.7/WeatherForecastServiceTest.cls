@IsTest
private class WeatherForecastServiceTest {
    
    @TestSetup
    private static void setup() {
        TestDataFactory.createSpacePoints();
    }

    @IsTest
    private static void testGetActualForecastsForSpacePoints() {
        List<Space_Point__c> spacePoints = SpacePointManager.getAll();

        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(
            'callout:Weatherbit_Endpoint?lat=45.57&lon=63.18&units=metric',
            'mockResponseSpacePointsBaikonur'
        );
        multimock.setStaticResource(
            'callout:Weatherbit_Endpoint?lat=53.69&lon=23.83&units=metric',
            'mockResponseSpacePointsHrodna'
        );
        multimock.setStatusCode(Constants.RESPONSE_STATUS_CODE_200);
        multimock.setStatus(Constants.RESPONSE_STATUS_OK);
        multimock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, multimock);

        Test.startTest();
        List<Weather_Daily_Forecast__c> actualForecasts = WeatherForecastService.getActualForecastsForSpacePoints(
            spacePoints
        );
        Test.stopTest();

        System.assertNotEquals(null, spacePoints);
        System.assertEquals(2, spacePoints.size());
        System.assertNotEquals(null, actualForecasts);
        System.assertEquals(4, actualForecasts.size());
        System.assertEquals(actualForecasts[0].Date__c, actualForecasts[2].Date__c);
        System.assertEquals(actualForecasts[1].Date__c, actualForecasts[3].Date__c);
    }

    @IsTest
    private static void testGetActualForecastsForSpacePoints_ResponseError() {
        List<Space_Point__c> spacePoints = SpacePointManager.getAll();

        Test.setMock(HttpCalloutMock.class, new ErrorMockResponse());

        Test.startTest();
        List<Weather_Daily_Forecast__c> actualForecasts = WeatherForecastService.getActualForecastsForSpacePoints(
            spacePoints
        );
        Test.stopTest();

        System.assertNotEquals(null, actualForecasts);
        System.assertEquals(0, actualForecasts.size());
    }
}
