public with sharing class EditionTriggerHandler {
   
   public void onAfterUpdate(Map<Id, Edition__c> newMap, Map<Id, Edition__c> oldMap){
        Set<Id> bookIds = new Set<Id>();
        for(Edition__c e : newMap.values()){             
            if(e.Active__c != oldMap.get(e.Id).Active__c){
                bookIds.add(e.Book__c);
            }             
        }        
        updateBookAvailableEditions(bookIds);		
    }
    
    public void onAfterInsert(Map<Id, Edition__c> newMap) {
        Set<Id> bookIds = new Set<Id>();
        for(Edition__c e : newMap.values()){             
            if(e.Active__c == true){
                bookIds.add(e.Book__c);
            }                      
        }		
        updateBookAvailableEditions(bookIds);
    }
    
    public void onAfterDelete(Map<Id, Edition__c> oldMap) {
        Set<Id> bookIds = new Set<Id>();
        for(Edition__c e : oldMap.values()){             
            if(e.Active__c == true){
                bookIds.add(e.Book__c);
            }             
        }        
        updateBookAvailableEditions(bookIds);
    }
    
    private static void updateBookAvailableEditions(Set<Id> bookIds) {
        List<Book__c> books = [SELECT Id, Available_editions__c, (SELECT Id, Active__c FROM Editions__r WHERE Active__c = true) bookEditions FROM Book__c WHERE Id IN :bookIds];
        for(Book__c b : books){
			b.Available_editions__c = b.Editions__r.size();   
        }
        update books;
    }
}