({
    doInit: function (component, event, helper) {
        let today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set("v.today", today);
    },

    refreshTripData: function (component, event, helper) {
        component.find("tripData").reloadRecord();
    },

    renderMap: function (component, event, helper) {
        let trip = component.get("v.trip");
        component.set("v.mapMarkers", [
            {
                location: {
                    Latitude: trip.Departure_Space_Point__r.Latitude__c,
                    Longitude: trip.Departure_Space_Point__r.Longitude__c
                },
                title: trip.Departure_Space_Point__r.Name
            }
        ]);

        helper.getCurrentTemperature(component);
    },

    handleSubmitClick: function (component, event, helper) {
        component.set("v.showModals", true);
    },

    closeConfirmationScreen: function (component, event, helper) {
        let isAddTrip = event.getParam("hasAgreed");

        if (isAddTrip) {
            helper.createFlight(component);
        }
        component.set("v.showModals", false);
    }
});