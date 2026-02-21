public with sharing class CTLocationTracingController {

    /**
     * This method retrieves a list of Location_Tracing__c records associated with a specific Location__c record, identified by the provided locationId. The records are ordered by the Visit_Date__c field in descending order, with null values appearing last.
     * @param locationId The unique identifier (Id) of the Location__c record for which to retrieve the associated Location_Tracing__c records.
     * @return A list of Location_Tracing__c records that are associated with the specified Location__c record, ordered by Visit_Date__c in descending order.
     */
    public static List<Location_Tracing__c> getVisitors(String locationId){
        return [SELECT Id, Person__c, Location__c, Visit_Date__c, Person__r.Health_Status__c, Person__r.Token__c FROM Location_Tracing__c WHERE Location__c = :locationId ORDER BY Visit_Date__c  DESC];
    }

    /**
     * This method retrieves a list of Location_Tracing__c records associated with a set of Person__c records, identified by the provided personIds set. The records are filtered to include only those with a Visit_Date__c within the last 10 days and are ordered by the Visit_Date__c field in descending order, with null values appearing last.
     * @param personIds A set of unique identifiers (Ids) for the Person__c records for which to retrieve the associated Location_Tracing__c records.
     * @return A list of Location_Tracing__c records that are associated with the specified Person__c records, filtered by Visit_Date__c within the last 10 days and ordered by Visit_Date__c in descending order.
     */
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds){
        return [SELECT Id, Person__c, Location__c FROM Location_Tracing__c WHERE Person__c IN :personIds AND Visit_Date__c = LAST_N_DAYS:10];
    }

    /**
     * This method retrieves a list of Location_Tracing__c records associated with a set of Location__c records, identified by the provided locationIds set. The records are filtered to include only those with a Visit_Date__c within the last 10 days and are ordered by the Visit_Date__c field in descending order, with null values appearing last.
     * @param locationIds A set of unique identifiers (Ids) for the Location__c records for which to retrieve the associated Location_Tracing__c records.
     * @return A list of Location_Tracing__c records that are associated with the specified Location__c records, filtered by Visit_Date__c within the last 10 days and ordered by Visit_Date__c in descending order.
     */
    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds){
        return [SELECT Id, Name, Person__c, Location__c, Visit_Date__c FROM Location_Tracing__c WHERE Location__c IN :locationIds AND Person__r.Health_Status__c = 'Green' AND Visit_Date__c = LAST_N_DAYS:10];
    }
}