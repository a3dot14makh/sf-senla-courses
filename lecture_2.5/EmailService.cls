public class EmailService {
  public static void sendEmailFromBatch(
    List<String> emailAddress,
    String subject,
    String plainTextBody
  ) {
    if (
      emailAddress == null ||
      emailAddress.isEmpty() ||
      String.isBlank(subject) ||
      String.isBlank(plainTextBody)
    ) {
    }
    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    message.setToAddresses(emailAddress);
    message.setSenderDisplayName('Batch Processing');
    message.setSubject(subject);
    message.setPlainTextBody(plainTextBody);
    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ message });
  }
}
