@IsTest
public class TestDataFactory {

    public static List<Tourist__c> createTourists(Integer numToCreate) {
        Date minDate = Date.newInstance(1969, 9, 4);
        List<Tourist__c> tourists = new List<Tourist__c>();
        for (Integer i = 0; i < numToCreate; i++) {
            Decimal daysToAdd = 100 * math.Random();
            tourists.add(
                new Tourist__c(
                    Name = 'Liudovik ' + i,
                    Birthday__c = minDate.addDays(daysToAdd.intValue()),
                    Email__c = 'liudovik' + i + '@france.king'
                )
            );
        }
        insert tourists;
        return tourists;
    }

    public static void createFlights(List<Tourist__c> tourists, List<Trip__c> trips) {
        List<Flight__c> flights = new List<Flight__c>();

        for (Tourist__c tourist : tourists) {
            for (Trip__c trip : trips) {
                flights.add(
                    new Flight__c(Status__c = 'Offer Pending', Tourist__c = tourist.Id, Trip__c = trip.Id)
                );
            }
        }

        insert flights;
    }

    public static List<Tourist__c> getAllTestTourists() {
        return [
            SELECT Id, 
            Is_Duplicate__c, 
            DuplicateKey__c 
            FROM Tourist__c
        ];
    }

    public static List<Flight__c> getAllTestFlights() {
        return [
            SELECT Id, 
            Status__c 
            FROM Flight__c
        ];
    }
}
