public with sharing class CTLocationController {

    /**
     * This method retrieves the most recent 100 Location__c records ordered by their Status_Update_Date__c in descending order.
     * @return A list of Location__c records.
     */
    public static List<Location__c> getRecentLocations() {
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

    /**
     * This method searches for Location__c records based on a provided search term. It performs a case-insensitive search on the Name, Address__c, and Pincode__c fields of the Location__c object, using a LIKE operator with wildcards. The results are ordered by Status_Update_Date__c in descending order.
     * @param searchTerm The term to search for in the Name, Address__c, and Pincode__c fields of Location__c records.
     * @return A list of Location__c records that match the search criteria.
     */
    public static List<Location__c> searchLocations (String searchTerm) {
        if (String.isBlank(searchTerm)) {
            return new List<Location__c>();
        }

        searchTerm = String.escapeSingleQuotes(searchTerm.trim()) + '%';

        return [
            SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
            FROM Location__c 
            WHERE Name LIKE :searchTerm
            OR Address__c LIKE :searchTerm
            OR Pincode__c LIKE :searchTerm
            ORDER BY Status_Update_Date__c DESC NULLS LAST
        ];
    }

    /**
     * This method retrieves a Location__c record by its unique identifier (Id). It performs a SOQL query to find the record with the specified Id and returns it. If no record is found, it will return null.
     * @param locationId The unique identifier (Id) of the Location__c record to be retrieved.
     * @return A Location__c record that matches the provided Id, or null if no record is found.
     */
    public static Location__c getLocationById(String locationId) {
        List<Location__c> locations = [
            SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
            FROM Location__c 
            WHERE Id = :locationId
            LIMIT 1
        ];

        if (!locations.isEmpty()) {
            return locations[0];
        }
        return null; 
    }

    /**
     * This method retrieves a count of Location__c records grouped by their Status__c field.
     * @return A Map<String, Integer> where the key is the Status__c value and the value is the count of Location__c records with that status.
     */
    public static Map<String, Integer> getStstusCount(){

        Map<String, Integer> statusCountMap = new Map<String, Integer>();

        for (AggregateResult ar : [SELECT Status__c, Count(Id) locationCount FROM Location__c GROUP BY Status__c]) {
            String status = String.valueOf(ar.get('Status__c'));
            Integer count = Integer.valueOf(ar.get('locationCount'));
            statusCountMap.put(status, count);
        }
        return statusCountMap;
    }
}