@RestResource(urlMapping='/Tourist/*')
global with sharing class TouristRestService {

    @HttpGet
    global static void getTourists() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String name = request.params.get('fuzzyname');
        String ageString = request.params.get('age');

        if (String.isEmpty(name)) {
            response.responseBody = Blob.valueOf(Constants.RESPONSE_BODY_PARAMETER_NAME_EMPTY);
            response.statusCode = 404;
            return;
        }
        if (String.isEmpty(ageString)) {
            response.responseBody = Blob.valueOf(
                JSON.serializePretty(TouristManager.getByName(name))
            );
            return;
        }

        try {
            response.statusCode = 200;
            Integer age = Integer.valueOf(ageString);
            response.responseBody = Blob.valueOf(
                JSON.serializePretty(TouristManager.getByNameAndAge(name, age))
            );
        } catch (TypeException ex) {
            response.responseBody = Blob.valueOf(Constants.RESPONSE_BODY_PARAMETER_AGE_NOT_INTEGER);
            response.statusCode = 404;
        } catch (Exception ex) {
            response.responseBody = Blob.valueOf(ex.getMessage());
        }
    }

    @HttpPost
    global static void createTourist() {
        RestResponse response = RestContext.response;
        Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(
            RestContext.request.requestBody.toString()
        );

        List<Tourist__c> tourists = getTouristFromRequestBody(meta);

        if (TouristService.isDuplicate(tourists)) {
            response.statusCode = 409;
            response.responseBody = Blob.valueOf(Constants.RESPONSE_BODY_RECORDS_EXISTS);
        } else {

            try {
                insert tourists;
            } catch (DmlException ex) {
                response.responseBody = Blob.valueOf(ex.getMessage());
            }
        }
    }

    private static List<Tourist__c> getTouristFromRequestBody(Map<String, Object> meta) {
        List<Object> newRecords = (List<Object>) meta.get('records');
        List<Map<String, Object>> recordFieldsAndValues = new List<Map<String, Object>>();

        for (Object obj : newRecords) {
            recordFieldsAndValues.add((Map<String, Object>) obj);
        }
        List<Tourist__c> tourists = new List<Tourist__c>();
        
        for (Map<String, Object> item : recordFieldsAndValues) {
            Tourist__c newTourist = new Tourist__c(
                Name = item.get('name').toString(),
                Birthday__c = Date.valueOf(item.get('birthday').toString()),
                Email__c = item.get('email').toString()
            );
            tourists.add(newTourist);
        }
        return tourists;
    }
}
