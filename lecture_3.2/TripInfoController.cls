public class TripInfoController {
    public Trip__c trip { get; set; }
    public List<Tourist__c> tourists { get; set; }

    public TripInfoController(ApexPages.StandardController stdController) {
        this.trip = (Trip__c) stdController.getRecord();
        this.tourists = TouristManager.getUnrelatedByTrip(trip.Id);
    }
}
