public class TouristService {
	public static void markDuplicates(List < Tourist__c > newTouristList) {
		List < Tourist__c > listFromBase = [SELECT Id, Name, Email__c FROM Tourist__c];
		for (Tourist__c touristFromBase: listFromBase) {
			for (Tourist__c newTourist: newTouristList) {
				if (touristFromBase.Name == newTourist.Name && touristFromBase.Email__c == newTourist.Email__c) {
					newTourist.Is_Duplicate__c = true;
				}
			}
		}
		insert(newTouristList);
	}
}