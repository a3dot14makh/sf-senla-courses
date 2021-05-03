public class WeatherForecastService {
    public class WeatherForecastException extends Exception {
    }

    public static List<Weather_Daily_Forecast__c> getActualForecastsForSpacePoints(
        List<Space_Point__c> spacePoints
    ) {
        List<Weather_Daily_Forecast__c> actualForecasts = new List<Weather_Daily_Forecast__c>();
        for (Space_Point__c spacePoint : spacePoints) {
            Map<Date, Decimal> forecast = new Map<Date, Decimal>();
            try {
                forecast = getForecasts(spacePoint.Latitude__c, spacePoint.Longitude__c);
            } catch (Exception ex) {
                System.debug(LoggingLevel.ERROR, ex.getMessage());
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
        return actualForecasts;
    }

    private static Map<Date, Decimal> getForecasts(Decimal latitude, Decimal longitude) {
        Map<Date, Decimal> result = new Map<Date, Decimal>();
        Http http = new Http();
        HTTPResponse response = http.send(WeatherbitAPIService.createRequest(latitude, longitude));

        if (response.getStatusCode() == Constants.RESPONSE_STATUS_CODE_200) {
            result = WeatherbitAPIService.parseForecastsUntyped(response.getBody());
        } else {
            throw new WeatherForecastException(response.getStatusCode() + ' ' + response.getStatus());
        }

        return result;
    }
}
