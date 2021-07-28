({
    onTripClick: function (component, event, helper) {
        let TripSelectEvent = component.getEvent("TripTileClick");
        TripSelectEvent.setParams({
            tripId: component.get("v.trip.Id")
        });

        TripSelectEvent.fire();
    }
});
