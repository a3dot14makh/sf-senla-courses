public with sharing class TouristAssignmentController {
    
    @AuraEnabled
    public static List<Tourist__c> fetchTouristsByName(String name) {
        //To Do: use SOSL and TouristManager
        return [
            SELECT
                Name,
                Email__c,
                Gender__c,
                Active__c,
                Age__c,
                Birthday__c,
                (SELECT Id, Trip__r.Start_Date__c, Trip__r.End_Date__c FROM Flights__r)
            FROM Tourist__c
            WHERE Active__c = TRUE AND Name = :name
            ORDER BY Name ASC
        ];
    }

    @AuraEnabled
    public static List<Trip__c> fetchTrip(Tourist__c tourist) {
        List<Trip__c> trips = [
            SELECT Id, Name, Start_Date__c, End_Date__c, Minimum_Age__c, Number_Employed_Seats__c, Seats__c
            FROM Trip__c
        ];

        List<Trip__c> otputTrips = new List<Trip__c>();

        for (Trip__c trip : trips) {
            if (validationTrip(tourist, trip)) {
                otputTrips.add(trip);
            }
        }

        return otputTrips;
    }

    private static Boolean validationTrip(Tourist__c tourist, Trip__c trip) {
        Boolean result = true;
        if (
            (tourist.Age__c < trip.Minimum_Age__c) ||
            (trip.Seats__c == trip.Number_Employed_Seats__c) ||
            (System.today() < trip.Start_Date__c)
        ) {
            result = false;
        }

        if (result) {
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
        }

        return result;
    }
}
