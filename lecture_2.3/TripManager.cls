public with sharing class TripManager {
  public static List<Trip__c> getById(Set<Id> idSet) {
    if (idSet == null || idSet.isEmpty()) {
      return new List<Trip__c>();
    }
    return [
      SELECT Start_Date__c, Minimum_Age__c, Id
      FROM Trip__c
      WHERE Id IN :idSet
    ];
  }
}
