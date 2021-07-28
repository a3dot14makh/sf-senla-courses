public inherited sharing class SendEmailToTouristController {
    
    @AuraEnabled
    public static void sendEmailToTourist(
        String emailAddress,
        String senderDisplayName,
        String subject,
        String htmlBody
    ) {
        List<String> emailAddressList = new List<String>{ emailAddress };
        EmailService.sendEmail(emailAddressList, senderDisplayName, subject, htmlBody);
    }
}