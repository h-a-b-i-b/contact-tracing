({
    init: function (cmp, event, helper) {

        const personColumns = [
            { label: "Person Name", fieldName: "Name", type: "text" },
            { label: "Phone", fieldName: "Mobile__c", type: "phone" },
            { label: "Token", fieldName: "Token__c", type: "text" },
            { label: "Health Status", fieldName: "Health_Status__c", type: "text" },
            { label: "Status Update Date", fieldName: "Status_Update_Date__c", type: "date" }
        ];

        const locationColumns = [
            { label: "Location Name", fieldName: "Name", type: "text" },
            { label: "Status", fieldName: "Status__c", type: "text" },
            { label: "Pincode", fieldName: "Pincode__c", type: "text" },
            { label: "Address", fieldName: "Address__c", type: "text" },
            { label: "Red Score", fieldName: "Red_Score__c", type: "number" },
            { label: "Status Update Date", fieldName: "Status_Update_Date__c", type: "date" }
        ];

        const scope = cmp.get("v.scope");

        cmp.set("v.columns", scope === 'person' ? personColumns : locationColumns);
        helper.getRecords(cmp, scope);
    },

    refreshComponentState: function () {

    },

    handleOnCommit: function (cmp, evt, helper) {
        var searchTerm = cmp.find('enter-search').get('v.value');

        helper.filterDataByTerm(cmp, searchTerm);
    }
})