public class EmailService {
    public static void sendEmailFromBatch(List<String> emailAddress, String subject, String htmlBody) {
        if (
            emailAddress == null ||
            emailAddress.isEmpty() ||
            String.isBlank(subject) ||
            String.isBlank(htmlBody)
        ) {
            return;
        }
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(emailAddress);
        message.setSenderDisplayName('Batch Processing');
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ message });
    }
}
