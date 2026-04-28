public with sharing class CTPersonTriggerHandler {
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

    public static void beforeUpdate(List<Person__c> newPersons, Map<Id, Person__c> oldPersonMap){
        for (Person__c person: newPersons) {

            // If the Health_Status__c has changed, update the Status_Update_Date__c to the current date
            if(person.Health_Status__c != oldPersonMap.get(person.Id).Health_Status__c) {
                person.Status_Update_Date__c = Date.today();
            }
        }
    }

    public static void afterUpdate(List<Person__c> newPersons, Map<Id, Person__c> oldPersonMap){
        
        Set<Id> statusChanged = new Set<Id>();
        Set<Id> redStatus = new Set<Id>();

        for (Person__c person: newPersons) {

            // If the Health_Status__c has changed, update the person's helth status to the relevent status
            if(person.Health_Status__c != oldPersonMap.get(person.Id).Health_Status__c) {
                statusChanged.add(person.Id);
            }
            
            if(person.Health_Status__c == 'Red' && oldPersonMap.get(person.Id).Health_Status__c != 'Red') {
                redStatus.add(person.Id);
            }
        }

        Set<Id> orangeStatus = new Set<Id>();
        Set<Id> yellowStatus = new Set<Id>();
        Set<Id> alreadyProcessed = new Set<Id>();

        if(!redStatus.isEmpty()) {

            alreadyProcessed.addAll(redStatus);

            // Prepare to update the health status of the cohabitants
            orangeStatus.addAll(CTPersonController.getCohabitants(redStatus, alreadyProcessed));

            // Prepare to update the health status of the primary contacts
            Set<Id> primaryContacts = CTPersonController.getPrimaryContacts(redStatus, alreadyProcessed);
            orangeStatus.addAll(primaryContacts);

            // Prepare to update the health status of the neighbours
            yellowStatus.addAll(CTPersonController.getNeighbours(redStatus, alreadyProcessed));

            // Prepare to update the health status of the secondary contacts
            yellowStatus.addAll(CTPersonController.getSecondaryContacts(primaryContacts, alreadyProcessed));
        }

        List<Person__c> personsToUpdate = new List<Person__c>();

        personsToUpdate.addAll(buildPersonWithStatus(orangeStatus, 'Orange'));
        personsToUpdate.addAll(buildPersonWithStatus(yellowStatus, 'Yellow'));


        if (!personsToUpdate.isEmpty()) {
            update personsToUpdate;
        }
    }

    // Helper to build person records
    private static List<Person__c> buildPersonWithStatus(Set<Id> personIds, String status) {
        List<Person__c> personsToUpdate = new List<Person__c>();

        for (Id personId : personIds) {
            personsToUpdate.add(
                new Person__c(
                    Id = personId,
                    Health_Status__c = status
                )
            );
        }
        return personsToUpdate;
    }
}