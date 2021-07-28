({
    getSuitableTrips: function (component) {
        let action = component.get("c.fetchTrips");

        action.setParam("touristId", component.get("v.touristId"));

        action.setCallback(this, function (responseData) {
            let state = responseData.getState();
            if (state === "SUCCESS") {
                component.set("v.trips", responseData.getReturnValue());
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
            mode: "sticky",
            type: type,
            title: title,
            message: message
        });
        toastEvent.fire();
    }
});
