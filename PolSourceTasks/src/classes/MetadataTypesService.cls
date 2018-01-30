public class MetadataTypesService {

    public static List<String> getMetadataTypes() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ProjectUtils.REQUEST_URI_TO_METADATA);
        request.setMethod('GET');
        request.setHeader('Authorization', ProjectUtils.AUTHORIZATION_HEADER);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            JSONResponse metadata = (JSONResponse) JSON.deserialize(response.getBody(), JSONResponse.class);
            List<String> metadataNames = new List<String>();
            for (MetadataType mt : metadata.sobjects) {
                metadataNames.add(mt.name);
            }
            return metadataNames;
        }
        return null;
    }

    private class MetadataType {
        public String activateable;
        public String createable;
        public String custom;
        public String customSetting;
        public String deletable;
        public String deprecatedAndHidden;
        public String feedEnabled;
        public String hasSubtypes;
        public String isSubtype ;
        public String keyPrefix ;
        public String label;
        public String labelPlural;
        public String layoutable;
        public String mergeable;
        public String mruEnabled;
        public String name;
        public String queryable;
        public String replicateable;
        public String retrieveable;
        public String searchable;
        public String triggerable;
        public String undeletable;
        public String updateable;
    }

    private class JSONResponse {
        public String encoding;
        public String maxBatchSize;
        public List<MetadataType> sobjects;
    }
}