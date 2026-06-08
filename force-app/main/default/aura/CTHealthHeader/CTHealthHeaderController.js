({
    onInit : function(cmp, event, helper) {
        // 
        helper.callPersonStatusCount(cmp);
    },

    createRecord : function(component, event, helper) {
        const createRecordEvent = $A.get("e.force:createRecord");
        const scope = component.get("v.scope");

        createRecordEvent.setParams({
            "entityApiName": scope === "person" ? "Person__c" : "Location__c"
        });
        createRecordEvent.fire();
    },

    handleDataChange : function(component, event, helper) {
        // Get the updated value
        var newValue = event.getParam("value");

        // Perform your action here (e.g., call Apex, modify other attributes, etc.)
        if (newValue === "person") {
            helper.callPersonStatusCount(component);
        } else if (newValue === "location") {
            helper.callLocationStatusCount(component);
        }
    }
})