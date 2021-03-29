public with sharing class TouristTriggerHandler {
  public static Boolean wasExecuted = false;

  public static void onBeforeInsert(List<Tourist__c> newTouristList) {
    if (newTouristList == null || newTouristList.isEmpty()) {
      return;
    }

    TouristService.markDuplicates(newTouristList);
  }

  public static void onAfterUpdate(
    Map<Id, Tourist__c> oldMap,
    Map<Id, Tourist__c> newMap
  ) {
    if (newMap == null || newMap.isEmpty() || oldMap == null || oldMap.isEmpty()) {
      return;
    }
    List<Flight__c> flightToUpdate = new List<Flight__c>();
    List<Tourist__c> toutistsWithFlights = TouristManager.getTouristWithFlightsById(
      newMap.keySet()
    );

    for (Tourist__c tourist : toutistsWithFlights) {
      if (
        oldMap.get(tourist.Id).Active__c == true &&
        newMap.get(tourist.Id).Active__c == false
      ) {
        for (Flight__c flight : tourist.Flights__r) {
          if (flight.Trip__r.Start_Date__c > Date.today()) {
            flight.Status__c = 'Declined';
            flightToUpdate.add(flight);
          }
        }
      }
    }

    if (flightToUpdate.isEmpty()) {
      update flightToUpdate;
    }
  }
}
