public class ScheduledBatch {
  public void execute(SchedulableContext sc) {
    Database.executeBatch(new DeleteFlightsBatch());
  }
}
