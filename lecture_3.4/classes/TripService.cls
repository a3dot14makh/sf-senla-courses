public with sharing class TripService {
    
    public static void assignTourists(Id tripId, Set<Id> touristsId) {
        List<Flight__c> flights = new List<Flight__c>();

        for (Id idTourist : touristsId) {
            Flight__c flight = new Flight__c(
                Tourist__c = idTourist,
                Trip__c = tripId,
                Status__c = Constants.OBJECT_FIELD_VALUE_FLIGHT_STATUS_OFFER_PENDING
            );
            flights.add(flight);
        }
        insert flights;
    }
}
