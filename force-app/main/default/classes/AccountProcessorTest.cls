@isTest
public class AccountProcessorTest {
    @isTest
    static void testCountContacts() {
        // Create test data: Accounts and Contacts
        List<Account> testAccounts = new List<Account>();
        List<Contact> testContacts = new List<Contact>();
        for(Integer i = 0; i < 5; i++) {
            Account acc = new Account(Name = 'Test Account ' + i);
            testAccounts.add(acc);
            for(Integer j = 0; j < i + 1; j++) {
                testContacts.add(new Contact(AccountId = acc.Id, LastName = 'Test Contact ' + j));
            }
        }
        insert testAccounts;
        insert testContacts;
        
        // Call the future method
        Test.startTest();
        AccountProcessor.countContacts(new List<Id>{testAccounts[0].Id, testAccounts[1].Id, testAccounts[2].Id});
        Test.stopTest();
        
        // Verify that the Number_Of_Contacts__c field is updated correctly
        List<Account> updatedAccounts = [SELECT Id, Number_Of_Contacts__c FROM Account WHERE Id IN :new List<Id>{testAccounts[0].Id, testAccounts[1].Id, testAccounts[2].Id}];
        System.assertEquals(1, updatedAccounts[0].Number_Of_Contacts__c);
        System.assertEquals(2, updatedAccounts[1].Number_Of_Contacts__c);
        System.assertEquals(3, updatedAccounts[2].Number_Of_Contacts__c);
    }
}