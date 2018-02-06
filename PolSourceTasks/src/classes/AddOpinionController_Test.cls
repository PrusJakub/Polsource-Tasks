@isTest
public with sharing class AddOpinionController_Test {

    @isTest
    static void testCreateRecord() {
        //given
        Book__c book = TestDataFactory.prepareBook(true);
        Contact reader = TestDataFactory.prepareContact(true);
        Opinion__c opinion = new Opinion__c();
        ApexPages.StandardController standardController = new ApexPages.StandardController(opinion);
        AddOpinionPageController controller = new AddOpinionPageController(standardController);

        //when
        Id testId = controller.createRecord(opinion, book, reader);

        //then
        System.assert(testId != null);

    }

}