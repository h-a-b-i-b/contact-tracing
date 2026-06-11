({
    getHealthStatusCount: function (cmp) {
        const scope = cmp.get("v.scope");
        const action = (scope === 'person') ? cmp.get("c.getPersonHealthStatusCounts") : cmp.get("c.getLocationHealthStatusCounts");

        action.setCallback(this, function (response) {

            const state = response.getState();

            if (state === "SUCCESS") {
                cmp.set('v.statusCounts', Object.assign({}, cmp.get('v.statusCounts'), response.getReturnValue()));
            }
            else if(state === "INCOMPLETE") {
                console.warn('Server response incomplete');
            }
            else if (state === "ERROR") {
                const errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})