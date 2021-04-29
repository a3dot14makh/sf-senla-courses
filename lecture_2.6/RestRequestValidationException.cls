public class RestRequestValidationException extends Exception {
    private String errorMsg;
    private Integer statusCode;

    public RestRequestValidationException(Integer statusCode, String errorMsg) {
        this.statusCode = statusCode;
        this.errorMsg = errorMsg;
    }

    public override String getMessage() {
        return errorMsg;
    }

    public Integer getStatusCode() {
        return statusCode;
    }
}
