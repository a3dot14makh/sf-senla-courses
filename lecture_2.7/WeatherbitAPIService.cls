public class WeatherbitAPIService {
    private static final String REQUEST_HEADER_KEY_RAPIDAPI_HOST = 'x-rapidapi-host';
    private static final String REQUEST_HEADER_KEY_RAPIDAPI_KEY = 'x-rapidapi-key';
    private static final String REQUEST_HEADER_VALUE_RAPIDAPI_HOST = 'weatherbit-v1-mashape.p.rapidapi.com';
    private static final String RESPONSE_PARAMETER_DATA = 'data';
    private static final String RESPONSE_PARAMETER_DATETIME = 'datetime';
    private static final String RESPONSE_PARAMETER_TEMP = 'temp';

    public static HttpRequest createRequest(Decimal latitude, Decimal longitude) {
        HttpRequest request = new HttpRequest();
        String requestEndPointTemplate = '{0}?lat={1}&lon={2}&units=metric';
        List<Object> parameters = new List<Object>{ 'callout:Weatherbit_Endpoint', latitude, longitude };

        request.setEndpoint(String.format(requestEndPointTemplate, parameters));
        request.setMethod(Constants.HTTP_METHOD_GET);
        request.setHeader(REQUEST_HEADER_KEY_RAPIDAPI_HOST, REQUEST_HEADER_VALUE_RAPIDAPI_HOST);
        request.setHeader(REQUEST_HEADER_KEY_RAPIDAPI_KEY, Constants.REQUEST_HEADER_VALUE_RAPIDAPI_KEY);

        return request;
    }

    public static Map<Date, Decimal> parseForecastsUntyped(String responseBody) {
        Map<Date, Decimal> result = new Map<Date, Decimal>();
        Map<String, Object> forecastsUntyped = (Map<String, Object>) JSON.deserializeUntyped(
            responseBody
        );

        List<Object> dataObjects = (List<Object>) forecastsUntyped.get(RESPONSE_PARAMETER_DATA);
        List<Map<String, Object>> valueByParameter = new List<Map<String, Object>>();

        for (Object obj : dataObjects) {
            valueByParameter.add((Map<String, Object>) obj);
        }

        for (Map<String, Object> item : valueByParameter) {
            result.put(
                Date.valueOf(item.get(RESPONSE_PARAMETER_DATETIME).toString()),
                (Decimal) (item.get(RESPONSE_PARAMETER_TEMP))
            );
        }
        return result;
    }
}