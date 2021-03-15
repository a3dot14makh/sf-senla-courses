public with sharing class TouristTriggerHandler {
  public static void onBeforeInsert(List<Tourist__c> newFlightList) {
    List<Tourist__c> listFromBase = [SELECT Id, Name, Email__c FROM Tourist__c];
    for (Tourist__c touristFromBase : listFromBase) {
      for (Tourist__c newTourist : newFlightList) {
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
    List<Tourist__c> toutistWithFlight = [
      SELECT
        Id,
        Active__c,
        (SELECT Id, Trip__r.Start_Date__c, Status__c FROM Flights__r)
      FROM Tourist__c
      WHERE Id IN :newMap.keySet()
    ];
    List<Flight__c> flightToUpdate = new List<Flight__c>();

    for (Tourist__c tourist : toutistWithFlight) {
      //Получаю и сравниваю значение поля Active в старой и новой Мапе
      if (
        oldMap.get(tourist.Id).Active__c == true &&
        newMap.get(tourist.Id).Active__c == false
      ) {
        //Для всех связанныз с этим туристом я меняю поле Статус
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
