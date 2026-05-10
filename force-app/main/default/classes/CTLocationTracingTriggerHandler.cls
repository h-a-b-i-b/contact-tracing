/**
 * This handles the CTLocationTracingTrigger logic.
 */
public with sharing class CTLocationTracingTriggerHandler {

    /**
     * This handles the before insert logic.
     * @param List<Location_Tracing__c> new triggered records.
     */
    public static void handleBeforeInsert (List<Location_Tracing__c> newRecords) {

        List<Location_Tracing__c> duplicates = CTLocationTracingController.checkDuplicates(newRecords);

        for (Location_Tracing__c trace : duplicates) {
            trace.addError('Duplicate record found!');
        }
    }
}