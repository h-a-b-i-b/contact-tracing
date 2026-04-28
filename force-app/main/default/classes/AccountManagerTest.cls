@isTest
public class AccountManagerTest {
    
    // Use a testSetup method to create common test data
    @testSetup
    static void setupData() {
        // Create a test Account
        Account testAcc = new Account(Name = 'Test Account');
        insert testAcc;
        
        // Optionally, create a Contact for the Account (to cover the subquery)
        Contact testCon = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = testAcc.Id);
        insert testCon;
    }
    
    // Test the valid request scenario
    static testMethod void testValidRequest() {
        // Retrieve the test Account inserted in testSetup
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        // Create a REST request with a valid URI structure: /Accounts/{accountId}/contacts
        RestRequest req = new RestRequest();
        req.requestURI = 'https://yourInstance.my.salesforce.com/services/apexrest/Accounts/' + acc.Id + '/contacts';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        Test.startTest();
        Account result = AccountManager.getAccount();
        Test.stopTest();
        
        // Assert that a valid Account record is returned
        System.assertNotEquals(null, result, 'Result should not be null.');
        System.assertEquals(acc.Id, result.Id, 'The returned account ID should match the expected value.');
    }
}