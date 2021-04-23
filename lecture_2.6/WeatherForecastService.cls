public class WeatherForecastService {
    public class WeatherForecastException extends Exception {}

    public static Map<Date, Decimal> getForecasts(Decimal latitude, Decimal longitude) {
        Map<Date, Decimal> result = new Map<Date, Decimal>();
        Http http = new Http();
        HTTPResponse response = http.send(createRequest(latitude, longitude));

        if (response.getStatusCode() == 200) {
            Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(
                response.getBody()
            );

            List<Object> dataObjects  = (List<Object>) meta.get('data');
            List<Map<String, Object>> valueByParameter = new List<Map<String, Object>>();

            for (Object obj : dataObjects) {
                valueByParameter.add((Map<String, Object>) obj);
            }

            for (Map<String, Object> item : valueByParameter) {
                result.put(
                    Date.valueOf(item.get('datetime').toString()),
                    (Decimal) (item.get('temp'))
                );
            }
        }else {
            throw new WeatherForecastException(response.getStatusCode() + ' ' + response.getStatus());
        }

        return result;
    }

    private static HttpRequest createRequest(Decimal latitude, Decimal longitude) {
        HttpRequest request = new HttpRequest();
        String requestEndPoint =
            Constants.REQUEST_ENDPOINT_IN_WEATHERBIT +
            '?lat=' +
            latitude +
            '&lon=' +
            longitude +
            '&units=metric';

        request.setEndpoint(requestEndPoint);
        request.setMethod('GET');
        request.setHeader('x-rapidapi-host', Constants.REQUEST_HEADER_RAPIDAPI_HOST);
        request.setHeader('x-rapidapi-key', Constants.REQUEST_HEADER_RAPIDAPI_KEY);

        return request;
    }
}
