public with sharing class CustomObjectService {

    public static List<String> getCustomObjectNames() {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        List<String> sobjects = new List<String>(gd.keySet());
        sobjects.sort();
        for (String s : sobjects) {
            System.debug(s);
        }
        System.debug(sobjects.size());
        return sobjects;
    }
}