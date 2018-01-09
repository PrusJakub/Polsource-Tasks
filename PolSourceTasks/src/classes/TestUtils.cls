@isTest
public class TestUtils {

    public static void setCustomSettings() {
    	TriggerSettings__c cusSettings = new TriggerSettings__c(Name = 'EditionTrigger', Active__c = true);
        insert cusSettings;
    }
}