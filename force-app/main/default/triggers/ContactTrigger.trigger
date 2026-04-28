trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {
    // Call the handler calss
    ContactTriggerHandler.handleTrigger(Trigger.newMap, Trigger.oldMap, Trigger.operationType);
}