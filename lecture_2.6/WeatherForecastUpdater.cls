public class WeatherForecastUpdater {

    @future(callout=true)
    public static void updateForecasts() {
        List<Weather_Daily_Forecast__c> actualForecasts = new List<Weather_Daily_Forecast__c>();
        List<Space_Point__c> spacePoints = SpacePointManager.getAll();
        if (spacePoints == null || spacePoints.isEmpty()) {
            return;
        }

        for (Space_Point__c spacePoint : spacePoints) {
            Map<Date, Decimal> forecast = new Map<Date, Decimal>();
            
            try {
                forecast = WeatherForecastService.getForecasts(
                    spacePoint.Latitude__c,
                    spacePoint.Longitude__c
                );
            } catch (Exception ex) {
                System.debug(ex.getMessage());
            }

            if (!forecast.isEmpty()) {

                for (Date forecastDate : forecast.keyset()) {
                    Weather_Daily_Forecast__c newForecast = new Weather_Daily_Forecast__c(
                        Name = forecastDate.format() + ' Forecast in: ' + spacePoint.Name,
                        Date__c = forecastDate,
                        Average_Temperature__c = forecast.get(forecastDate),
                        Space_Point__c = spacePoint.Id
                    );
                    actualForecasts.add(newForecast);
                }
            }
        }

        List<Weather_Daily_Forecast__c> notActualForecasts = WeatherForecastManager.getAll();
        if (notActualForecasts != null & !notActualForecasts.isEmpty()) {
            delete notActualForecasts;
        }

        insert actualForecasts;
    }
}
