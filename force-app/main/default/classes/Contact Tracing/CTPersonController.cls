public with sharing class CTPersonController {
    
    /**
     * This method generates a unique token for a given mobile number using MD5 hashing and Base64 encoding.
     * @param mobileNo The mobile number for which the token is to be generated.
     * @return A unique token as a String.
     */
    public static String getToken(String mobileNo){
        return EncodingUtil.base64Encode(Crypto.generateDigest('MD5', Blob.valueOf(mobileNo)));
    }

    /**
     * This method retrieves the most recent health changes for Person__c records. It queries the Person__c object, ordering the results by the Status_Update_Date__c field in descending order, and limits the results to the top 100 records.
     * @return A list of Person__c records representing the most recent health changes.
     */
    public static List<Person__c> getRecentHealthChanges(){
        return [
            SELECT Id, Name, OwnerId, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c
            FROM Person__c
            ORDER BY Status_Update_Date__c DESC NULLS LAST
            LIMIT 100
        ];
    }

    /**
     * This method searches for Person__c records based on a provided search term. It performs a case-insensitive search on the Name field of the Person__c object, using a LIKE operator with wildcards. The results are ordered by Name.
     * @param searchTerm The term to search for in the Name field of Person__c records.
     * @return A list of Person__c records that match the search criteria.
     */
    public static List<Person__c> searchPeople(String searchTerm){
        if(String.isBlank(searchTerm)){
            return new List<Person__c>();
        }
    
        searchTerm = String.escapeSingleQuotes(searchTerm.trim()) + '%';
    
        return [
            SELECT Id, Name, OwnerId, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c
            FROM Person__c
            WHERE Name LIKE :searchTerm
            OR Mobile__c LIKE :searchTerm
            OR Token__c LIKE :searchTerm
            ORDER BY Status_Update_Date__c DESC NULLS LAST
        ];
    }

    /**
     * This method retrieves a Person__c record by its unique identifier (Id). It performs a SOQL query to find the record with the specified Id and returns it. If no record is found, it will return null.
     * @param personId The unique identifier (Id) of the Person__c record to be retrieved.
     * @return A Person__c record that matches the provided Id, or null if no record is found.
     */
    public static Person__c getPersonById(String personId){
        List<Person__c> persons = [
            SELECT Id, Name, OwnerId, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c
            FROM Person__c
            WHERE Id = :personId
            LIMIT 1
        ];

        if (!persons.isEmpty()) {
            return persons[0];
        }
        return null;
    }

    /**
     * This method retrieves the count of Person__c records grouped by their Health_Status__c field.
     * @return A Map containing health statuses as keys and their corresponding record counts as values.
     */
    public static Map<String, Integer> getHealthStatusCount(){

        Map<String, Integer> healthStatusCountMap = new Map<String, Integer>();

        for(AggregateResult result: [SELECT Count(Id) numberOfPerson, Health_Status__c FROM Person__c GROUP BY Health_Status__c]){

            String healthStatus = String.valueOf(result.get('Health_Status__c'));
            Integer count = Integer.valueOf(result.get('numberOfPerson'));
            
            healthStatusCountMap.put(healthStatus, count);
        }
        return healthStatusCountMap;
    }

    /**
     * Retrieves the co-habitants of a set of person IDs.
     * @param personIds The set of person IDs to retrieve co-habitants for.
     * @return A set of IDs of co-habitants.
     */
    public static Set<Id> getCohabitants(Set<Id> personIds, Set<Id> alreadyProcessed){

        List<String> helthStatuses = new List<String>{'Green', 'Yellow'};
        Set<Id> cohabitants = new Set<Id>();

        for(People_Tracing__c trace: [
            SELECT Id, Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds)
            AND Contact_Type__c = 'Cohabitant'
            AND (Person_1__r.Health_Status__c IN :helthStatuses OR Person_2__r.Health_Status__c IN :helthStatuses)
        ]){
            if(!alreadyProcessed.contains(trace.Person_1__c)){
                cohabitants.add(trace.Person_1__c);
                alreadyProcessed.add(trace.Person_1__c);
            }
            if(!alreadyProcessed.contains(trace.Person_2__c)){
                cohabitants.add(trace.Person_2__c);
                alreadyProcessed.add(trace.Person_2__c);
            } 
        }
        return cohabitants;
    }

    /**
     * Retrieves the neighbours of a set of person IDs.
     * @param personIds The set of person IDs to retrieve neighbours for.
     * @return A set of IDs of neighbours.
     */
    public static Set<Id> getNeighbours(Set<Id> personIds, Set<Id> alreadyProcessed){

        Set<Id> neighbours = new Set<Id>();

        for(People_Tracing__c trace: [
            SELECT Id, Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds)
            AND Contact_Type__c = 'Neighbour'
            AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')
        ]){
            if(!alreadyProcessed.contains(trace.Person_1__c)){
                neighbours.add(trace.Person_1__c);
                alreadyProcessed.add(trace.Person_1__c);
            }

            if(!alreadyProcessed.contains(trace.Person_2__c)){
                neighbours.add(trace.Person_2__c);
                alreadyProcessed.add(trace.Person_2__c);
            } 
        }
        return neighbours;
    }

    /**
     * Retrieves the primary contacts of a set of person IDs.
     * @param personIds The set of person IDs to retrieve primary contacts for.
     * @return A set of IDs of primary contacts.
     */
    public static Set<Id> getPrimaryContacts(Set<Id> personIds, Set<Id> alreadyProcessed){

        List<String> helthStatuses = new List<String>{'Green', 'Yellow'};
        Set<Id> primaryContacts = new Set<Id>();

        for(People_Tracing__c trace: [
            SELECT Id, Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds)
            AND Contact_Type__c = 'Other'
            AND Contact_Date__c = LAST_N_DAYS:10
            AND (Person_1__r.Health_Status__c IN :helthStatuses OR Person_2__r.Health_Status__c IN : helthStatuses)
        ]){
            if(!alreadyProcessed.contains(trace.Person_1__c)){
                primaryContacts.add(trace.Person_1__c);
                alreadyProcessed.add(trace.Person_1__c);
            }
            
            if(!alreadyProcessed.contains(trace.Person_2__c)){
                primaryContacts.add(trace.Person_2__c);
                alreadyProcessed.add(trace.Person_2__c);
            } 
        }
        return primaryContacts;
    }

    /**
     * Retrieves the secondary contacts of a set of primary contactc IDs.
     * @param primaryContactIds The set of primary contact IDs to retrieve secondary contacts for.
     * @return A set of IDs of secondary contacts.
     */
    public static Set<Id> getSecondaryContacts(Set<Id> primaryContactIds, Set<Id> alreadyProcessed){

        Set<Id> secondaryContacts = new Set<Id>();

        for(People_Tracing__c trace: [
            SELECT Id, Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE (Person_1__c IN :primaryContactIds OR Person_2__c IN :primaryContactIds)
            AND Contact_Type__c = 'Other'
            AND Contact_Date__c = LAST_N_DAYS:10
            AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')
        ]){
            if(!alreadyProcessed.contains(trace.Person_1__c)){
                secondaryContacts.add(trace.Person_1__c);
                alreadyProcessed.add(trace.Person_1__c);
            }
            if(!alreadyProcessed.contains(trace.Person_2__c)){  
                secondaryContacts.add(trace.Person_2__c);
                alreadyProcessed.add(trace.Person_2__c);
            } 
        }
        return secondaryContacts;
    }
}