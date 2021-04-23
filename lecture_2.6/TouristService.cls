public class TouristService {

    public static Boolean isDuplicate(List<Tourist__c> inputTourists) {
        Set<String> names = new Set<String>();
        Set<Date> birthdays = new Set<Date>();
        Set<String> emails = new Set<String>();
        Set<String> duplicateKeys = new Set<String>();

        for (Tourist__c tourist : inputTourists) {
            names.add(tourist.Name);
            birthdays.add(tourist.Birthday__c);
            emails.add(tourist.Email__c);
        }

        for (Tourist__c tourist : TouristManager.getByNameBirthdayEmail(names, birthdays, emails)) {
            String duplicateKey = tourist.Name + tourist.Birthday__c + tourist.Email__c;
            duplicateKeys.add(duplicateKey);
        }

        for (Tourist__c tourist : inputTourists) {
            String duplicateKey = tourist.Name + tourist.Birthday__c + tourist.Email__c;
            if (duplicateKeys.contains(duplicateKey)) {
                return true;
            }
        }
        return false;
    }
}
