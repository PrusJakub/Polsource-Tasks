trigger EditionTrigger on Edition__c (after insert, after update, after delete) {
	
    List<TriggerSettings__c> cusSettings = TriggerSettings__c.getall().values();
	Boolean isActive = cusSettings.get(0).Active__c;
    
    if(isActive){
    	EditionTriggerHandler handler = new EditionTriggerHandler();
    	if(Trigger.isInsert){
	    	handler.onAfterInsert(Trigger.newMap);
	    } else if(Trigger.isUpdate) {
	        handler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
	    } else if(Trigger.isDelete){
	        handler.onAfterDelete(Trigger.oldMap);
	    }
    }
}