public class TouristManager {
    
    public static List<Tourist__c> getUnrelatedByTrip(Id tripId) {
        return [
            SELECT Name, 
            Upcoming_Flights_Count__c
            FROM Tourist__c
            WHERE Id NOT IN (SELECT Tourist__c FROM Flight__c WHERE Trip__c = :tripId)
            ORDER BY Upcoming_Flights_Count__c ASC
            LIMIT 10
        ];
    }
}
