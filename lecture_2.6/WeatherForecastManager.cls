public class WeatherForecastManager {

    public static List<Weather_Daily_Forecast__c> getAll() {
        return [
            SELECT Name, 
            Space_Point__c
            FROM Weather_Daily_Forecast__c
            ORDER BY CreatedDate
        ];
    }
}
