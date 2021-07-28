({
    doInit: function (component, event, helper) {
        const urlParams = new URLSearchParams(window.location.search);
        const id = urlParams.get("id");
        component.set("v.touristId", id);
        const name = urlParams.get("name");
        const title = "Hello, " + name;
        const message = $A.get("$Label.c.ToastInfoMsg_SuitableTourists");

        helper.getSuitableTrips(component);
        helper.schowToast("info", title, message);

        const url = $A.get("$Resource.TripTileImage");
        component.set("v.backgroundImageURL", url);
    },

    getSuitableTrips: function (component, event, helper) {
        helper.getSuitableTrips(component);
    },

    refreshSuitableTrips: function (component, event, helper) {
        helper.getSuitableTrips(component);
        component.set("v.showTripDetails", false);
    },

    onTripClick: function (component, event, helper) {
        let tripId = event.getParam("tripId");
        component.set("v.selectedTripId", tripId);
        component.set("v.showTripDetails", true);
    }
});
