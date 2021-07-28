({
    getCurrentTemperature: function (component) {
        let action = component.get("c.getCurrentTemperature");

        action.setParam("spacePointId", component.get("v.trip.Departure_Space_Point__c"));

        action.setCallback(this, function (responseData) {
            let state = responseData.getState();
            if (state === "SUCCESS") {
                component.set("v.currentTemperature", responseData.getReturnValue().Average_Temperature__c);
            } else if (state === "ERROR") {
                let errors = responseData.getError();
                console.log("Error message: " + errors[0].message);
            } else {
                console.log("Unknown error");
            }
        });

        $A.enqueueAction(action);
    },

    createFlight: function (component) {
        let action = component.get("c.createFlights");
        let touristId = component.get("v.touristId");

        action.setParams({
            tripId: component.get("v.selectedTripId"),
            touristsId: touristId
        });

        action.setCallback(this, function (responseData) {
            let state = responseData.getState();

            if (state === "SUCCESS") {
                let RefreshSearchResultsEvent = component.getEvent("RefreshSuitableTrips");
                RefreshSearchResultsEvent.fire();

                this.schowToast(
                    "success",
                    "Success",
                    "Thank you for your application, which we have accepted."
                );
            } else if (state === "ERROR") {
                let errors = response.getError();
                console.log("Error message: " + errors[0].message);
            } else {
                console.log("Unknown error");
            }
        });

        $A.enqueueAction(action);
    },

    schowToast: function (type, title, message) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: "pester",
            duration: "3000",
            type: type,
            title: title,
            message: message
        });
        toastEvent.fire();
    }
});
