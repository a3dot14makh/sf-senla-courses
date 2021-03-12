trigger FlightTrigger on Flight__c(before insert) {
  switch on Trigger.operationType {
    when BEFORE_INSERT {
      List<Tourist__c> touristList = [SELECT Age__c, Name, Id FROM Tourist__c];
      List<Trip__c> tripList = [SELECT Minimum_Age__c, Name, Id FROM Trip__c];

      for (Flight__c newFlight : Trigger.new) {
        Decimal age = 0;
        Decimal minimumAge = 0;
        for (Tourist__c tourist : touristList) {
          if (newFlight.Tourist__c == tourist.Id) {
            age = tourist.Age__c;
          }
        }
        for (Trip__c trip : tripList) {
          if (newFlight.Trip__c == trip.Id) {
            minimumAge = trip.Minimum_Age__c;
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
}
