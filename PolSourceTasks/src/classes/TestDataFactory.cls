@isTest
public class TestDataFactory {

    public static Book__c prepareBook(Boolean shouldInsert){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Publisher').getRecordTypeId();
        Account acc = new Account(Name = 'a', RecordTypeId = recordTypeId);
        insert acc;     
        Book__c book = new Book__c(Title__c = 'abc', ISBN__c = 1, Author__c = 'a', Publisher__c = acc.Id, Available_editions__c = 0);
        
        if(shouldInsert){
            insert book;
        }
        return book;
    }
    
    public static List<Edition__c> prepareEditions(Boolean shouldInsert, Book__c book, Boolean isActive, Integer numberOfEditions) {             
     	   	List<Edition__c> editions = new List<Edition__c>();            
     	   	for(Integer i = 0; i<numberOfEditions; i++){
    			editions.add(prepareEdition(true, book, isActive));    		
    		}
        	if(shouldInsert){
	    		insert editions; 
	        }
	        return editions;
    }
    
    public static Edition__c prepareEdition(Boolean shouldInsert, Book__c book, Boolean isActive){
        return new Edition__c(Name = ('e'), Book__c = book.Id, Cover__c = 'Soft', Release_Date__c = date.today(), Active__c = isActive, Price__c = 10);
    }
}