public class DeleteFlightsBatch implements Database.Batchable<sObject>, Database.Stateful {
  private final String QUERY =
    'SELECT CreatedById, Status__c, Tourist__r.Name ' +
    'FROM Flight__c ' +
    'WHERE Status__c = \'Declined\'  AND CreatedDate = LAST_N_DAYS:30';
  Map<Tourist__c, Integer> touristMap = new Map<Tourist__c, Integer>();

  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(QUERY);
  }

  public void execute(Database.BatchableContext bc, List<Flight__c> scope) {
    for (Flight__c flight : scope) {
      if (touristMap.containsKey(flight.Tourist__r)) {
        Integer i = touristMap.get(flight.Tourist__r);
        touristMap.put(flight.Tourist__r, i + 1);
      } else {
        touristMap.put(flight.Tourist__r, 1);
      }
    }
    delete scope;
  }

  public void finish(Database.BatchableContext bc) {
    Tourist_Setting__mdt touristList = [
      SELECT Email_Custom_Field__c
      FROM Tourist_Setting__mdt
    ];
    List<String> emailAddress = new List<String>{
      touristList.Email_Custom_Field__c
    };
    String subject = 'Batch Process Completed';
    String plainTextBody = 'Name : Number of remote flights\n';
    for (Tourist__c tourist : touristMap.keySet()) {
      plainTextBody =
        plainTextBody +
        tourist.Name +
        ' : ' +
        touristMap.get(tourist) +
        '\n';
    }

    EmailService.sendEmailFromBatch(emailAddress, subject, plainTextBody);
  }
}
