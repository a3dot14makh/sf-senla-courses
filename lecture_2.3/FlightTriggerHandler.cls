public with sharing class FlightTriggerHandler {
  public static Boolean wasExecuted = false;

  public static void onBeforeInsert(List<Flight__c> newFlightList) {
    Set<Id> newTouristId = new Set<Id>();
    Set<Id> newTripId = new Set<Id>();
    for (Flight__c flight : newFlightList) {
      newTouristId.add(flight.Tourist__c);
      newTripId.add(flight.Trip__c);
    }

    List<Tourist__c> touristList = TouristManager.getById(newTouristId);
    List<Trip__c> tripList = TripManager.getById(newTripId);

    for (Integer i = 0; i < newFlightList.size(); i++) {
      if (
        newFlightList[i].Tourist__c == touristList[i].Id &&
        newFlightList[i].Trip__c == tripList[i].Id
      ) {
        if (tripList[i].Start_Date__c <= Date.today()) {
          newFlightList[i].Trip__c.addError('Your flight has already left.');
        }
        if (touristList[i].Age__c < tripList[i].Minimum_Age__c) {
          newFlightList[i]
            .Tourist__c.addError(
              'You are not eligible for this flight by age criteria.'
            );
        }
      }
    }
  }
}
