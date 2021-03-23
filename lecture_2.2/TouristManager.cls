public class TouristManager {
  public static List<Tourist__c> getByName(String touristName) {
    if (String.isBlank(touristName)) {
      return new List<Tourist__c>();
    }

    return [
      SELECT Name, Age__c
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
      SELECT Name, Age__c
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
      SELECT Name, Age__c
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

  public static Map<Tourist__c, List<Trip__c>> getTripsByTourist() {
    Map<Tourist__c, List<Trip__c>> mapTouristTrip = new Map<Tourist__c, List<Trip__c>>();
    List<Tourist__c> touristList = [
      SELECT
        Name,
        Age__c,
        (SELECT Name, Trip__r.Name, Trip__r.Start_Date__c FROM Flights__r)
      FROM Tourist__c
      ORDER BY Name
    ];
    //Parent to child query in Apex using inner query
    for (Tourist__c tourist : touristList) {
      List<Trip__c> tripList = new List<Trip__c>();
      for (Flight__c flight : tourist.Flights__r) {
        tripList.add(flight.Trip__r);
      }
      mapTouristTrip.put(tourist, tripList);
    }
    return mapTouristTrip;
  }

  public static List<Tourist__c> getWithoutFlights() {
    return [
      SELECT Name, Age__c
      FROM Tourist__c
      WHERE Id NOT IN (SELECT Tourist__c FROM Flight__c)
      ORDER BY Name
    ];
  }
}
