/**
 * Trigger on Location__c object
 * @param before insert
 * @param before update
 */
trigger CTLocationTrigger on Location__c (before insert, before update, after update) {

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CTLocationTriggerHandler.handleBeforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            CTLocationTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
        when AFTER_UPDATE {
            CTLocationTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}