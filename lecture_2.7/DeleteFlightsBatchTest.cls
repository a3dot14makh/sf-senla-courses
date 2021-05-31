@IsTest
private class DeleteFlightsBatchTest {
    @TestSetup
    private static void setup(){
        List<Tourist__c> testTourists = TestDataFactory.createTourists(1);
    }
    
    @IsTest
    private static void testExecuteBatch(){
        Tourist__c tourist = TestDataFactory.getAllTestTourists()[0];
        Trip__c trip = TestDataFactory.createTrip(18, System.today().addMonths(1));
        insert trip;

        Flight__c flight = TestDataFactory.createFlights(
            tourist,
            trip,
            Constants.OBJECT_FIELD_VALUE_FLIGHT_STATUS_DECLINED
        );
        insert flight;

        Test.setCreatedDate(flight.Id, System.today().addDays(-35));
        
        Test.startTest();
        Database.executeBatch(new DeleteFlightsBatch());
        Test.stopTest();
        
        List<Flight__c> flightFromDB = [SELECT Id, Status__c FROM Flight__c];

        System.assertEquals(true, flightFromDB.isEmpty());
    }

    @IsTest
    private static void testExecuteBatch_FlightStatusOfferPending(){
        Tourist__c tourist = TestDataFactory.getAllTestTourists()[0];
        Trip__c trip = TestDataFactory.createTrip(18, System.today().addMonths(1));
        insert trip;

        Flight__c flight = TestDataFactory.createFlights(
            tourist,
            trip,
            Constants.OBJECT_FIELD_VALUE_FLIGHT_STATUS_OFFER_PENDING
        );
        insert flight;

        Test.setCreatedDate(flight.Id, System.today().addDays(-35));
        
        Test.startTest();
        Database.executeBatch(new DeleteFlightsBatch());
        Test.stopTest();
        
        Flight__c flightFromDB = TestDataFactory.getTestFlightsById(flight.Id);

        System.assertNotEquals(null, flightFromDB);
    }

    @IsTest
    private static void testExecuteBatch_FlightCreatedDateNotLaterThirtyDays(){
        Tourist__c tourist = TestDataFactory.getAllTestTourists()[0];
        Trip__c trip = TestDataFactory.createTrip(18, System.today().addMonths(1));
        insert trip;

        Flight__c flight = TestDataFactory.createFlights(
            tourist,
            trip,
            Constants.OBJECT_FIELD_VALUE_FLIGHT_STATUS_DECLINED
        );
        insert flight;

        Test.setCreatedDate(flight.Id, System.today().addDays(-25));
        
        Test.startTest();
        Database.executeBatch(new DeleteFlightsBatch());
        Test.stopTest();
        
        Flight__c flightFromDB = TestDataFactory.getTestFlightsById(flight.Id);

        System.assertNotEquals(null, flightFromDB);
    }
}