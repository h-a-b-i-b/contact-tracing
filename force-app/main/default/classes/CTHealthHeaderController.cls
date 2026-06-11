/**
 * This apex class controls the CTHealthHeader Aura Component.
 */
public with sharing class CTHealthHeaderController {
    
    /**
     * Get person health status counts.
     * @return Map<String, Integer>
     */
    @AuraEnabled
    public static Map<String, Integer> getPersonHealthStatusCounts(){
        return CTPersonController.getHealthStatusCount();
    }

    /**
     * Get location health status counts.
     * @return Map<String, Integer>
     */
    @AuraEnabled
    public static Map<String, Integer> getLocationHealthStatusCounts(){
        return CTLocationController.getHealthStatusCount();
    }
}