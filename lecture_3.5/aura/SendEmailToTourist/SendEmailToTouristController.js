({
    sendEmail: function (component, event, helper) {
        const id = component.get("v.recordId");
        const emailAddress = component.get("v.tourist").Email__c;
        const name = component.get("v.tourist").Name;
        const senderDisplayName = "SF Morgen";
        const subject = "Check out suitable trips.";
        const htmlBody = $A.get("$Label.c.PublishedLink_SenlaProject") + "/?id=" + id + "&name=" + name;
        console.log(emailAddress);
        console.log(htmlBody);

        helper.sendEmailHelper(component, emailAddress, senderDisplayName, subject, htmlBody);
    }
});
