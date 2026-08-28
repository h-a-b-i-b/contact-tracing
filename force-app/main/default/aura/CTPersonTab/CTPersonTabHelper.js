({
    getUserDetailes: function (component) {

        console.log("Helper's getUserDetailes Called...");

        var recordId = "";

        try {
            recordId = component.find("user-input").get("v.value");
            var action = component.get("c.getUserDetails");

            action.setParams({ personId: recordId });
            action.setCallback(this, function (response) {
                const state = response.getState();
                const result = response.getReturnValue();

                console.log("result: ", result);

                if (state === "SUCCESS") {
                    if (result != null) {
                        component.set("v.personDetails", result);
                        component.set("v.data", result.contacts);
                        component.set("v.userFound", true);
                    } else {
                        component.set("v.userFound", false);
                        this.showToast("ERROR!", "Please enter valid user Id!", "error");
                    }
                } else if (state === "ERROR") {
                    console.error(state.getError());
                    component.set("v.userFound", false);
                    this.showToast("ERROR!", "Please enter valid user Id!", "error");
                }
            });

            $A.enqueueAction(action);

        } catch (e) {
            console.error(e);
        }
    },

    showToast: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    }
})