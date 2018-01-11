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
        
        //when
        Test.startTest();
        CaseChecker cc = new CaseChecker();
        Database.executeBatch(cc);
        Test.stopTest();
        
        //then
        System.assertEquals(100, [SELECT COUNT() FROM Case WHERE Priority = 'High']);
    }

}