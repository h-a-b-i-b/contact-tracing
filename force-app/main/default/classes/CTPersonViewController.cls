/**
 * Controller class of CT Person View
 */
public with sharing class CTPersonViewController {
    
    /**
     * Update health status to red
     */
    @AuraEnabled
    public static void updatePersonStatusToRed(String recordId){
        CTPersonController.updateStatusToRed(recordId);
    }
    
}