public with sharing class FlightTriggerHandler {
  public static void onBeforeInsert(List<Flight__c> newFlightList) {
    List<Tourist__c> touristList = [SELECT Age__c, Id FROM Tourist__c];
    List<Trip__c> tripList = [
      SELECT Start_Date__c, Minimum_Age__c, Id
      FROM Trip__c
    ];

    for (Flight__c newFlight : newFlightList) {
      Decimal age = 0;
      Decimal minimumAge = 0;
      for (Tourist__c tourist : touristList) {
        if (newFlight.Tourist__c == tourist.Id) {
          age = tourist.Age__c;
          break;
        }
      }
      for (Trip__c trip : tripList) {
        if (newFlight.Trip__c == trip.Id) {
          if (trip.Start_Date__c <= Date.today()) {
            newFlight.Trip__c.addError('Your flight has already left.');
          }

          minimumAge = trip.Minimum_Age__c;
          break;
        }
      }
      if (age < minimumAge) {
        newFlight.Tourist__c.addError(
          'You are not eligible for this flight by age criteria.'
        );
      }
    }
  }
}
