@IsTest
private class TouristTriggerTest {
    
    @TestSetup
    static void setup() {
        List<Tourist__c> testTourists = TestDataFactory.createTourists(1);
    }

    @IsTest
    private static void testEventAfterInsert_duplicateTourist() {
        Tourist__c tourist = TestDataFactory.getAllTestTourists()[0];
        Tourist__c duplicateTourist = new Tourist__c(
            Name = tourist.Name,
            Birthday__c = tourist.Birthday__c,
            Email__c = tourist.Email__c
        );

        Test.startTest();
        Database.SaveResult resultInsert = Database.insert(duplicateTourist, false);
        Test.stopTest();

        Integer expectedNumTouristsMarked = 1;
        checkEventAfterInsert(expectedNumTouristsMarked, resultInsert);
    }

    @IsTest
    private static void testEventAfterInsert_notDuplicateTourist() {
        Tourist__c tourist = TestDataFactory.getAllTestTourists()[0];
        Tourist__c notDuplicateTourist = new Tourist__c(
            Name = tourist.Name,
            Birthday__c = tourist.Birthday__c.addMonths(4),
            Email__c = tourist.Email__c
        );

        Test.startTest();
        Database.SaveResult resultInsert = Database.insert(notDuplicateTourist, false);
        Test.stopTest();

        Integer expectedNumTouristsMarked = 0;
        checkEventAfterInsert(expectedNumTouristsMarked, resultInsert);
    }

    @IsTest
    private static void testEventAfterUpdate_FutureTrip() {
        Tourist__c tourist = TestDataFactory.getAllTestTourists()[0];

        Trip__c trip = TestDataFactory.createTrip(18, System.today().addMonths(1));
        insert trip;

        Flight__c flight = TestDataFactory.createFlights(
            tourist,
            trip,
            Constants.OBJECT_FIELD_VALUE_FLIGHT_STATUS_OFFER_PENDING
        );
        insert flight;

        TouristTriggerHandler.wasExecuted = false;
        tourist.Active__c = false;

        Test.startTest();
        Database.SaveResult resultUpdate = Database.update(tourist, false);
        Test.stopTest();

        Flight__c flightFromDB = TestDataFactory.getTestFlightsById(flight.Id);

        System.assertEquals(true, resultUpdate.isSuccess());
        System.assertEquals(Constants.OBJECT_FIELD_VALUE_FLIGHT_STATUS_DECLINED, flightFromDB.Status__c);
    }

    @IsTest
    private static void testEventAfterUpdate_PastTrip() {
        Tourist__c tourist = TestDataFactory.getAllTestTourists()[0];
        Trip__c trip = TestDataFactory.createTrip(18, System.today().addMonths(1));
        insert trip;

        Flight__c flight = TestDataFactory.createFlights(
            tourist,
            trip,
            Constants.OBJECT_FIELD_VALUE_FLIGHT_STATUS_OFFER_PENDING
        );
        insert flight;

        //To pass Flight validation
        trip.Start_Date__c = System.today().addMonths(-1);
        update trip;

        tourist.Active__c = false;

        Test.startTest();
        Database.SaveResult resultUpdate = Database.update(tourist, false);
        Test.stopTest();

        Flight__c flightFromDB = TestDataFactory.getTestFlightsById(flight.Id);

        System.assertEquals(true, resultUpdate.isSuccess());
        System.assertEquals(Constants.OBJECT_FIELD_VALUE_FLIGHT_STATUS_OFFER_PENDING, flightFromDB.Status__c);
    }

    private static void checkEventAfterInsert(
        Integer expectedNumTouristsMarked,
        Database.SaveResult resultInsert
    ) {
        List<Tourist__c> touristsFromDB = TestDataFactory.getAllTestTourists();
        Integer numTouristsMarked = 0;

        for (Tourist__c tourist : touristsFromDB) {
            if (tourist.Is_Duplicate__c == true && tourist.Id == resultInsert.getId()) {
                numTouristsMarked++;
            }
        }

        System.assertEquals(true, resultInsert.isSuccess());
        System.assertEquals(2, touristsFromDB.size());
        System.assertEquals(expectedNumTouristsMarked, numTouristsMarked);
    }
}
