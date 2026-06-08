/**
 * This apex class controls the CTHealthHeader Aura Component.
 */
public with sharing class CTHealthHeaderController {
    
    @AuraEnabled
    public static Map<String, Integer> getPersonHealthStatusCounts(){

        Map<String, Integer> healthStatusCountMap = new Map<String, Integer>();

        try {
            AggregateResult[] ar = [SELECT COUNT(Id) Counts, Health_Status__c FROM Person__c GROUP BY Health_Status__c];

            for(AggregateResult e: ar) {
                healthStatusCountMap.put(String.valueOf(e.get('Health_Status__c')), Integer.valueOf(e.get('Counts')));
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return healthStatusCountMap;
    }

    @AuraEnabled
    public static Map<String, Integer> getLocationHealthStatusCounts(){
        Map<String, Integer> healthStatusCountMap = new Map<String, Integer>();

        try {
            AggregateResult[] ar = [SELECT COUNT(Id) Counts, Status__c FROM Location__c GROUP BY Status__c];

            for(AggregateResult e: ar) {
                healthStatusCountMap.put(String.valueOf(e.get('Status__c')), Integer.valueOf(e.get('Counts')));
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return healthStatusCountMap;
    }
}