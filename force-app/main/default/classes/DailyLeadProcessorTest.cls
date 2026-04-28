@isTest
public class DailyLeadProcessorTest {
    @isTest
    static void testDailyLeadProcessor() {
        // Create test data: Insert 200 Lead records with blank LeadSource
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            testLeads.add(new Lead(FirstName = 'Test', LastName = 'Lead' + i, Company = 'Alpha Tech'));
        }
        insert testLeads;
        
        // Schedule the DailyLeadProcessor class
        Test.startTest();
        String jobId = System.schedule('Test Daily Lead Processor', '0 0 0 * * ?', new DailyLeadProcessor());
        Test.stopTest();
        
        // Verify that all Lead records were updated correctly
        List<Lead> updatedLeads = [SELECT Id, LeadSource FROM Lead WHERE Id IN :testLeads];
        for (Lead lead : updatedLeads) {
            System.assertEquals('Dreamforce', lead.LeadSource, 'LeadSource not updated correctly');
        }
    }
}