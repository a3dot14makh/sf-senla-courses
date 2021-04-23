public class SpacePointManager {
    
    public static List<Space_Point__c> getAll() {
        return [
            SELECT Name, 
            Latitude__c, 
            Longitude__c 
            FROM Space_Point__c 
            ORDER BY Name
        ];
    }
}
