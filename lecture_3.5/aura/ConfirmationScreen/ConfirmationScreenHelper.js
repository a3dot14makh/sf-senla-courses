({
    createEvent : function(component, hasAgreed) {
        let event = component.getEvent("closeConfirmationScreen");
        event.setParams({ "hasAgreed": hasAgreed });
        event.fire();
    }
})