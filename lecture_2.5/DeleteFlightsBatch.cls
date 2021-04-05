public class DeleteFlightsBatch implements Database.Batchable<sObject>, Database.Stateful {
  private final String QUERY =
    'SELECT Status__c, Tourist__r.Name ' +
    'FROM Flight__c ' +
    'WHERE Status__c = \'Declined\'  AND CreatedDate < LAST_N_DAYS:30';
  Map<Tourist__c, Integer> resultMap = new Map<Tourist__c, Integer>();

  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(QUERY);
  }

  public void execute(Database.BatchableContext bc, List<Flight__c> scope) {
    if (scope == null || scope.isEmpty()) {
      return;
    }
    for (Flight__c flight : scope) {
      if (resultMap.containsKey(flight.Tourist__r)) {
        Integer i = resultMap.get(flight.Tourist__r);
        resultMap.put(flight.Tourist__r, i + 1);
      } else {
        resultMap.put(flight.Tourist__r, 1);
      }
    }
    delete scope;
  }

  public void finish(Database.BatchableContext bc) {
    /*
      Как я понимаю, для запросов из Custom Metadata Type
      тоже должен создаваться отдельный Manager класс?
    */
    Tourist_Setting__mdt touristList = [
      SELECT Email_Custom_Field__c
      FROM Tourist_Setting__mdt
    ];
    List<String> emailAddress = new List<String>{
      touristList.Email_Custom_Field__c
    };
    String subject = 'Batch Process Completed';
    String htmlBody = 'Name : Number of remote flights' + '<br>';
    if (resultMap.isEmpty()) {
      htmlBody = 'No Flights found.';
    } else {
      for (Tourist__c tourist : resultMap.keySet()) {
        htmlBody +=
          '<a href="' +
          URL.getSalesforceBaseUrl().toExternalForm() +
          '/' +
          tourist.Id +
          '">"' +
          tourist.Name +
          '"</a>' +
          ' : ' +
          resultMap.get(tourist) +
          '<br>';
      }
    }
    EmailService.sendEmailFromBatch(emailAddress, subject, htmlBody);
  }
}
