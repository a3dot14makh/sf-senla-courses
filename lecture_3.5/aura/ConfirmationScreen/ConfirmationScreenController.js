({
    handleCancelClick: function (component, event, helper) {
        helper.createEvent(component, false);
    },

    handleSaveClick: function (component, event, helper) {
        helper.createEvent(component, true);
    }
})