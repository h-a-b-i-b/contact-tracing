({
    callPersonStatusCount : function(cmp) {
        console.log('Helper callPersonStatusCount called...');
        
        var action = cmp.get("c.getPersonHealthStatusCounts");

        action.setCallback(this, function(response) {
            
            var state = response.getState();

            if (state === "SUCCESS") {
                cmp.set('v.personStatusMap', Object.assign(cmp.get('v.personStatusMap'), response.getReturnValue()) || {});
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    callLocationStatusCount : function(cmp) {
        console.log('Helper callLocationStatusCount called...');
        
        var action = cmp.get("c.getLocationHealthStatusCounts");

        action.setCallback(this, function(response) {
            
            var state = response.getState();

            if (state === "SUCCESS") {
                cmp.set('v.personStatusMap', Object.assign(cmp.get('v.personStatusMap'), response.getReturnValue()) || {});
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})