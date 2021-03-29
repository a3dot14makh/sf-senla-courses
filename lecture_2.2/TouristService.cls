public class TouristService {
  public static void markDuplicates(List<Tourist__c> newTouristList) {
    if (newTouristList == null || newTouristList.isEmpty()) {
      return;
    }
    
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

  public static Map<Tourist__c, List<Trip__c>> getTripsByTourist() {
    Map<Tourist__c, List<Trip__c>> mapTouristTrip = new Map<Tourist__c, List<Trip__c>>();
    List<Tourist__c> touristList = TouristManager.getTouristWithTrips();

    for (Tourist__c tourist : touristList) {
      List<Trip__c> tripList = new List<Trip__c>();
      for (Flight__c flight : tourist.Flights__r) {
        tripList.add(flight.Trip__r);
      }
      mapTouristTrip.put(tourist, tripList);
    }
    return mapTouristTrip;
  }
}
