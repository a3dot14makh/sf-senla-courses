public class TouristService {
  public static void markDuplicates(List<Tourist__c> newTouristList) {
    if (newTouristList.size() > 0) {
      Set<String> names = new Set<String>();
      Set<String> emails = new Set<String>();
      for (Tourist__c newTourist : newTouristList) {
        names.add(newTourist.Name);
        emails.add(newTourist.Email__c);
      }
      List<Tourist__c> listFromBase = TouristManager.getByNameAndEmail(names, emails);
      
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
      insert newTouristList;
    }
  }
}
