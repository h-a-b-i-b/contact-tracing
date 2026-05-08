/**
 * Handles the Location Trigger and it's operations
 */
public with sharing class CTLocationTriggerHandler {

    private final static String GREEN_STATUS = 'Green';

    /**
     * Handles before insert events and operations
     * @param List<Location__c> location records
     */
    public static void handleBeforeInsert (List<Location__c> locations) {

        // Mark the new location records as 'Green'
        for(Location__c location: locations) {
            if(location.Status__c == null || location.Status__c != GREEN_STATUS) {
                location.Status__c = GREEN_STATUS;
            }
        }
    }

    /**
     * Handles before update events and operations
     * @param List<Location__c> new location records
     * @param Map<Id, Location__c> old location map
     */
    public static void handleBeforeUpdate (List<Location__c> newLocations, Map<Id, Location__c> oldLocationsMap) {

        // Mark the new location records as 'Green'
        for(Location__c location: newLocations) {

            if(location.Status__c != oldLocationsMap.get(location.Id).Status__c) {
                location.Status_Update_Date__c = System.today();
            }
        }
    }
}