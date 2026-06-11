({
    tabSelectHandler: function (component, event, helper) {
        const selectedTabId = event.getParam("id");

        component.set("v.headerTitle", selectedTabId === "person" ? "Person View" : "Location View");
        component.set("v.scope", selectedTabId);
    }
})