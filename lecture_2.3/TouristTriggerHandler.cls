public with sharing class TouristTriggerHandler {
  public static Boolean wasExecuted = false;

  public static void onBeforeInsert(List<Tourist__c> newTouristList) {
    Set<String> names = new Set<String>();
    Set<String> emails = new Set<String>();
    for (Tourist__c newTourist : newTouristList) {
      names.add(newTourist.Name);
      emails.add(newTourist.Email__c);
    }
    List<Tourist__c> listFromBase = TouristManager.getByNameAndEmail(
      names,
      emails
    );

    for (Tourist__c touristFromBase : listFromBase) {
      for (Tourist__c newTourist : newTouristList) {
        if (
          touristFromBase.Name == newTourist.Name &&
          touristFromBase.Email__c == newTourist.Email__c
        ) {
          newTourist.Is_Duplicate__c = true;
        }
      }
    }
  }

  public static void onAfterUpdate(
    Map<Id, Tourist__c> oldMap,
    Map<Id, Tourist__c> newMap
  ) {
    List<Flight__c> flightToUpdate = new List<Flight__c>();
    List<Tourist__c> toutistWithFlight = [
      SELECT
        Id,
        Active__c,
        (SELECT Id, Trip__r.Start_Date__c, Status__c FROM Flights__r)
      FROM Tourist__c
      WHERE Id IN :newMap.keySet()
    ];

    for (Tourist__c tourist : toutistWithFlight) {
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

    if (flightToUpdate.size() > 0) {
      update flightToUpdate;
    }
  }
}
