public class DeleteFlightsBatch implements Database.Batchable<sObject>, Database.RaisesPlatformEvents, Database.Stateful {
    private final String EMAIL_HEADER = 'Tourist\'s Name : Number of remote flights';
    private final String EMAIL_BODY_VALUE_NOTHING_FOUND = 'No Flights found to delete.';
    private final String QUERY =
        'SELECT Status__c, Tourist__r.Name ' +
        'FROM Flight__c ' +
        'WHERE Status__c = \'' +
        Constants.OBJECT_FIELD_VALUE_FLIGHT_STATUS_DECLINED +
        '\' AND ' +
        Constants.CREATED_DATE_MORE_THAN_30_DAYS;
    private Set<Tourist__c> tourists = new Set<Tourist__c>();
    //Needed for sorting Tourists
    private List<Tourist__c> touristsBeforeSorting  = new List<Tourist__c>();
    private Map<Id, Integer> resultMap = new Map<Id, Integer>();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(QUERY);
    }

    public void execute(Database.BatchableContext bc, List<Flight__c> scope) {
        if (scope == null || scope.isEmpty()) {
            return;
        }

        for (Flight__c flight : scope) {
            touristsBeforeSorting.add(flight.Tourist__r);
            if (resultMap.containsKey(flight.Tourist__r.Id)) {
                Integer numRemoteFlights = resultMap.get(flight.Tourist__r.Id);
                resultMap.put(flight.Tourist__r.Id, numRemoteFlights + 1);
            } else {
                resultMap.put(flight.Tourist__r.Id, 1);
            }
        }

        delete scope;
    }

    public void finish(Database.BatchableContext bc) {
        List<String> emailAddress = GeneralMetadataManager.getEmails();
        String htmlBody = creationHtmlBody();
        EmailService.sendEmail(
            emailAddress,
            Constants.EMAIL_SENDER_DISPLAY_NAME_FOR_BATCH,
            Constants.EMAIL_SUBJECT_FOR_BATCH,
            htmlBody
        );
    }

    private String creationHtmlBody() {
        touristsBeforeSorting.sort();
        tourists.addAll(touristsBeforeSorting);
        String htmlBody = EMAIL_HEADER + '<br>';

        if (resultMap.isEmpty()) {
            htmlBody = EMAIL_BODY_VALUE_NOTHING_FOUND;
        } else {
            for (Tourist__c tourist : tourists) {
                htmlBody +=
                    '<a href="' +
                    URL.getSalesforceBaseUrl().toExternalForm() +
                    '/' +
                    tourist.Id +
                    '">' +
                    tourist.Name +
                    '</a>' +
                    ' : ' +
                    resultMap.get(tourist.Id) +
                    '<br>';
            }
        }
        return htmlBody;
    }
}