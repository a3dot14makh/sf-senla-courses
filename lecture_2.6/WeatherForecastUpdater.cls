public class WeatherForecastUpdater {
    @future(callout=true)
    public static void updateForecasts() {
        List<Weather_Daily_Forecast__c> oldDailyForecasts = WeatherForecastManager.getAll();
        List<Weather_Daily_Forecast__c> newDailyForecasts = WeatherForecastService.getActualForecastsForSpacePoints(
            SpacePointManager.getAll()
        );

        delete oldDailyForecasts;
        insert newDailyForecasts;
    }
}
