@isTest
public class TestDataFactory {

    public static Book__c prepareBook(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Publisher').getRecordTypeId();
        Account acc = new Account(Name = 'a', RecordTypeId = recordTypeId);
        insert acc;    	
    	Book__c book = new Book__c(Title__c = 'abc', Price__c = 20, ISBN__c = 1, Author__c = 'a', Publisher__c = acc.Id, Available_editions__c = 0);
    	insert book;
        return book;
    }
}