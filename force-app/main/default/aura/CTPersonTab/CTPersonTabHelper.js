({
    getUserDetailes: function (component) {

        console.log("Helper's getUserDetailes Called...");

        var recordId = "";

        try {
            recordId = component.find("user-input").get("v.value");

            console.log("After record Id");


            console.log("recordId", recordId);



            console.log("recordId from helper: ", recordId);

            var action = component.get("c.getUserDetails");

            action.setParams({ personId: recordId });

            console.log("action set in helper...");

            action.setCallback(this, function (response) {
                console.log("inside callback...");

                const state = response.getState();
                console.log("state: ", state);
                const result = response.getReturnValue();
                console.log("result: ", result);

                if (state === "SUCCESS") {
                    console.log('User details:', response.getReturnValue());
                    component.set("v.personDetails", response.getReturnValue());
                    component.set("v.data", response.getReturnValue().contacts);
                }
            });

            console.log("Enqueuing action...");

            $A.enqueueAction(action);

        } catch (e) {
            console.error(e);
        }

        console.log("Helper execution completed.");
    }
})