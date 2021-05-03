public class TouristManager {

    public static List<Tourist__c> getByName(String name) {
        if (String.isBlank(name)) {
            return new List<Tourist__c>();
        }
        List<List<Tourist__c>> tourists = [
            FIND :name
            IN NAME FIELDS
            RETURNING Tourist__c(Name, Age__c)
        ];

        return tourists.get(0);
    }

    public static List<Tourist__c> getByNameAndAge(String name, Integer age) {
        if (String.isEmpty(name) || age == null) {
            return new List<Tourist__c>();
        }
        List<List<Tourist__c>> tourists = [
            FIND :name
            IN NAME FIELDS
            RETURNING Tourist__c(Name, Age__c WHERE Age__c = :age)
        ];

        return tourists.get(0);
    }

    public static List<Tourist__c> getByNameBirthdayEmail(
        Set<String> names,
        Set<Date> birthdays,
        Set<String> emails
    ) {
        if (
            names == null ||
            names.isEmpty() ||
            birthdays == null ||
            birthdays.isEmpty() ||
            emails == null ||
            emails.isEmpty()
        ) {
            return new List<Tourist__c>();
        }
        return [
            SELECT Name, 
            Birthday__c, 
            Email__c
            FROM Tourist__c
            WHERE Name IN :names AND Birthday__c IN :birthdays AND Email__c IN :emails
        ];
    }
}
