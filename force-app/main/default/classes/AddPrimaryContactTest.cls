@isTest
public class AddPrimaryContactTest {
    @isTest
    static void testAddPrimaryContact() {
        // Create test data: 50 Account records for BillingState NY and 50 Account records for BillingState CA
        List<Account> testAccounts = new List<Account>();
        for(Integer i = 0; i < 50; i++) {
            testAccounts.add(new Account(Name = 'Test Account NY ' + i, BillingState = 'NY'));
            testAccounts.add(new Account(Name = 'Test Account CA ' + i, BillingState = 'CA'));
        }
        insert testAccounts;
        
        // Create a Contact record
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact');
        
        // Enqueue the job for BillingState CA
        System.enqueueJob(new AddPrimaryContact(testContact, 'CA'));
        
        // Wait for asynchronous job to complete
        Test.startTest();
        Test.stopTest();
        
        // Assert that a Contact record was inserted for each of the 50 Accounts with BillingState CA
        List<Contact> insertedContacts = [SELECT Account.BillingState FROM Contact WHERE Account.BillingState = 'CA'];
        Integer actualContactCount = insertedContacts.size();
        System.assertEquals(50, actualContactCount, 'Incorrect number of contacts inserted for BillingState CA');
    }
}