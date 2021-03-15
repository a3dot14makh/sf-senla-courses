public with sharing class FlightTriggerHandler {
  public static void onBeforeInsert(List<Flight__c> newFlightList) {
    List<Id> newTouristId = new List<Id>();
    List<Id> newTripId = new List<Id>();
    for (Flight__c flight : newFlightList) {
      newTouristId.add(flight.Tourist__c);
      newTripId.add(flight.Trip__c);
    }

    List<Tourist__c> touristList = [
      SELECT Age__c, Id
      FROM Tourist__c
      WHERE Id IN :newTouristId
    ];
    List<Trip__c> tripList = [
      SELECT Start_Date__c, Minimum_Age__c, Id
      FROM Trip__c
      WHERE Id IN :newTripId
    ];

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
