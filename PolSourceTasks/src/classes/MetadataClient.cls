public class MetadataClient {

    List<String> metadataNames = new List<String>();

    public void getTypes() {
        metadataNames = MetadataTypesService.getMetadataTypes();
        System.debug(metadataNames.size());
    }

}
