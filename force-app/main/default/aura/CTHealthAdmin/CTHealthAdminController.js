({
    handleTabClick : function(component, event, helper) {
        // Selected tab id
        var selectedTabId = component.get("v.selectedTabId");

        // Create a lookup map for your labels
        var tabLabels = {
            "person_view": "Person View",
            "location_view": "Location View"
        };

        component.set("v.selectedTabLabel", tabLabels[selectedTabId]);
    }
})