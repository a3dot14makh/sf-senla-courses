({
    doInit: function (component, event, helper) {
        helper.validation(component);
    },

    displayData: function (component, event, helper) {
        helper.fetchTourists(component);
    },

    handleAddTripClick: function (component) {
        component.set("v.showModals", true);
    },

    handleCancelClick: function (component) {
        component.set("v.showModals", false);
    },

    handleSaveClick: function (component, event, helper) {
        helper.addToTrip(component);
    },

    handleRowSelection: function (component, event, helper) {
        let selectedTourists = [];
        selectedTourists = component.find("suitableTourists").getSelectedRows();
        if (selectedTourists.length > 0) {
            component.set("v.showButtonAddToTrip", true);
        } else {
            component.set("v.showButtonAddToTrip", false);
        }
    }
});
