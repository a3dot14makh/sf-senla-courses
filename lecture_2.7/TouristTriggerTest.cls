@isTest
private class TouristTriggerTest {
    private static final Integer NUMBER_OF_CREATED_TOURISTS = 20;
    
    @isTest
    static void checkTriggerEventsAfterInsert() {
        List<Tourist__c> tourists = TestDataFactory.createTourists(NUMBER_OF_CREATED_TOURISTS);
        List<Tourist__c> touristsToInsert = new List<Tourist__c>();

        for (Tourist__c tourist : tourists) {
            touristsToInsert.add(
                new Tourist__c(
                    Name = tourist.Name,
                    Birthday__c = tourist.Birthday__c,
                    Email__c = tourist.Email__c
                )
            );
        }

        Test.startTest();
        insert touristsToInsert;
        Test.stopTest();
        Integer numTouristsMarked = 0;
        Integer numAllTourists = 0;

        for (Tourist__c tourist : TestDataFactory.getAllTestTourists()) {
            numAllTourists++;
            if (tourist.Is_Duplicate__c) {
                numTouristsMarked++;
            }
        }
        System.assertEquals(NUMBER_OF_CREATED_TOURISTS * 2, numAllTourists);
        System.assertEquals(NUMBER_OF_CREATED_TOURISTS, numTouristsMarked);
    }
}
