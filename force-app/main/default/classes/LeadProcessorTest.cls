@isTest
public class LeadProcessorTest {
    @isTest
    static void testLeadProcessor() {
        // Insert test Lead records
        List<Lead> testLeads = new List<Lead>();
        for(Integer i = 0; i < 200; i++) {
            testLeads.add(new Lead(
                FirstName = 'Test' + i,
                LastName = 'Lead',
                Company = 'Test Company',
                LeadSource = 'Dreamforce'
            ));
        }
        insert testLeads;
        
        // Call the Batch Apex class
        Test.startTest();
        LeadProcessor batch = new LeadProcessor();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Verify that all Lead records were updated correctly
        List<Lead> updatedLeads = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.assertEquals(200, updatedLeads.size());
        for(Lead lead : updatedLeads) {
            System.assertEquals('Dreamforce', lead.LeadSource);
        }
    }
}