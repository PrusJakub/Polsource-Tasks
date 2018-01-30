public with sharing class AnimalLocator {

    public static String getAnimalNameById(Integer animalId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + animalId);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        Map<String, Animal> results = (Map<String, Animal>) JSON.deserialize(response.getBody(), Map<String, Animal>.class);
        String animalName = results.get((String) results.keySet().iterator().next()).name;
        return animalName;
    }

    public class Animal {
        public String Id;
        public String name;
        public String eats;
        public String says;

        public Animal(String Id, String name, String eats, String says) {
            this.Id = Id;
            this.name = name;
            this.eats = eats;
            this.says = says;
        }
    }
}