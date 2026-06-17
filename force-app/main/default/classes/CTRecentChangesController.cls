/**
 * Manage or tracks recents health changes.
 */
public with sharing class CTRecentChangesController {
    /**
     * Get the recent health health changes of peoples, sorted by status update date.
     * @AuraEnabled
     * @return List of persons.
     */
    @AuraEnabled
    public static List<Person__c> getRecentPersonHealthChanges() {
        return CTPersonController.getRecentHealthChanges();
    }

    /**
     * Get the recent health health changes of locations, sorted by status update date.
     * @AuraEnabled
     * @return List of locations.
     */
    @AuraEnabled
    public static List<Location__c> getRecentLocationHealthChanges(){
        return CTLocationController.getRecentLocations();
    }

    /**
     * Search peoples with a search term.
     * @AuraEnabled
     * @param String
     * @return List of persons.
     */
    @AuraEnabled
    public static List<Person__c> searchPeople(String searchTerm){
        return CTPersonController.searchPeople(searchTerm);
    }

    /**
     * Search locations with a search term.
     * @AuraEnabled
     * @param String
     * @return List of locations.
     */
    @AuraEnabled
    public static List<Location__c> searchLocation(String searchTerm){
        return CTLocationController.searchLocations(searchTerm);
    }
}