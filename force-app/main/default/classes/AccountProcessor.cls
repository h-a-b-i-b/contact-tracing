public class AccountProcessor {
    @future
    public static void countContacts(List<Id> accountIds) {
        List<Account> accountsToUpdate = new List<Account>();
        
        // Query for the number of contacts associated with each account
        for(Id accId : accountIds) {
            Integer contactCount = [SELECT COUNT() FROM Contact WHERE AccountId = :accId];
            Account acc = new Account(Id = accId, Number_Of_Contacts__c = contactCount);
            accountsToUpdate.add(acc);
        }
        
        // Update the accounts with the contact count
        if(!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}