public with sharing class FlightTriggerHandler {
    public static Boolean wasExecuted = false;

    public static void onAfterInsert(Map<Id, Flight__c> newFlights) {
        for (Flight__c flight : FlightManager.getById(newFlights.keySet())) {
            if (flight.Trip__r.Start_Date__c <= Date.today()) {
                newFlights.get(flight.Id)
                    .Trip__c.addError(Constants.NEW_FLIGHT_VALIDATION_ERROR_TRIP_START_DATE);
            }
            if (flight.Tourist__r.Age__c < flight.Trip__r.Minimum_Age__c) {
                newFlights.get(flight.Id).Tourist__c.addError(Constants.NEW_FLIGHT_VALIDATION_ERROR_TOURIST_AGE);
            }
        }
    }
}
