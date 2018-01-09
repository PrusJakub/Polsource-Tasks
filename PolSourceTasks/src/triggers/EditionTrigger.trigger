trigger EditionTrigger on Edition__c (after insert, after update, after delete) {
	
    TriggerSettings__c cusSettings = TriggerSettings__c.getValues('isActive');
    Boolean isActive = cusSettings.Active__c;
    
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