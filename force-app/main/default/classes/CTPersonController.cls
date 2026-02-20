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
}