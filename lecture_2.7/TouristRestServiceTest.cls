@IsTest
private class TouristRestServiceTest {
    private static final String REQUEST_PARAM_FUZZYNAME = 'fuzzyname';
    private static final String REQUEST_PARAM_AGE = 'age';

    @TestSetup
    static void setup() {
        Tourist__c tourist = TestDataFactory.createTouristsByBirthday(Date.newInstance(1974, 6, 13));
        insert tourist;
    }

    @IsTest
    private static void testGetTourists() {
        Tourist__c tourist = TestDataFactory.getAllTestTourists()[0];
        String name = tourist.Name;
        String age = String.valueOf(tourist.Age__c);

        List<Id> fixedSearchResults = new List<Id>{ tourist.Id };
        Test.setFixedSearchResults(fixedSearchResults);

        System.RestResponse response = getResponse(name, age);

        List<Tourist__c> dataTourist = (List<Tourist__c>) JSON.deserialize(
            response.responseBody.toString(),
            List<Tourist__c>.class
        );

        System.assertEquals(Constants.RESPONSE_STATUS_CODE_200, response.statusCode);
        System.assertEquals(tourist.Id, dataTourist[0].Id);
        System.assertEquals(name, dataTourist[0].Name);
    }

    @IsTest
    private static void testGetTourists_ParametrNameIsEmpty() {
        Tourist__c tourist = TestDataFactory.getAllTestTourists()[0];
        String name;
        String age = String.valueOf(tourist.Age__c);

        System.RestResponse response = getResponse(name, age);

        System.assertEquals(Constants.RESPONSE_STATUS_CODE_404, response.statusCode);
        System.assertEquals(Constants.RESPONSE_BODY_PARAMETER_NAME_EMPTY, response.responseBody.toString());
    }

    @IsTest
    private static void testGetTourists_ParametrAgeIsEmpty() {
        Tourist__c tourist = TestDataFactory.getAllTestTourists()[0];
        String name = tourist.Name;
        String age;

        List<Id> fixedSearchResults = new List<Id>{ tourist.Id };
        Test.setFixedSearchResults(fixedSearchResults);

        System.RestResponse response = getResponse(name, age);

        List<Tourist__c> dataTourist = (List<Tourist__c>) JSON.deserialize(
            response.responseBody.toString(),
            List<Tourist__c>.class
        );

        System.assertEquals(Constants.RESPONSE_STATUS_CODE_200, response.statusCode);
        System.assertEquals(tourist.Id, dataTourist[0].Id);
        System.assertEquals(name, dataTourist[0].Name);
    }

    @IsTest
    private static void testGetTourists_ParametrAgeNotInteger() {
        Tourist__c tourist = TestDataFactory.getAllTestTourists()[0];
        String name = tourist.Name;
        String age = 'f16';

        System.RestResponse response = getResponse(name, age);

        System.assertEquals(Constants.RESPONSE_STATUS_CODE_404, response.statusCode);
        System.assertEquals(
            Constants.RESPONSE_BODY_PARAMETER_AGE_NOT_INTEGER,
            response.responseBody.toString()
        );
    }

    @IsTest
    private static void testCreateTourist_RecordIsNotDuplicate() {
        TouristWrapper.Record recordFirstTourist = new TouristWrapper.Record();
        recordFirstTourist.name = 'Morgen';
        recordFirstTourist.birthday = '1998-02-17';
        recordFirstTourist.email = 'ratatatata@kovboi.com';
        TouristWrapper.Record recordSecondTourist = new TouristWrapper.Record();
        recordSecondTourist.name = 'Nurik';
        recordSecondTourist.birthday = '1991-12-22';
        recordSecondTourist.email = 'mitsubishi@galant.kz';

        List<TouristWrapper.Record> records = new List<TouristWrapper.Record>{
            recordFirstTourist,
            recordSecondTourist
        };

        System.RestResponse response = getResponse(records);

        List<Tourist__c> tourists = TestDataFactory.getAllTestTourists();

        System.assertEquals(Constants.RESPONSE_STATUS_CODE_200, response.statusCode);
        System.assert(tourists.size() == 3);
        System.assertEquals(recordFirstTourist.name, tourists[1].Name);
        System.assertEquals(recordSecondTourist.name, tourists[2].Name);
    }

    @IsTest
    private static void testCreateTourist_RecordIsDuplicate() {
        Tourist__c tourist = TestDataFactory.getAllTestTourists()[0];

        TouristWrapper.Record duplicateRecord = new TouristWrapper.Record();
        duplicateRecord.name = tourist.Name;
        duplicateRecord.birthday = String.valueOf(tourist.Birthday__c);
        duplicateRecord.email = tourist.Email__c;

        List<TouristWrapper.Record> records = new List<TouristWrapper.Record>{ duplicateRecord };

        System.RestResponse response = getResponse(records);

        List<Tourist__c> tourists = TestDataFactory.getAllTestTourists();

        System.assertEquals(Constants.RESPONSE_STATUS_CODE_409, response.statusCode);
        System.assertEquals(Constants.RESPONSE_BODY_RECORDS_EXISTS, response.responseBody.toString());
        System.assert(tourists.size() == 1);
        System.assertEquals(tourist.Id, tourists[0].Id);
    }

    private static System.RestResponse getResponse(String name, String age) {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addParameter(REQUEST_PARAM_FUZZYNAME, name);
        req.addParameter(REQUEST_PARAM_AGE, age);

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TouristRestService.getTourists();
        Test.stopTest();

        return res;
    }

    private static System.RestResponse getResponse(List<TouristWrapper.Record> records) {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        TouristWrapper touristWrapper = new TouristWrapper();
        touristWrapper.records = records;

        String requestBody = JSON.serializePretty(touristWrapper);
        req.requestBody = Blob.valueOf(requestBody);

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        TouristRestService.createTourist();
        Test.stopTest();

        return res;
    }
}
