public class UpdateForecastsSchedulable implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        WeatherForecastUpdater.updateForecasts();
    }
}
