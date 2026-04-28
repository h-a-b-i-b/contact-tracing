public class LeadProcessor implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([SELECT Id FROM Lead WHERE LeadSource = 'Dreamforce']);
    }
    
    public void execute(Database.BatchableContext context, List<Lead> leads) {
        for(Lead lead : leads) {
            lead.LeadSource = 'Dreamforce';
        }
        update leads;
    }
    
    public void finish(Database.BatchableContext context) {
        // Optional: Add any post-processing logic here
    }
}