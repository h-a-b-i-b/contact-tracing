public with sharing class CTUserTabController {
    
    /**
     *   Get User Details
     */
    public static UserInformation getUserDetails(String personId) {
        
        UserInformation info = new UserInformation();
        
        // Get person's details
        Person__c person = CTPersonController.getPersonById(personId);

        if(person != null) {
            info.name = person.Name;
            info.token = person.Token__c;
            info.statusUpdateOn = person.Status_Update_Date__c;
            info.phone = person.Mobile__c;
            info.status = person.Health_Status__c;
        }
        
        // Get People Tracing records
        List<People_Tracing__c> traces = CTPeopleTracingController.getTraces(personId);

        if(traces != null && traces.size() > 0) {
            List<CloseContacts> contacts = new List<CloseContacts>();
            
            for (People_Tracing__c trace : traces) {
                CloseContacts cc = new CloseContacts();

                if(personId != trace.Person_1__c) {
                    cc.id = trace.Person_1__c;
                    cc.token = trace.Person_1__r.Token__c;
                    cc.status = trace.Person_1__r.Health_Status__c;
                    cc.contactDate = trace.Contact_Date__c;
                }

                if (personId != trace.Person_2__c) {
                    cc.id = trace.Person_2__c;
                    cc.token = trace.Person_2__r.Token__c;
                    cc.status = trace.Person_2__r.Health_Status__c;
                    cc.contactDate = trace.Contact_Date__c;
                }
                contacts.add(cc);
            }
            info.contacts = contacts;
            info.contactsCount = traces.size();
        }
        return info;
    }
    
    public class UserInformation {
        @AuraEnabled public String name;
        @AuraEnabled public String token;
        @AuraEnabled public Date statusUpdateOn;
        @AuraEnabled public String phone;
        @AuraEnabled public String status;
        @AuraEnabled public Integer contactsCount = 0;
        @AuraEnabled public List<CloseContacts> contacts;
    }
    
    public class CloseContacts {
        @AuraEnabled public String id;
        @AuraEnabled public String token;
        @AuraEnabled public Date contactDate;
        @AuraEnabled public String status;
    }
}