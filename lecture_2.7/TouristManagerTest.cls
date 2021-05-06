@isTest
private class TouristManagerTest {
    private static final Integer NUMBER_OF_CREATED_TOURISTS = 20;

    @isTest
    static void testGetById() {
        Map<Id, Tourist__c> touristsById = new Map<Id, Tourist__c>(
            TestDataFactory.createTourists(NUMBER_OF_CREATED_TOURISTS)
        );
        Set<Id> emptyIdSet = new Set<Id>();
        System.assert(TouristManager.getById(null).isEmpty());
        System.assert(TouristManager.getById(emptyIdSet).isEmpty());

        for (Tourist__c tourist : TouristManager.getById(touristsById.keySet())) {
            System.assert(touristsById.containsKey(tourist.Id));
        }
    }

    @isTest
    static void testGetByName() {
        List<Tourist__c> tourists = TestDataFactory.createTourists(NUMBER_OF_CREATED_TOURISTS);
        Id[] fixedSearchResults = new Id[1];
        fixedSearchResults[0] = tourists[0].Id;
        Test.setFixedSearchResults(fixedSearchResults);
        List<Tourist__c> touristsFromDB = TouristManager.getByName(tourists[0].Name);
        System.assertEquals(tourists[0].Id, touristsFromDB[0].Id);
    }

    @isTest
    static void testGetByDuplicateKeys() {
        Set<String> duplicateKeys = new Set<String>();
        Set<Id> exclusionId = new Set<Id>();
        List<Tourist__c> tourists = TestDataFactory.createTourists(NUMBER_OF_CREATED_TOURISTS);
        //To access formula field: DuplicateKey__c
        List<Tourist__c> touristsCreatedInDataFactoty = TestDataFactory.getAllTestTourists();

        for (Tourist__c tourist : touristsCreatedInDataFactoty) {
            duplicateKeys.add(tourist.DuplicateKey__c);
            exclusionId.add(tourist.Id);
        }
        System.assert(TouristManager.getByDuplicateKeys(duplicateKeys, exclusionId).isEmpty());
        exclusionId.remove(touristsCreatedInDataFactoty[0].Id);
        System.assertEquals(1, TouristManager.getByDuplicateKeys(duplicateKeys, exclusionId).size());
    }

    @isTest
    static void testGetByNameBirthdayEmail() {
        Set<String> names = new Set<String>();
        Set<Date> birthdays = new Set<Date>();
        Set<String> emails = new Set<String>();
        System.assert(TouristManager.getByNameBirthdayEmail(names, birthdays, emails).isEmpty());
        System.assert(TouristManager.getByNameBirthdayEmail(null, null, null).isEmpty());
        List<Tourist__c> tourists = TestDataFactory.createTourists(NUMBER_OF_CREATED_TOURISTS);

        for (Tourist__c tourist : tourists) {
            names.add(tourist.Name);
            birthdays.add(tourist.Birthday__c);
            emails.add(tourist.Email__c);
        }
        List<Tourist__c> touristsFromDB = TouristManager.getByNameBirthdayEmail(names, birthdays, emails);
        System.assertEquals(NUMBER_OF_CREATED_TOURISTS, touristsFromDB.size());

        for (Tourist__c tourist : touristsFromDB) {
            System.assertEquals(true, touristsFromDB.contains(tourist));
        }
    }
}
