public class TouristService {
    public static void markDuplicates(List<Tourist__c> newTouristList) {
        if (newTouristList == null || newTouristList.isEmpty()) {
            return;
        }

        Set<String> names = new Set<String>();
        Set<String> emails = new Set<String>();
        
        for (Tourist__c newTourist : newTouristList) {
            names.add(newTourist.Name);
            emails.add(newTourist.Email__c);
        }
        List<Tourist__c> listFromBase = TouristManager.getByNameAndEmail(names, emails);

        for (Tourist__c touristFromBase : listFromBase) {
            for (Tourist__c newTourist : newTouristList) {
                if (
                    touristFromBase.Name == newTourist.Name &&
                    touristFromBase.Email__c == newTourist.Email__c
                ) {
                    newTourist.Is_Duplicate__c = true;
                }
            }
        }
    }

    @future
    public static void markDuplicatesAsync(Set<Id> touristIds) {
        List<Tourist__c> newTouristsList = TouristManager.getById(touristIds);
        //DuplicateKey__c - formula field: Name + Email__c
        Set<String> duplicateKeys = new Set<String>();

        for (Tourist__c tourist : newTouristsList) {
            duplicateKeys.add(tourist.DuplicateKey__c);
        }
        Set<String> existingDuplicateKeys = new Set<String>();

        for (Tourist__c tourist : TouristManager.getByDuplicateKeys(duplicateKeys, touristIds)) {
            existingDuplicateKeys.add(tourist.DuplicateKey__c);
        }
        List<Tourist__c> touristToUpdate = new List<Tourist__c>();

        for (Tourist__c tourist : newTouristsList) {
            if (existingDuplicateKeys.contains(tourist.DuplicateKey__c)) {
                tourist.Is_Duplicate__c = true;
                touristToUpdate.add(tourist);
            }
        }
        update touristToUpdate;
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
