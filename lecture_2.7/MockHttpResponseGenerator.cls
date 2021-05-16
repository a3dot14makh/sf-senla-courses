@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();

        System.assertEquals(Constants.HTTP_METHOD_GET, req.getMethod());
        String responseBody = '';
        Integer statusCode = Constants.RESPONSE_STATUS_CODE_200;
        String pesponseStatus = Constants.RESPONSE_STATUS_OK;

        if (req.getEndpoint().contains('45.57')) {
            responseBody = '{"data":[{"datetime":"2021-05-16","temp":25.4},{"datetime":"2021-05-17","temp":27.7}]}';
        } else if (req.getEndpoint().contains('53.69')) {
            responseBody = '{"data":[{"datetime":"2021-05-16","temp":17},{"datetime":"2021-05-17","temp":15.2}]}';
        } else {
            statusCode = Constants.RESPONSE_STATUS_CODE_500;
            pesponseStatus = Constants.RESPONSE_STATUS_ERROR;
        }

        res.setHeader('Content-Type', 'application/json');
        res.setBody(responseBody);
        res.setStatusCode(statusCode);
        res.setStatus(pesponseStatus);

        return res;
    }
}
