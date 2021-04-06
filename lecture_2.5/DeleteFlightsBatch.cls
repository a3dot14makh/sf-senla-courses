public class DeleteFlightsBatch implements Database.Batchable<sObject>, Database.Stateful {
    private final String EMAIL_HEADER = 'Tourist\'s Name : Number of remote flights';
    private final String EMAIL_BODY_VALUE_NOTHING_FOUND = 'No Flights found to delete.';
    private final String QUERY =
        'SELECT Status__c, Tourist__r.Name ' +
        'FROM Flight__c ' +
        'WHERE Status__c = \'' +
        Constants.OBJECT_FIELD_VALUE_FLIGHT_STATUS_DECLINED +
        '\' AND ' +
        Constants.CREATED_DATE_MORE_THAN_30_DAYS;
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
        List<String> emailAddress = GeneralMetadataManager.getEmails();
        String htmlBody = creationHtmlBody();
        EmailService.sendEmailFromBatch(emailAddress, Constants.EMAIL_SUBJECT_FOR_BATCH, htmlBody);
    }

    private String creationHtmlBody() {
        String htmlBody = EMAIL_HEADER + '<br>';

        if (resultMap.isEmpty()) {
            htmlBody = EMAIL_BODY_VALUE_NOTHING_FOUND;
        } else {
            for (Tourist__c tourist : resultMap.keySet()) {
                htmlBody +=
                    '<a href="' +
                    URL.getSalesforceBaseUrl().toExternalForm() +
                    '/' +
                    tourist.Id +
                    '">' +
                    tourist.Name +
                    '</a>' +
                    ' : ' +
                    resultMap.get(tourist) +
                    '<br>';
            }
        }
        return htmlBody;
    }
}
