/**
 * This trigger is for Location_Tracing__c sObject.
 * @param before insert
 */
trigger CTLocationTracingTrigger on Location_Tracing__c (before insert) {

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CTLocationTracingTriggerHandler.handleBeforeInsert(Trigger.new);
        }
    }
}