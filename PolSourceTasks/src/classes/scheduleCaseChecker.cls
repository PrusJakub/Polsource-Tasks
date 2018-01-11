global class scheduleCaseChecker implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        CaseChecker cc = new CaseChecker();
        database.executeBatch(cc);
    }
}