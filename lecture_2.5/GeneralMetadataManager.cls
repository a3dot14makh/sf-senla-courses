public class GeneralMetadataManager {
    public static List<String> getEmails() {
        List<String> emailAddress = new List<String>();
        List<General_Metadata__mdt> tourists = [
            SELECT Email_Custom_Field__c
            FROM General_Metadata__mdt
        ];
        
        for (General_Metadata__mdt tourist : tourists) {
            emailAddress.add(tourist.Email_Custom_Field__c);
        }
        return emailAddress;
    }
}
