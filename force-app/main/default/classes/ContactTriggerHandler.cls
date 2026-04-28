public with sharing class ContactTriggerHandler {

    public static void handleTrigger(Map<Id, Contact> newContacts, Map<Id, Contact> oldContacts, System.TriggerOperation operationType) {
        System.debug('ContactTriggerHandler invoked with operation: ' + operationType);
        System.debug('New Contacts: ' + newContacts);
        System.debug('Old Contacts: ' + oldContacts);
        // Check the trigger context
        if(operationType == System.TriggerOperation.AFTER_INSERT) {
            handleAfterInsert(newContacts);
        } else if(operationType == System.TriggerOperation.AFTER_UPDATE) {
            handleAfterUpdate(newContacts, oldContacts);
        } else if(operationType == System.TriggerOperation.AFTER_DELETE) {
            handleAfterDelete(oldContacts);
        } else if(operationType == System.TriggerOperation.AFTER_UNDELETE) {
            handleAfterUndelete(newContacts);
        }
    }

    // private static void updateActiveContactCountOnAccount(Set<Id> accountIds) {
        
    // }

    private static void handleAfterInsert(Map<Id, Contact> newContacts) {
        // Logic for after insert
        Set<Id> accountIds = new Set<Id>();
        for(Contact con : newContacts.values()) {
            if(con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
        if(!accountIds.isEmpty()) {
            updateAccountWithContactCount(accountIds);
        }
    }

    private static void handleAfterUpdate(Map<Id, Contact> newContacts, Map<Id, Contact> oldContacts) {
        // Logic for after update
        Set<Id> accountIds = new Set<Id>();
        for(Contact con : newContacts.values()) {
            if(con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
        if(!accountIds.isEmpty()) {
            updateAccountWithContactCount(accountIds);
        }
    }

    private static void handleAfterDelete(Map<Id, Contact> oldContacts) {
        Set<Id> accountIds = new Set<Id>();
        for(Contact con : oldContacts.values()) {
            if(con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
        if(!accountIds.isEmpty()) {
            updateAccountWithContactCount(accountIds);
        }
    }

    private static void handleAfterUndelete(Map<Id, Contact> newContacts) {
        Set<Id> accountIds = new Set<Id>();
        for(Contact con : newContacts.values()) {
            if(con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
        if(!accountIds.isEmpty()) {
            updateAccountWithContactCount(accountIds);
        }
    }

    private static Integer countActiveContactOnAccount(Set<Id> accountId) {
        return [SELECT COUNT() FROM Contact WHERE AccountId = :accountId AND Active__c = TRUE];
    }

    private static void updateAccountWithContactCount(Set<Id> accountId) {
        Integer contactCount = countActiveContactOnAccount(accountId);
        List<Account> accountsToUpdate = new List<Account>();
        for(Id accId : accountId) {
            accountsToUpdate.add(new Account(Id = accId, Active_Contacts__c = contactCount));
        }
        if(!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;    
        }
    }
}