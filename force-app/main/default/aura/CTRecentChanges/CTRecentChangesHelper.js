({
    getRecords : function(cmp, scope) {
        const action = scope === 'person' ? cmp.get("c.getRecentPersonHealthChanges") : cmp.get("c.getRecentLocationHealthChanges");

        action.setCallback(this, function(response) {
            const state = response.getState();
            
            if(state === "SUCCESS") {
                cmp.set("v.data", response.getReturnValue());
                cmp.set("v.initialData", response.getReturnValue());
            } else if(state === "ERROR") {
                const errors = response.getError();
                console.error(errors);
            }
        });

        $A.enqueueAction(action);
    },

    getSearchResult : function(cmp) {

        const queryTerm = cmp.find('enter-search').get('v.value');
        
        if(!queryTerm) {
            cmp.set("v.data", cmp.get("v.initialData"));
            return;
        }

        const action = cmp.get("v.scope") === 'person' ? cmp.get("c.searchPeople") : cmp.get("c.searchLocation");

        action.setParams({
            "searchTerm" : queryTerm
        });
        
        action.setCallback(this, function (response) {
            const state = response.getState();

            if(state === 'SUCCESS') {
                cmp.set("v.data", response.getReturnValue());
            } else if (state === 'INCOMPLETE') {
                console.log('Response from the server is incomplete');
            } else if (state === 'ERROR') {
                console.error(response.getError());
            }
        });
        
        $A.enqueueAction(action);
    }
})