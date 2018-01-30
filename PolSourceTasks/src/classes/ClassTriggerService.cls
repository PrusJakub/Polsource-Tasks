public class ClassTriggerService {

    private static List<ClassTrigger> getClassTrigger() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ProjectUtils.REQUEST_URI_TO_CLASS_TRIGGER);
        request.setMethod('GET');
        request.setHeader('Authorization', ProjectUtils.AUTHORIZATION_HEADER);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            List<ClassTrigger> classTriggerList = (List<ClassTrigger>) JSON.deserialize(response.getBody(), List<ClassTrigger>.class);
            return classTriggerList;
        }
        return null;
    }

    public static List<String> getClasses() {
        List<ClassTrigger> classes = new List<ClassTrigger>();
        classes = getClassTrigger();
        List<String> classNames = new List<String>();
        for (ClassTrigger ct : classes) {
            if (ct.type == 'CLASS') {
                classNames.add(ct.name);
            }
        }
        return classNames;
    }

    public static List<String> getTriggers() {
        List<ClassTrigger> triggers = new List<ClassTrigger>();
        triggers = getClassTrigger();
        List<String> triggerNames = new List<String>();
        for (ClassTrigger ct : triggers) {
            if (ct.type == 'TRIGGER') {
                triggerNames.add(ct.name);
            }
        }
        return triggerNames;
    }


    public class ClassTrigger {
        private String id;
        private String name;
        private String namespace;
        private String type;
        private String typeRef;
    }
}