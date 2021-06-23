public inherited sharing class TableSuitableTouristsForTripController {
    
    @AuraEnabled(Cacheable=true)
    public static List<Tourist__c> getSuitableTourists(Trip__c trip) {
        List<Tourist__c> tourists = new List<Tourist__c>();

        for (Tourist__c tourist : TouristManager.getActiveWithFlights()) {
            if (validationTourists(tourist, trip)) {
                tourists.add(tourist);
            }
        }

        return tourists;
    }

    @AuraEnabled
    public static void createFlights(Id tripId, List<Id> touristsId) {
        TripService.assignTourists(tripId, new Set<Id>(touristsId));
    }

    private static Boolean validationTourists(Tourist__c tourist, Trip__c trip) {
        Boolean result = true;
        if (tourist.Age__c < trip.Minimum_Age__c) {
            result = false;
        }

        for (Flight__c flight : tourist.Flights__r) {
            if (flight.Trip__c == trip.Id) {
                result = false;
            } else if (
                (flight.Trip__r.Start_Date__c >= trip.Start_Date__c &&
                flight.Trip__r.Start_Date__c <= trip.End_Date__c) ||
                (flight.Trip__r.End_Date__c >= trip.Start_Date__c &&
                flight.Trip__r.End_Date__c <= trip.End_Date__c) ||
                (flight.Trip__r.Start_Date__c <= trip.Start_Date__c &&
                flight.Trip__r.End_Date__c >= trip.End_Date__c)
            ) {
                result = false;
            }
        }

        return result;
    }
}
