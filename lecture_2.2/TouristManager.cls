public class TouristManager {
  public static List<Tourist__c> getByName(String touristName) {
    if (String.isBlank(touristName)) {
      return new List<Tourist__c>();
    }

    return [
      SELECT Name, 
      Age__c
      FROM Tourist__c
      WHERE Name = :touristName
      ORDER BY Age__c
    ];
  }

  public static List<Tourist__c> getByAge(Set<Decimal> ageSet) {
    if (ageSet == null || ageSet.isEmpty()) {
      return new List<Tourist__c>();
    }

    return [
      SELECT Name, 
      Age__c
      FROM Tourist__c
      WHERE Age__c IN :ageSet
      ORDER BY Age__c
    ];
  }

  public static List<Tourist__c> getByYearOfFlightStart(
    Integer yearOfFlightStart
  ) {
    if (
      yearOfFlightStart == null ||
      String.valueOf(yearOfFlightStart).length() != 4
    ) {
      return new List<Tourist__c>();
    }

    return [
      SELECT Name, 
      Age__c
      FROM Tourist__c
      WHERE
        Id IN (
          SELECT Tourist__c
          FROM Flight__c
          WHERE CALENDAR_YEAR(Trip__r.Start_Date__c) = :yearOfFlightStart
        )
      ORDER BY Name
    ];
  }

  public static List<Tourist__c> getTouristWithTrips() {
    return [
      SELECT
        Name,
        Age__c,
        (SELECT Name, Trip__r.Name, Trip__r.Start_Date__c FROM Flights__r)
      FROM Tourist__c
      ORDER BY Name
    ];
  }

  public static List<Tourist__c> getTouristWithFlightsById(Set<Id> idSet) {
    if (idSet == null || idSet.isEmpty()) {
      return new List<Tourist__c>();
    }
    return [
      SELECT
        Id,
        Active__c,
        (SELECT Id, Trip__r.Start_Date__c, Status__c FROM Flights__r)
      FROM Tourist__c
      WHERE Id IN :idSet
    ];
  }

  public static List<Tourist__c> getWithoutFlights() {
    return [
      SELECT Name, 
      Age__c
      FROM Tourist__c
      WHERE Id NOT IN (SELECT Tourist__c FROM Flight__c)
      ORDER BY Name
    ];
  }
  public static List<Tourist__c> getByNameAndEmail(
    Set<String> nameSet,
    Set<String> emailSet
  ) {
    if (
      nameSet == null ||
      nameSet.isEmpty() ||
      emailSet == null ||
      emailSet.isEmpty()
    ) {
      return new List<Tourist__c>();
    }
    return [
      SELECT Id, 
      Name, 
      Email__c
      FROM Tourist__c
      WHERE Name IN :nameSet AND Email__c IN :emailSet
    ];
  }
}
