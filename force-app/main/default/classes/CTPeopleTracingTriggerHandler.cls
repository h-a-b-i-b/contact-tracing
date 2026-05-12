/**
 * This handler class, handles People Tracing object trigger
 */
public with sharing class CTPeopleTracingTriggerHandler {
    
    /**
     * Handles before insert operations
     * @param List<People_Tracing__c>
     */
    public static void handleBeforeInsert(List<People_Tracing__c> newRecords) {
        for (People_Tracing__c trace : CTPeopleTracingController.checkDuplicates(newRecords)) {
            trace.addError('Duplicate record found!');
        }
    }
}