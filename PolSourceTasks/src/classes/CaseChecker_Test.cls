@isTest
public class CaseChecker_Test {

    @isTest
    static void testCase(){
        //given
        List<Case> cases = new List<Case>();
        for(Integer i = 0 ; i<100; i++){
            cases.add(TestDataFactory.prepareCase(false));
        }
        insert cases;
        System.assertEquals(0, [SELECT COUNT() FROM Case WHERE Priority = 'High']);
        //when
        Test.startTest();
        CaseChecker cc = new CaseChecker();
        Database.executeBatch(cc);
        Test.stopTest();
        
        //then
        System.assertEquals(100, [SELECT COUNT() FROM Case WHERE Priority = 'High']);
    }
    
    @isTest
    static void testScheduler(){
        //given
         String sch = '0 13 21 18 01 ? 2018';
        Boolean testFlag = false;
        
        //when
        Test.startTest();
        String jobId = System.schedule('Test schedule', sch, new ScheduleCaseChecker());
        Test.stopTest();
        
        //then
        if(jobId != null){
            testFlag = true;
        }
        System.assertEquals(true, testFlag);
    }

}