global class ErrorMockResponse implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();

        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(Constants.RESPONSE_STATUS_CODE_500);
        res.setStatus(Constants.RESPONSE_STATUS_ERROR);

        return res;
    }
}
