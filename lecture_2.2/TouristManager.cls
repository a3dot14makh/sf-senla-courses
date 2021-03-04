public class TouristManager {
	public static List < Tourist__c > showTouristsByName(String touristName) {
		if (String.isBlank(touristName)) {
			return new List < Tourist__c > ();
		}

		return [
		Select Name, Age__c
		From Tourist__c
		WHERE Name = :touristName
		ORDER BY Age__c];
	}

	public static List < Tourist__c > showTouristsByAge(Decimal age1, Decimal age2, Decimal age3) {
		if (age1.scale() != 0 || age2.scale() != 0 || age3.scale() != 0) {
			//Integer chek
			return new List < Tourist__c > ();
		}

		return [
		Select Name, Age__c
		From Tourist__c
		WHERE Age__c IN(: age1, :age2, :age3)
		ORDER BY Age__c];
	}

	public static List < Tourist__c > showTouristsByYearOfFlightStart(Integer yearOfFlightStart) {
		if (String.valueOf(yearOfFlightStart).length() != 4) {
			//Length check  yearOfFlightStart
			return new List < Tourist__c > ();
		}

		return [
		SELECT Name, Age__c
		FROM Tourist__c
		WHERE Id IN(SELECT Tourist__c FROM Flight__c WHERE CALENDAR_YEAR(Trip__r.Start_Date__c) = 2020)
		ORDER BY Name];
	}

	public static Map < Tourist__c,
	List < Trip__c >> showTouristsWithFlights() {
		Map < Tourist__c, List < Trip__c >> mapTouristTrip = new Map < Tourist__c, List < Trip__c >> ();
		List < Tourist__c > touristList = [
		SELECT Name, Age__c, (SELECT Name, Trip__r.Name, Trip__r.Start_Date__c FROM Flights__r)
		FROM Tourist__c
		ORDER BY Name];

		//Parent to child query in Apex using inner query
		for (Tourist__c tourist: touristList) {
			List < Trip__c > tripList = new List < Trip__c > ();
			for (Flight__c flight: tourist.Flights__r) {
				tripList.add(flight.Trip__r);
			}
			mapTouristTrip.put(tourist, tripList);
		}

		return mapTouristTrip;
	}

	public static List < Tourist__c > showTouristsWithoutFlights() {
		
		return [
		SELECT Name, Age__c, (SELECT Trip__r.Name, Trip__r.Start_Date__c FROM Flights__r)
		FROM Tourist__c
		WHERE Id NOT IN(SELECT Tourist__c FROM Flight__c)
		ORDER BY Name];
	}

}