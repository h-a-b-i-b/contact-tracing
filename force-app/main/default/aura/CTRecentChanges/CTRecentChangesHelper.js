({
    getRecords : function(cmp, scope) {
        const action = scope === 'person' ? cmp.get("c.getRecentPersonHealthChanges") : cmp.get("c.getRecentLocationHealthChanges");

        action.setCallback(this, function(response) {
            const state = response.getState();
            
            if(state === "SUCCESS") {
                cmp.set("v.data", response.getReturnValue());
            } else if(state === "ERROR") {
                const errors = response.getError();
                console.error(errors);
            }
        });

        $A.enqueueAction(action);
    }
})