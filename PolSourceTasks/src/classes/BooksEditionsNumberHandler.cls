public with sharing class BooksEditionsNumberHandler {
    
    public void onBeforeInsertOrUpdate(Map<Id, Edition__c> newMap, Map<Id, Edition__c> oldMap){
    	
    	List<Edition__c> editions = new List<Edition__c>();
    	for(Edition__c edi : (List<Edition__c>) newMap.values()) {    		
    		Book__c book = [SELECT Id, Available_editions__c, (SELECT Id FROM Editions__r) FROM Book__c WHERE Id =: edi.Book__c];
    		Integer currNumOfEd = 
    		if(currNumOfEd < book.Available_editions__c) {
    			editions.add(edi);
    		}
    	}
    	upsert editions;
    }
}