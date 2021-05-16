@RestResource(urlMapping='/Tourist/*')
global with sharing class TouristRestService {
    private static final String REQUEST_PARAM_FUZZYNAME = 'fuzzyname';
    private static final String REQUEST_PARAM_AGE = 'age';

    @HttpGet
    global static void getTourists() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String name = request.params.get(REQUEST_PARAM_FUZZYNAME);
        String ageString = request.params.get(REQUEST_PARAM_AGE);

        try {
            validateRequestParams(name, ageString);
        } catch (RestRequestValidationException ex) {
            response.statusCode = ex.getStatusCode();
            String msg = ex.getMessage();
            response.responseBody = Blob.valueOf(ex.getMessage());
        } catch (Exception ex) {
            response.statusCode = Constants.RESPONSE_STATUS_CODE_500;
            response.responseBody = Blob.valueOf(Constants.RESPONSE_BODY_INTERNAL_SERVER_ERROR);
        }
    }

    @HttpPost
    global static void createTourist() {
        TouristWrapper deserializedRequestData = TouristWrapper.parse(
            RestContext.request.requestBody.toString()
        );
        List<Tourist__c> tourists = convertRecordsToTouristList(deserializedRequestData.records);
        RestResponse response = RestContext.response;

        if (TouristService.isDuplicate(tourists)) {
            response.statusCode = Constants.RESPONSE_STATUS_CODE_409;
            response.responseBody = Blob.valueOf(Constants.RESPONSE_BODY_RECORDS_EXISTS);
        } else {
            try {
                insert tourists;
                response.statusCode = Constants.RESPONSE_STATUS_CODE_200;
            } catch (DmlException ex) {
                response.statusCode = Constants.RESPONSE_STATUS_CODE_500;
                response.responseBody = Blob.valueOf(Constants.RESPONSE_BODY_INTERNAL_SERVER_ERROR);
            }
        }
    }

    private static List<Tourist__c> convertRecordsToTouristList(List<TouristWrapper.Record> records) {
        List<Tourist__c> tourists = new List<Tourist__c>();

        for (TouristWrapper.Record record : records) {
            Tourist__c newTourist = new Tourist__c(
                Name = record.name,
                Birthday__c = Date.valueOf(record.birthday),
                Email__c = record.email
            );
            tourists.add(newTourist);
        }
        return tourists;
    }
    
    private static void validateRequestParams(String name, String ageString) {
        if (String.isEmpty(name)) {
            throw new RestRequestValidationException(
                Constants.RESPONSE_STATUS_CODE_404,
                Constants.RESPONSE_BODY_PARAMETER_NAME_EMPTY
            );
        }
        if (String.isEmpty(ageString)) {
            throw new RestRequestValidationException(
                Constants.RESPONSE_STATUS_CODE_200,
                JSON.serializePretty(TouristManager.getByName(name))
            );
        }
        if (ageString.isNumeric()) {
            throw new RestRequestValidationException(
                Constants.RESPONSE_STATUS_CODE_200,
                JSON.serializePretty(TouristManager.getByNameAndAge(name, Integer.valueOf(ageString)))
            );
        } else {
            throw new RestRequestValidationException(
                Constants.RESPONSE_STATUS_CODE_404,
                Constants.RESPONSE_BODY_PARAMETER_AGE_NOT_INTEGER
            );
        }
    }
}