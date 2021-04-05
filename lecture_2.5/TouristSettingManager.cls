public class TouristSettingManager {
  public static List<String> getEmails() {
    List<String> emailAddress = new List<String>();
    List<Tourist_Setting__mdt> tourists = [
      SELECT Email_Custom_Field__c
      FROM Tourist_Setting__mdt
    ];
    for (Tourist_Setting__mdt tourist : tourists) {
      emailAddress.add(tourist.Email_Custom_Field__c);
    }
    return emailAddress;
  }
}
