public class TouristTriggerHandler {
    public static Boolean wasExecuted = false;
    
    public static void onAfterInsert(Map<Id, Tourist__c> newMap) {
        TouristService.markDuplicatesAsync(newMap.keySet());
    }

    public static void onAfterUpdate(Map<Id, Tourist__c> oldMap, Map<Id, Tourist__c> newMap) {
        List<Flight__c> flightToUpdate = new List<Flight__c>();
        List<Tourist__c> toutistsWithFlights = TouristManager.getTouristWithFlightsById(
            newMap.keySet()
        );

        for (Tourist__c tourist : toutistsWithFlights) {
            if (oldMap.get(tourist.Id).Active__c && !newMap.get(tourist.Id).Active__c) {
                for (Flight__c flight : tourist.Flights__r) {
                    if (flight.Trip__r.Start_Date__c > Date.today()) {
                        flight.Status__c = Constants.OBJECT_FIELD_VALUE_FLIGHT_STATUS_DECLINED;
                        flightToUpdate.add(flight);
                    }
                }
            }
        }

        if (!flightToUpdate.isEmpty()) {
            update flightToUpdate;
        }
    }
}