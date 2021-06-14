({
    itemSelected: function (component, event, helper) {
        let tourists = component.get("{!v.tourists}");
        component.set("v.selectedTourist", tourists[0]);
        component.set("v.showDropDownLlist", false);
        component.set("v.showSelectedTouristCard", true);
    },

    handleKeyUp: function (component, event) {
        let isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
            let queryTerm = component.find("enter-search").get("v.value");

            let action = component.get("c.fetchTouristsByName");
            action.setParam("name", queryTerm);

            action.setCallback(this, function (responseData) {
                let state = responseData.getState();
                if (state === "SUCCESS") {
                    component.set("v.showDropDownLlist", true);
                    component.set("v.tourists", responseData.getReturnValue());
                } else if (state === "ERROR") {
                    let errors = response.getError();
                    console.log("Error message: " + errors[0].message);
                } else {
                    console.log("Unknown error");
                }
            });

            $A.enqueueAction(action);
        }
    },

    getTrip: function (component, event, helper) {
        let action = component.get("c.fetchTrip");

        action.setParam("tourist", component.get("v.selectedTourist"));

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

    handleSelectTab: function (cmp, event, helper) {
        
    }
});
