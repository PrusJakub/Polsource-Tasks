global class CaseChecker implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Priority FROM Case WHERE CreatedDate = LAST_N_DAYS:7 AND Status = 'New']);
    }
    
    global void execute(Database.BatchableContext bc, List<Case> scope) {
        for(Case c : scope) {
            if(c.Priority != 'High')
               c.Priority = 'High';
            }
            update scope;
        }
    
    global void finish(Database.BatchableContext bc){
        
    }
}