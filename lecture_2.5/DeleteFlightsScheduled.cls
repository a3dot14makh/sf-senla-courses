public class DeleteFlightsScheduled implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new DeleteFlightsBatch());
    }
}
