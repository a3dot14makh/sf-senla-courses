public class TouristManager {

    public static List<Tourist__c> getById(Set<Id> idSet) {
        if (idSet == null || idSet.isEmpty()) {
            return new List<Tourist__c>();
        }
        return [
            SELECT Id, 
            Age__c, 
            DuplicateKey__c 
            FROM Tourist__c 
            WHERE Id IN :idSet
        ];
    }

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

    public static List<Tourist__c> getTouristWithFlightsById(Set<Id> idSet) {
        if (idSet == null || idSet.isEmpty()) {
            return new List<Tourist__c>();
        }
        return [
            SELECT Id, 
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

    public static List<Tourist__c> getByDuplicateKeys(Set<String> duplicateKeys, Set<Id> exclusionId) {
        if (
            duplicateKeys == null ||
            duplicateKeys.isEmpty() ||
            exclusionId == null ||
            exclusionId.isEmpty()
        ) {
            return new List<Tourist__c>();
        }
        return [
            SELECT Id, 
            DuplicateKey__c
            FROM Tourist__c
            WHERE Id NOT IN :exclusionId AND DuplicateKey__c IN :duplicateKeys
        ];
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
