public class TouristManager {

    public static List<Tourist__c> getActiveWithFlights() {
        return [
            SELECT
                Name,
                Email__c,
                Gender__c,
                Active__c,
                Age__c,
                (SELECT Id, Trip__r.Start_Date__c, Trip__r.End_Date__c FROM Flights__r)
            FROM Tourist__c
            WHERE Active__c = TRUE
            ORDER BY Name ASC
        ];
    }
}
