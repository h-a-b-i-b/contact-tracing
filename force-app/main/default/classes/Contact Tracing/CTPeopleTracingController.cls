public with sharing class CTPeopleTracingController {
    
    /**
     * This method retrieves a list of People_Tracing__c records associated with a specific Person__c record, identified by the provided personId. The records are ordered by the Contact_Date__c field in descending order.
     * @param personId The unique identifier (Id) of the Person__c record for which to retrieve the associated People_Tracing__c records.
     * @return A list of People_Tracing__c records that are associated with the specified Person__c record, ordered by Contact_Date__c in descending order.
     */
    public static List<People_Tracing__c> getTraces(String personId){
        return [
            SELECT Id, Name, Contact_Date__c, Contact_Type__c, Person_1__c, Person_2__c, 
                Person_1__r.Health_Status__c, Person_1__r.Token__c, 
                Person_2__r.Health_Status__c, Person_2__r.Token__c, Person_2__r.Name 
            FROM People_Tracing__c 
            WHERE (Person_1__c = :personId OR Person_2__c = :personId)
            AND Contact_Date__c = LAST_N_DAYS:30
            ORDER BY Contact_Date__c DESC
        ];
    }

    /**
     * This method checks for duplicate People_Tracing__c records based on the Person_1__c and Person_2__c fields. It takes a list of People_Tracing__c records as input and returns a list of records that are considered duplicates.
     * A record is considered a duplicate if there is an existing People_Tracing__c record in the database with the same Person_1__c and Person_2__c values.
     * @param newPeopleTraces A list of People_Tracing__c records to check for duplicates.
     * @return A list of People_Tracing__c records that are identified as duplicates based on the Person_1__c and Person_2__c fields.
     */
    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> newPeopleTraces){

        if(newPeopleTraces == null || newPeopleTraces.isEmpty()) return new List<People_Tracing__c>();

        Set<Id> personIds = new Set<Id>();

        for (People_Tracing__c pt : newPeopleTraces) {
            personIds.add(pt.Person_1__c);
            personIds.add(pt.Person_2__c);
        }

        List<People_Tracing__c> existingPeopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c WHERE Person_1__c IN :personIds OR Person_2__c IN :personIds];

        Map<Id, Set<Id>> existingPeopleTracesMap = new Map<Id, Set<Id>>();

        for (People_Tracing__c pt : existingPeopleTraces) {
            if (!existingPeopleTracesMap.containsKey(pt.Person_1__c)) {
                existingPeopleTracesMap.put(pt.Person_1__c, new Set<Id>());
            }
            existingPeopleTracesMap.get(pt.Person_1__c).add(pt.Person_2__c);

            if (!existingPeopleTracesMap.containsKey(pt.Person_2__c)) {
                existingPeopleTracesMap.put(pt.Person_2__c, new Set<Id>());
            }
            existingPeopleTracesMap.get(pt.Person_2__c).add(pt.Person_1__c);
        }

        List<People_Tracing__c> duplicates = new List<People_Tracing__c>();

        if(!existingPeopleTraces.isEmpty()) {
            for (People_Tracing__c pt : newPeopleTraces) {
                Boolean isExisted = existingPeopleTracesMap.containsKey(pt.Person_1__c) && existingPeopleTracesMap.get(pt.Person_1__c).contains(pt.Person_2__c);
                if (pt.Person_1__c == pt.Person_2__c || isExisted){
                    duplicates.add(pt);
                }
            }
        }
        return duplicates;
    }
}