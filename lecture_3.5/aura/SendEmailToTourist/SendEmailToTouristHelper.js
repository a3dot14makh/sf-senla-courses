({
    sendEmailHelper: function(component, emailAddress, senderDisplayName, subject, htmlBody) {  
        let action = component.get("c.sendEmailToTourist");

        action.setParams({
            'emailAddress': emailAddress,
            'senderDisplayName': senderDisplayName,
            'subject': subject,
            'htmlBody': htmlBody
        }); 

        $A.enqueueAction(action);   
    }
})