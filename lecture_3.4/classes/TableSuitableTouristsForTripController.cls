public with sharing class TableSuitableTouristsForTripController {

    @AuraEnabled
    public static List<TouristWrapperAura> getSuitableTourists(Trip__c trip) {
        List<Tourist__c> tourists = TouristManager.getActiveWithFlights();

        Set<Tourist__c> setTourists = new Set<Tourist__c>();

        for (Tourist__c tourist : tourists) {
            if (validationTourists(tourist, trip)) {
                setTourists.add(tourist);
            }
        }
        List<TouristWrapperAura> outputTourists = new List<TouristWrapperAura>();
        
        for (Tourist__c touristV : setTourists) {
            outputTourists.add(
                new TouristWrapperAura(touristV.Id, touristV.Name, touristV.Email__c, touristV.Gender__c)
            );
        }

        return outputTourists;
    }

    @AuraEnabled
    public static void createFlights(Id tripId, List<Id> touristsId) {
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

    public with sharing class TouristWrapperAura {
        @AuraEnabled
        public Id id { get; set; }
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String email { get; set; }
        @AuraEnabled
        public String gender { get; set; }
        @AuraEnabled
        public String link { get; set; }

        public TouristWrapperAura(Id id, String name, String email, String gender) {
            this.id = id;
            this.name = name;
            this.email = email;
            this.gender = gender;
            this.link = URL.getSalesforceBaseUrl().toExternalForm() + '/' + id;
        }
    }
}
