({
    handleClick : function(component, event, helper) {
        console.log("handleClick called..." );
        console.log("Befter record Id");
        








        // Define colums
        component.set('v.columns', [
            { label: 'Token', fieldName: 'token', type: 'text' },
            { label: 'Contact Status', fieldName: 'status', type: 'text' },
            { label: 'Contact date', fieldName: 'contactDate', type: 'date' }
        ]);

        
        // Call Helper Action
        helper.getUserDetailes(component);
    }
})