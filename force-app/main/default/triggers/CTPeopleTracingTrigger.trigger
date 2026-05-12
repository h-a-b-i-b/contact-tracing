/**
 * This trigger handles People Tracing Object's events
 */
trigger CTPeopleTracingTrigger on People_Tracing__c (before insert) {

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CTPeopleTracingTriggerHandler.handleBeforeInsert(Trigger.new);
        }
    }
}