public class AnimalLocator {
    public static String getAnimalNameById(Integer animalId){
        String endPoint = 'https://th-apex-http-callout.herokuapp.com/animals/' + animalId;
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        // Deserializes the JSON string into collections of primitive data types.
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        System.debug(response);
        Map<String, Object> animal = (Map<String, Object>) results.get('animal');
        return String.valueOf(animal.get('name'));
    }
}