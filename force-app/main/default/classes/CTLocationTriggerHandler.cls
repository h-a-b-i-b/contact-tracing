/**
 * Handles the Location Trigger and it's operations
 */
public with sharing class CTLocationTriggerHandler {

    private final static String GREEN_STATUS = 'Green';
    private final static String RED_STATUS = 'Red';
    private final static String YELLOW_STATUS = 'Yellow';

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

    /**
     * Handles after update events and operations
     * @param List<Location__c> new location records
     * @param Map<Id, Location__c> old location map
     */
    public static void handleAfterUpdate (List<Location__c> newLocations, Map<Id, Location__c> oldLocationsMap) {

        // Step 1: Determine the status change to 'Red' and store the location Ids

        Set<Id> ststusChanged = new Set<Id>();
        
        for (Location__c loc : newLocations) {

            if(loc.Status__c == RED_STATUS && oldLocationsMap.get(loc.Id).Status__c != RED_STATUS) {
                ststusChanged.add(loc.Id);
            }
        }

        // Step 2: Query the location trace records, visited 
        // in last 10 days with 'Green' status
        List<Location_Tracing__c> locationTraces = new List<Location_Tracing__c>();

        if (!ststusChanged.isEmpty()) {
            locationTraces = CTLocationTracingController.getLocationsByLocationIds(ststusChanged);
        }

        // Step 3: Get the person Ids
        Map<Id, Person__c> personsToUpdate = new Map<Id, Person__c>();

        for (Location_Tracing__c trace : locationTraces) {
            Id pid = trace.Person__c;

            if(personsToUpdate.containsKey(pid)) continue;

            Person__c newPerson = new Person__c (
                Id = pid,
                Health_Status__c = YELLOW_STATUS
            );
            personsToUpdate.put(pid, newPerson);
        }

        if(!personsToUpdate.isEmpty()) {
            Database.update(personsToUpdate.values(), AccessLevel.SYSTEM_MODE);
        }
    }
}