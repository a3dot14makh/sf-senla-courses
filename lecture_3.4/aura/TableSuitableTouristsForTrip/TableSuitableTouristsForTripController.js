({
    onTripLoaded: function (component, event, helper) {
        helper.validation(component);
    },

    displayData: function (component, event, helper) {
        helper.fetchTourists(component);
    },

    handleAddTripClick: function (component, event, helper) {
        component.set("v.showModals", true);
    },

    handleRowSelection: function (component, event, helper) {
        component.set("v.showButtonAddToTrip", component.find("suitableTourists").getSelectedRows().length);
    },

    closeConfirmationScreen: function (component, event, helper) {
        let isAddTourists = event.getParam("hasAgreed");
        if (isAddTourists) {
            helper.addToTrip(component);
        }
        component.set("v.showModals", false);
    }
});
