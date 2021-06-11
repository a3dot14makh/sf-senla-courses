({
    validation: function (component, event) {
        //Number_Employed_Seats__c - Roll-Up Summary field: COUNT Flight
        let numEmptySeats =
            component.get("v.trip").Seats__c - component.get("v.trip").Number_Employed_Seats__c;
        component.set("v.maxRowSelection", numEmptySeats);

        let today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        if (numEmptySeats > 0 && component.get("v.trip").Start_Date__c > today) {
            component.set("v.showDataTable", true);
        }
    },

    fetchTourists: function (component, event) {
        let action = component.get("c.getSuitableTourists");
        component.set("v.columns", [
            {
                label: "Name",
                fieldName: "link",
                type: "url",
                typeAttributes: { label: { fieldName: "name" }, tooltip: { fieldName: "name" } }
            },
            { label: "Email", fieldName: "email", type: "email" },
            { label: "Gender", fieldName: "gender", type: "picklist" }
        ]);

        action.setParam("trip", component.get("v.trip"));

        action.setCallback(this, function (responseData) {
            let state = responseData.getState();
            if (state === "SUCCESS") {
                component.set("v.tourists", responseData.getReturnValue());
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

    addToTrip: function (component, event) {
        component.set("v.showSpinner", true);
        let updateTable = component.get("c.displayData");

        let action = component.get("c.createFlights");
        let selectedTourists = [];
        selectedTourists = component.find("suitableTourists").getSelectedRows();

        let ids = [];
        for (let i = 0; i < selectedTourists.length; i++) {
            ids.push(selectedTourists[i].id);
        }

        action.setParams({
            tripId: component.get("v.recordId"),
            touristsId: ids
        });

        action.setCallback(this, function (responseData) {
            let state = responseData.getState();

            if (state === "SUCCESS") {
                component.set("v.showModals", false);
                $A.get("e.force:refreshView").fire();
                component.set("v.showSpinner", false);

                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "pester",
                    type: "success",
                    duration: " 1000",
                    title: $A.get("$Label.c.ToastTitle_Success"),
                    message: $A.get("$Label.c.ToastMessage_RecordsSaved")
                });
                toastEvent.fire();
            } else if (state === "ERROR") {
                let errors = response.getError();
                console.log("Error message: " + errors[0].message);
            } else {
                console.log("Unknown error");
            }
        });

        $A.enqueueAction(action);
        $A.enqueueAction(updateTable);
    }
});
