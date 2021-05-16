trigger FlightTrigger on Flight__c(after insert) {
    if (!FlightTriggerHandler.wasExecuted) {
        FlightTriggerHandler.wasExecuted = true;

        switch on Trigger.operationType {
            when AFTER_INSERT {
                FlightTriggerHandler.onAfterInsert(Trigger.newMap);
            }
        }
    }
}
