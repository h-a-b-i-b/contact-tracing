({
    updateRedStatus: function (component) {
        const recordId = component.get("v.recordId");
        const action = component.get("c.updatePersonStatusToRed");

        action.setParams({
            recordId: recordId
        });

        action.setCallback(this, function (response) {
            const state = response.getState();

            if (state === "SUCCESS") {
                this.showToast("Update Success!", "Person health status updated successfully.", "Success");
            }
        });

        $A.enqueueAction(action);
    },

    showToast: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title || "Success!",
            "message": message || "The record has been updated successfully.",
            "type": type || "Success"
        });
        toastEvent.fire();
    }
})