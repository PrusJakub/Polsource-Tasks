@isTest
private class EditionTriggerTest {
    
    @testSetup
    static void triggerAccess(){
        TestUtils.setCustomSettings();
    }
    
    @isTest
    static void editionInsertNoActiveTest(){
        //given
        Book__c book = TestDataFactory.prepareBook(true);        
    	
    	//when
    	List<Edition__c> editions = TestDataFactory.prepareEditions(true, book, false);  

        //then
        book = [SELECT Id, Available_editions__c FROM Book__c WHERE Id =: book.Id];
        System.assertEquals(0, book.Available_editions__c);
    }
    
    @isTest
    static void editionInsertWithActiveTest(){
        //given
       	Book__c book = TestDataFactory.prepareBook(true);       
    	
        //when
        List<Edition__c> editions = TestDataFactory.prepareEditions(true, book, true);       
        
        //then
        book = [SELECT Id, Available_editions__c FROM Book__c WHERE Id =: book.Id];
        System.assertEquals(3, book.Available_editions__c);
    }
    
    @isTest
    static void editionUpdateAddActiveTest(){
        //given
        Book__c book = TestDataFactory.prepareBook(true);  
    	List<Edition__c> editions = TestDataFactory.prepareEditions(true, book, false);  
        
        //when
        editions.get(0).Active__c = true;
        update editions;
        
        //then
        book = [SELECT Id, Available_editions__c FROM Book__c WHERE Id =: book.Id];
        System.assertEquals(1, book.Available_editions__c);       
    }
    
    @isTest
    static void editionUpdateRemoveActiveTest(){
        //given
        Book__c book = TestDataFactory.prepareBook(true);  
    	List<Edition__c> editions = TestDataFactory.prepareEditions(true, book, true);         
        
        //when
        editions.get(0).Active__c = false;
        update editions;
        
        //then
        book = [SELECT Id, Available_editions__c FROM Book__c WHERE Id =: book.Id];
        System.assertEquals(2, book.Available_editions__c);   
    }
    
    @isTest
    static void editionDeleteTest(){
        //given
        Book__c book = TestDataFactory.prepareBook(true);
    	List<Edition__c> editions = TestDataFactory.prepareEditions(true, book, true);        

        //when
        book = [SELECT Id, Available_editions__c FROM Book__c WHERE Id =: book.Id];
        System.assertEquals(3, book.Available_editions__c);   
        List<Edition__c> toDelete = [SELECT Id FROM Edition__c WHERE Book__c =: book.Id];
        delete toDelete;
        
        //then
        book = [SELECT Id, Available_editions__c FROM Book__c WHERE Id =: book.Id];
        System.assertEquals(0, book.Available_editions__c);   
    }
}