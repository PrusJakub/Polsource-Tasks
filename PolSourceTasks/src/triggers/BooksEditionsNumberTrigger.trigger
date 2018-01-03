trigger BooksEditionsNumberTrigger on Edition__c (before insert, before update) {
 	
 	BooksEditionsNumberHandler handler = new BooksEditionsNumberHandler();
 	handler.onBeforeInsertOrUpdate(Trigger.newMap, Trigger.oldMap);
}