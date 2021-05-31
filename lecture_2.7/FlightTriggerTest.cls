@IsTest
private class FlightTriggerTest {
    private static Tourist__c tourist;

    static {
        tourist = TestDataFactory.createTourists(1)[0];
    }

    @IsTest
    private static void testEventAfterInsert() {
        Trip__c trip = TestDataFactory.createTrip(16, System.today().addMonths(1));
        insert trip;

        Flight__c flight = TestDataFactory.createFlights(
            tourist,
            trip,
            Constants.OBJECT_FIELD_VALUE_FLIGHT_STATUS_OFFER_PENDING
        );

        Test.startTest();
        Database.SaveResult resultInsert = Database.insert(flight, false);
        Test.stopTest();

        Flight__c flightFromDB = TestDataFactory.getTestFlightsById(flight.Id);

        System.assertEquals(true, resultInsert.isSuccess());
        System.assertEquals(tourist.Id, flightFromDB.Tourist__c);
        System.assertEquals(trip.Id, flightFromDB.Trip__c);
        System.assertEquals(Constants.OBJECT_FIELD_VALUE_FLIGHT_STATUS_OFFER_PENDING, flightFromDB.Status__c);
    }

    @IsTest
    private static void testEventAfterInsert_ErrorTripStartDate() {
        Trip__c trip = TestDataFactory.createTrip(16, System.today().addMonths(-1));
        insert trip;

        Flight__c flight = TestDataFactory.createFlights(
            tourist,
            trip,
            Constants.OBJECT_FIELD_VALUE_FLIGHT_STATUS_OFFER_PENDING
        );

        Test.startTest();
        Database.SaveResult resultInsert = Database.insert(flight, false);
        Test.stopTest();

        System.assertEquals(false, resultInsert.isSuccess());
        System.assertEquals(false, resultInsert.getErrors().isEmpty());
        System.assertEquals(
            Constants.NEW_FLIGHT_VALIDATION_ERROR_TRIP_START_DATE,
            resultInsert.getErrors()[0].getMessage()
        );
    }

    @IsTest
    private static void testEventAfterInsert_ErrorTouristAge() {
        Trip__c trip = TestDataFactory.createTrip(70, System.today().addMonths(1));
        insert trip;

        Flight__c flight = TestDataFactory.createFlights(
            tourist,
            trip,
            Constants.OBJECT_FIELD_VALUE_FLIGHT_STATUS_OFFER_PENDING
        );

        Test.startTest();
        Database.SaveResult resultInsert = Database.insert(flight, false);
        Test.stopTest();

        System.assertEquals(false, resultInsert.isSuccess());
        System.assertEquals(false, resultInsert.getErrors().isEmpty());
        System.assertEquals(
            Constants.NEW_FLIGHT_VALIDATION_ERROR_TOURIST_AGE,
            resultInsert.getErrors()[0].getMessage()
        );
    }
}
