trigger TouristTrigger on Tourist__c(before insert) {
  switch on Trigger.operationType {
    when BEFORE_INSERT {
      List<Tourist__c> triggerList = new List<Tourist__c>();
      List<Tourist__c> listFromBase = [
        SELECT Id, Name, Email__c
        FROM Tourist__c
      ];
      for (Tourist__c touristFromBase : listFromBase) {
        for (Tourist__c newTourist : Trigger.new) {
          if (
            touristFromBase.Name == newTourist.Name &&
            touristFromBase.Email__c == newTourist.Email__c
          ) {
            newTourist.Is_Duplicate__c = true;
          }
        }
      }
    }
  }
}
