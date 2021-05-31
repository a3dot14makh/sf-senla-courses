@IsTest
private class TouristManagerTest {
    private static final Integer NUMBER_OF_CREATED_TOURISTS = 20;

    @TestSetup
    private static void setup() {
        List<Tourist__c> tourists = TestDataFactory.createTourists(NUMBER_OF_CREATED_TOURISTS);
    }

    @IsTest
    private static void testGetById() {
        Map<Id, Tourist__c> touristsById = new Map<Id, Tourist__c>(TestDataFactory.getAllTestTourists());

        for (Tourist__c tourist : TouristManager.getById(touristsById.keySet())) {
            System.assert(touristsById.containsKey(tourist.Id));
        }
    }

    @IsTest
    private static void testGetById_Null() {
        System.assertEquals(true, TouristManager.getById(null).isEmpty());
    }

    @IsTest
    private static void testGetById_Empty() {
        Set<Id> emptyIdSet = new Set<Id>();

        System.assertEquals(true, TouristManager.getById(emptyIdSet).isEmpty());
    }

    @IsTest
    private static void testGetByName() {
        List<Tourist__c> tourists = TestDataFactory.getAllTestTourists();
        List<Id> fixedSearchResults = new List<Id>{ tourists[0].Id };
        Test.setFixedSearchResults(fixedSearchResults);

        List<Tourist__c> touristsFromDB = TouristManager.getByName(tourists[0].Name);

        System.assertNotEquals(null, touristsFromDB);
        System.assertEquals(1, touristsFromDB.size());
        System.assertEquals(tourists[0].Id, touristsFromDB[0].Id);
        System.assertEquals(tourists[0].Name, touristsFromDB[0].Name);
        System.assertEquals(tourists[0].Age__c, touristsFromDB[0].Age__c);
    }

    @IsTest
    private static void testGetById_NameIsBlank() {
        String nameNull;
        String nameSpace = ' ';
        String nameEmpty = '';

        System.assertEquals(true, TouristManager.getByName(nameNull).isEmpty());
        System.assertEquals(true, TouristManager.getByName(nameSpace).isEmpty());
        System.assertEquals(true, TouristManager.getByName(nameEmpty).isEmpty());
    }

    @IsTest
    private static void testGetByDuplicateKeys() {
        Set<String> duplicateKeys = new Set<String>();
        Set<Id> exclusionId = new Set<Id>();
        List<Tourist__c> tourists = TestDataFactory.getAllTestTourists();

        for (Tourist__c tourist : tourists) {
            duplicateKeys.add(tourist.DuplicateKey__c);
            exclusionId.add(tourist.Id);
        }

        exclusionId.remove(tourists[0].Id);
        List<Tourist__c> touristFromDB = TouristManager.getByDuplicateKeys(duplicateKeys, exclusionId);

        System.assertNotEquals(null, touristsFromDB);
        System.assertEquals(1, touristFromDB.size());
        System.assertEquals(tourists[0].DuplicateKey__c, touristFromDB[0].DuplicateKey__c);
    }

    @IsTest
    private static void testGetByDuplicateKeys_NotDuplicateRecords() {
        Set<String> duplicateKeys = new Set<String>();
        Set<Id> exclusionId = new Set<Id>();
        List<Tourist__c> tourists = TestDataFactory.getAllTestTourists();

        for (Tourist__c tourist : tourists) {
            duplicateKeys.add(tourist.DuplicateKey__c);
            exclusionId.add(tourist.Id);
        }

        System.assertEquals(true, TouristManager.getByDuplicateKeys(duplicateKeys, exclusionId).isEmpty());
    }

    @IsTest
    private static void testGetByDuplicateKeys_Null() {
        List<Tourist__c> tourists = TestDataFactory.getAllTestTourists();
        Set<String> duplicateKeys = new Set<String>{ tourists[0].DuplicateKey__c };
        Set<Id> exclusionId = new Set<Id>{ tourists[0].Id };

        System.assertEquals(true, TouristManager.getByDuplicateKeys(null, exclusionId).isEmpty());
        System.assertEquals(true, TouristManager.getByDuplicateKeys(duplicateKeys, null).isEmpty());
        System.assertEquals(true, TouristManager.getByDuplicateKeys(null, null).isEmpty());
    }

    @IsTest
    private static void testGetByDuplicateKeys_Empty() {
        List<Tourist__c> tourists = TestDataFactory.getAllTestTourists();
        Set<String> duplicateKeys = new Set<String>{ tourists[0].DuplicateKey__c };
        Set<Id> exclusionId = new Set<Id>{ tourists[0].Id };

        Set<String> duplicateKeysEmpty = new Set<String>();
        Set<Id> exclusionIdEmpty = new Set<Id>();

        System.assertEquals(
            true,
            TouristManager.getByDuplicateKeys(duplicateKeysEmpty, exclusionId).isEmpty()
        );
        System.assertEquals(
            true,
            TouristManager.getByDuplicateKeys(duplicateKeys, exclusionIdEmpty).isEmpty()
        );
        System.assertEquals(
            true,
            TouristManager.getByDuplicateKeys(duplicateKeysEmpty, exclusionIdEmpty).isEmpty()
        );
    }
}
