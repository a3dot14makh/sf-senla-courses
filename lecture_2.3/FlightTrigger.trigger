trigger FlightTrigger on Flight__c(before insert) {
  if (!FlightTriggerHandler.wasExecuted) {
    FlightTriggerHandler.wasExecuted = true;
    switch on Trigger.operationType {
      when BEFORE_INSERT {
        FlightTriggerHandler.onBeforeInsert(Trigger.new);
      }
    }
  }
}