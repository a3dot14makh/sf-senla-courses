public class WeatherForecastUpdater {
    @future(callout=true)
    public static void updateForecasts() {
        List<Space_Point__c> spacePoints = SpacePointManager.getAll();
        if (spacePoints == null || spacePoints.isEmpty()) {
            return;
        }

        List<Weather_Daily_Forecast__c> oldDailyForecasts = WeatherForecastManager.getAll();
        List<Weather_Daily_Forecast__c> newDailyForecasts = WeatherForecastService.getActualForecastsForSpacePoints(
            spacePoints
        );

        delete oldDailyForecasts;
        insert newDailyForecasts;
    }
}
