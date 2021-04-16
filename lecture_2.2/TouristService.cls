public class TouristService {
    
    public static void markDuplicates(List<Tourist__c> newTourists) {
        if (newTourists == null || newTourists.isEmpty()) {
            return;
        }

        Set<String> names = new Set<String>();
        Set<String> emails = new Set<String>();
        Set<String> duplicateKeys = new Set<String>();

        for (Tourist__c tourist : newTourists) {
            names.add(tourist.Name);
            emails.add(tourist.Email__c);
        }

        for (Tourist__c tourist : TouristManager.getByNameAndEmail(names, emails)) {
            String duplicateKey = tourist.Name + tourist.Email__c;
            duplicateKeys.add(duplicateKey);
        }

        for (Tourist__c tourist : newTourists) {
            String duplicateKey = tourist.Name + tourist.Email__c;
            if (duplicateKeys.contains(duplicateKey)) {
                tourist.Is_Duplicate__c = true;
            }
        }
    }

    public static Map<Tourist__c, List<Trip__c>> getTripsByTourist() {
        Map<Tourist__c, List<Trip__c>> mapTouristTrip = new Map<Tourist__c, List<Trip__c>>();
        List<Tourist__c> touristList = TouristManager.getTouristWithTrips();

        for (Tourist__c tourist : touristList) {
            List<Trip__c> tripList = new List<Trip__c>();

            for (Flight__c flight : tourist.Flights__r) {
                tripList.add(flight.Trip__r);
            }
            mapTouristTrip.put(tourist, tripList);
        }
        return mapTouristTrip;
    }
}
