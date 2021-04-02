trigger TouristTrigger on Tourist__c(after insert, after update) {
  if (!TouristTriggerHandler.wasExecuted) {
    TouristTriggerHandler.wasExecuted = true;
    switch on Trigger.operationType {
      when BEFORE_INSERT {
        TouristTriggerHandler.onBeforeInsert(Trigger.new);
      }
      when AFTER_INSERT {
        TouristService.markDuplicates(Trigger.newMap.keySet());
      }
      when AFTER_UPDATE {
        TouristTriggerHandler.onAfterUpdate(Trigger.oldMap, Trigger.newMap);
      }
    }
  }
}
