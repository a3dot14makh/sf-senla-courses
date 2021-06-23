({
    validation: function (component) {
        let today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        if (
            component.get("v.trip").Number_Of_Empty_Seats__c > 0 &&
            component.get("v.trip").Start_Date__c > today
        ) {
            component.set("v.showDataTable", true);
        }
    },

    fetchTourists: function (component) {
        let action = component.get("c.getSuitableTourists");
        component.set("v.columns", [
            {
                label: "Name",
                fieldName: "link",
                type: "url",
                typeAttributes: { label: { fieldName: "Name" }, tooltip: { fieldName: "name" } }
            },
            { label: "Email", fieldName: "Email__c", type: "email" },
            { label: "Gender", fieldName: "Gender__c", type: "picklist" }
        ]);

        action.setParam("trip", component.get("v.trip"));

        action.setCallback(this, function (responseData) {
            let state = responseData.getState();
            if (state === "SUCCESS") {
                let responseValue = responseData.getReturnValue();
                responseValue.forEach(function (value) {
                    value.link = "/" + value.Id;
                });
                component.set("v.tourists", responseValue);
                component.set("v.showSpinner", false);
            } else if (state === "ERROR") {
                let errors = response.getError();
                console.log("Error message: " + errors[0].message);
            } else {
                console.log("Unknown error");
            }
        });

        $A.enqueueAction(action);
    },

    addToTrip: function (component) {
        component.set("v.showSpinner", true);

        let action = component.get("c.createFlights");
        let selectedTourists = component.find("suitableTourists").getSelectedRows();
        let ids = selectedTourists.map((tourist) => tourist.Id);

        action.setParams({
            tripId: component.get("v.recordId"),
            touristsId: ids
        });

        action.setCallback(this, function (responseData) {
            let state = responseData.getState();

            if (state === "SUCCESS") {
                //Refresh table
                let tourists = component.get("v.tourists");
                tourists = tourists.filter(function (el) {
                    return selectedTourists.indexOf(el) < 0;
                });
                component.set("v.tourists", tourists);
                $A.get("e.force:refreshView").fire();

                component.set("v.showSpinner", false);

                this.schowToast(
                    "success",
                    $A.get("$Label.c.ToastTitle_Success"),
                    $A.get("$Label.c.ToastMessage_RecordsSaved")
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
            type: type,
            duration: " 1000",
            title: title,
            message: message
        });
        toastEvent.fire();
    }
});
