@isTest
private class EditionTriggerTest {
    
    @isTest
    static void editionInsertNoActiveTest(){
        //given
        Book__c book = new Book__c();
		book = TestDataFactory.prepareBook();        
    	List<Edition__c> editions = new List<Edition__c>();
    	//when
    	for(Integer i = 0; i<3; i++){
    		editions.add(new Edition__c(Name = ('e'+i), Book__c = book.Id, Cover__c = 'Soft', Release_Date__c = date.today(), Active__c = false));    		
    	}
    	insert editions;       
        update book;
        
        //then
        book = [SELECT Id, Available_editions__c FROM Book__c WHERE Id =: book.Id];
        System.assertEquals(0, book.Available_editions__c);
    }
    
    @isTest
    static void editionInsertWithActiveTest(){
        //given
       	Book__c book = new Book__c();
		book = TestDataFactory.prepareBook();        
    	List<Edition__c> editions = new List<Edition__c>();
    	
        //when
        for(Integer i = 0; i<3; i++){
    		editions.add(new Edition__c(Name = ('e'+i), Book__c = book.Id, Cover__c = 'Soft', Release_Date__c = date.today(), Active__c = true));    		
    	}
    	insert editions;      
        
        //then
        book = [SELECT Id, Available_editions__c FROM Book__c WHERE Id =: book.Id];
        System.assertEquals(3, book.Available_editions__c);
    }
    
    @isTest
    static void editionUpdateAddActiveTest(){
        //given
        Book__c book = new Book__c();
		book = TestDataFactory.prepareBook();  
    	List<Edition__c> editions = new List<Edition__c>();
    	for(Integer i = 0; i<3; i++){
    		editions.add(new Edition__c(Name = ('e'+i), Book__c = book.Id, Cover__c = 'Soft', Release_Date__c = date.today(), Active__c = false));    		
    	}
    	insert editions;        
        
        //when
        for(Integer i = 0; i<3; i++){
        	editions.get(i).Active__c = true;
        }
        update editions;
        
        //then
        book = [SELECT Id, Available_editions__c FROM Book__c WHERE Id =: book.Id];
        System.assertEquals(3, book.Available_editions__c);       
    }
    
    @isTest
    static void editionUpdateRemoveActiveTest(){
        //given
        Book__c book = new Book__c();
		book = TestDataFactory.prepareBook();  
    	List<Edition__c> editions = new List<Edition__c>();
    	for(Integer i = 0; i<3; i++){
    		editions.add(new Edition__c(Name = ('e'+i), Book__c = book.Id, Cover__c = 'Soft', Release_Date__c = date.today(), Active__c = true));    		
    	}
    	insert editions;        
        
        //when
        for(Integer i = 0; i<3; i++){
        	editions.get(i).Active__c = false;
        }
        update editions;
        
        //then
        book = [SELECT Id, Available_editions__c FROM Book__c WHERE Id =: book.Id];
        System.assertEquals(0, book.Available_editions__c);   
    }
    
    @isTest
    static void editionDeleteTest(){
        //given
        Book__c book = new Book__c();
		book = TestDataFactory.prepareBook();
    	List<Edition__c> editions = new List<Edition__c>();
    	for(Integer i = 0; i<3; i++){
    		editions.add(new Edition__c(Name = ('e'+i), Book__c = book.Id, Cover__c = 'Soft', Release_Date__c = date.today(), Active__c = true));    		
    	}
    	insert editions;        

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