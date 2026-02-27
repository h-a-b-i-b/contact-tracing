public with sharing class CTPersonTriggerHandler {

    /**
     * This method is executed before inserting new Person__c records. It ensures that the Health_Status__c field is set to 'Green' by default if it is not provided, sets the Status_Update_Date__c to the current date if it is not already set, and generates a unique Token__c using the CTPersonController if it is not provided.
     * @param newPersons A list of Person__c records that are being inserted.
     */
    public static void beforeInsert(List<Person__c> newPersons){
        for (Person__c person : newPersons) {

            // If the Health_Status__c is not set to 'Green', set it to 'Green' by default
            if(person.Health_Status__c != 'Green') {
                person.Health_Status__c = 'Green';
            }

            // Set the Status_Update_Date__c to the current date and time
            if(person.Status_Update_Date__c == null) {
                person.Status_Update_Date__c = Date.today();
            }

            // If the Token__c is not provided, generate a new token using the CTPersonController
            if (person.Token__c == null) {
                person.Token__c = CTPersonController.getToken(person.Mobile__c);
            }
        }
    }

    /**
     * This method is executed before updating existing Person__c records. It checks if the Health_Status__c field has changed compared to the old values, and if it has, it updates the Status_Update_Date__c field to the current date.
     * @param newPersons A list of Person__c records that are being updated.
     * @param oldPersonMap A map of the old Person__c records, keyed by their Ids, which allows for comparison with the new records.
     */
    public static void beforeUpdate(List<Person__c> newPersons, Map<Id, Person__c> oldPersonMap){
        for (Person__c person: newPersons) {

            // If the Health_Status__c has changed, update the Status_Update_Date__c to the current date
            if(person.Health_Status__c != oldPersonMap.get(person.Id).Health_Status__c) {
                person.Status_Update_Date__c = Date.today();
            }
        }
    }
}