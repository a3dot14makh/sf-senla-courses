public class TouristService {
  public static void markDuplicates(List<Tourist__c> newTouristList) {
    if (newTouristList.size() > 0) {
      List<String> selectionCriteriaNAme = new List<String>();
      for (Tourist__c newTourist : newTouristList) {
        selectionCriteriaNAme.add(newTourist.Name);
      }
      List<String> selectionCriteriaEmail = new List<String>();
      for (Tourist__c newTourist : newTouristList) {
        selectionCriteriaEmail.add(newTourist.Email__c);
      }
      List<Tourist__c> listFromBase = [
        SELECT Id, Name, Email__c
        FROM Tourist__c
        WHERE
          Name IN :selectionCriteriaNAme
          AND Email__c IN :selectionCriteriaEmail
      ];
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
