@IsTest
public class TestDataFactory {
    
    public static List<Tourist__c> createTourists(Integer numToCreate) {
        Date minDate = Date.newInstance(1969, 9, 4);
        List<Tourist__c> tourists = new List<Tourist__c>();
        for (Integer i = 0; i < numToCreate; i++) {
            Decimal randomNum = 100 * math.Random();
            tourists.add(
                new Tourist__c(
                    Name = 'Liudovik ' + i,
                    Birthday__c = minDate.addDays(randomNum.intValue()),
                    Email__c = 'liudovik' + i + '@france.king'
                )
            );
        }
        insert tourists;
        return tourists;
    }

    public static Tourist__c createTouristsByBirthday(Date birthday) {
        Tourist__c tourist = new Tourist__c(
            Name = 'Gedimin',
            Birthday__c = birthday,
            Email__c = 'kniaz@mail.vkl'
        );

        return tourist;
    }

    public static Trip__c createTrip(Integer minimumAge, Date startDate) {
        Trip__c trip = new Trip__c(Minimum_Age__c = minimumAge, Start_Date__c = startDate);

        return trip;
    }

    public static Flight__c createFlights(Tourist__c tourist, Trip__c trip, String status) {
        Flight__c flight = new Flight__c(Tourist__c = tourist.Id, Trip__c = trip.Id, Status__c = status);

        return flight;
    }

    public static void createSpacePoints() {
        List<Space_Point__c> spacePoints = new List<Space_Point__c>{
            new Space_Point__c(Name = 'Baikonur', Latitude__c = 45.57, Longitude__c = 63.18),
            new Space_Point__c(Name = 'Hrodna', Latitude__c = 53.69, Longitude__c = 23.83)
        };

        insert spacePoints;
    }

    public static List<Tourist__c> getAllTestTourists() {
        return [
            SELECT Id, Name, Age__c, Birthday__c, Email__c, Is_Duplicate__c, DuplicateKey__c
            FROM Tourist__c
        ];
    }

    public static Flight__c getTestFlightsById(Id flightId) {
        return [SELECT Id, Status__c, Tourist__c, Trip__c FROM Flight__c WHERE Id = :flightId];
    }
}
