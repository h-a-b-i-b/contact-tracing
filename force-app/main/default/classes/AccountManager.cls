@RestResource(urlMapping='/Accounts/*/contacts')
global class AccountManager {
    
    @HttpGet
    global static Account getAccount(){
        RestRequest request = RestContext.request;
        
        // Use the custom substringBetween function to extract the Account ID
        String accountId = request.requestURI.substringBetween('/Accounts/', '/contacts');
        
        Account result = [
            SELECT Id, Name, (SELECT Id, Name FROM Contacts) 
            FROM Account
            WHERE Id = :accountId
        ];
        return result;
    }
}