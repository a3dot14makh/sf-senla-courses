trigger TouristTrigger on Tourist__c(after insert, after update) {
    if (!TouristTriggerHandler.wasExecuted) {
        TouristTriggerHandler.wasExecuted = true;

        switch on Trigger.operationType {
            when AFTER_INSERT {
                TouristTriggerHandler.onAfterInsert(Trigger.oldMap, Trigger.newMap);
            }
            when AFTER_UPDATE {
                TouristTriggerHandler.onAfterUpdate(Trigger.oldMap, Trigger.newMap);
            }
        }
    }
}
