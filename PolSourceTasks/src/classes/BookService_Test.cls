@isTest
public class BookService_Test {

    @isTest
    static void testGetBookByCorrectISBN() {
        //given
        Book__c book = TestDataFactory.prepareBook(true);
        List<Edition__c> editions = TestDataFactory.prepareEditions(true, book, true, 3);
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI + book.ISBN__c;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        //when
        ItemWrapper testBook = BookService.getBookByISBN();
        
        //then
        System.assert(testBook != null);
        System.assertEquals(3, testBook.editions.size());
    }
    
    @isTest
    static void testGetBookByWrongISBN() {
        //given
        String EXCEPTION_MSG = null;
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI + 'dasd';
        request.httpMethod = 'GET';
        RestContext.request = request;
        String EXPECTED_ERROR = 'ISBN must contain only from digits!';
        
        //when
        try{
        	ItemWrapper test = BookService.getBookByISBN();
        }catch(Exception e){
            EXCEPTION_MSG = e.getMessage();
        }       
        
        //then
        System.assertEquals(EXCEPTION_MSG.contains(EXPECTED_ERROR), true);
    }
    
    @isTest
    static void testISBNWithoutBook() {
        String EXCEPTION_MSG = null;
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI + '1';
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        //when
        try{
        	ItemWrapper test = BookService.getBookByISBN();
        }catch(Exception e){
            EXCEPTION_MSG = e.getMessage();
        }       
        
        //then
        System.assertEquals(EXCEPTION_MSG.contains(TestDataFactory.ERROR_NO_ROWS), true);
    }
    
    @isTest
    static void testCreateBookWithoutEdition() {
        //given
        Account acc = new Account(Name = 'a', RecordTypeId = TestDataFactory.RECORD_TYPE_PUBLISHER);
        insert acc;
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI;
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"title" : "hh", "author" : "Stefan Zeromski",  "isbn" : "453453",  "publisher" : "' + acc.Id + '"}');
        RestContext.request = request;
        
        //when
        Id newBook = BookService.createBook('hh', 'Stefan Zeromski', '453453', acc.Id, null, null, null, null, null);
        
        //then
        System.assertEquals(1, [SELECT COUNT() FROM Book__c Where Id = :newBook]);
        System.assertEquals(0, [SELECT COUNT() FROM Edition__c WHERE Book__c = :newBook]);
    }
    
    @isTest
    static void testCreateBookWithoutField() {
		//given
		String EXCEPTION_MSG = null;
		RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI;
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"title" : "hh", "author" : "Stefan Zeromski",  "isbn" : "453453",  "publisher" : ""}');
        RestContext.request = request;
        
        //when
        try{
        Id newBook = BookService.createBook('hh', 'Stefan Zeromski', '453453', null, null, null, null, null, null);
        }catch(Exception e){
            EXCEPTION_MSG = e.getMessage();
        }
        //then
        System.assertEquals(true, EXCEPTION_MSG.contains(TestDataFactory.ERROR_REQUIRED_FIELD));        
    }
    
    @isTest
    static void testCreateBookWithEdition() {
         //given
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Publisher').getRecordTypeId();
        Account acc = new Account(Name = 'a', RecordTypeId = recordTypeId);
        insert acc;
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI;
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(TestDataFactory.CREATE_BOOK_WITH_EDITION_JSON);
        RestContext.request = request;
        
        //when
        Id newBook = BookService.createBook('hh', 'Stefan Zeromski', '453453', acc.Id, 'hard', 26.99, 'Polish edition', Date.today(), true);
        
        //then
        System.assertEquals(1, [SELECT COUNT() FROM Book__c Where Id = :newBook]);
        System.assertEquals(1, [SELECT COUNT() FROM Edition__c WHERE Book__c = :newBook]);
    }
    
    @isTest
    static void testBookDelete() {
        //given 
        Book__c book = TestDataFactory.prepareBook(true);
        Edition__c edition = TestDataFactory.prepareEdition(true, book, true) ;
        System.assertEquals(1, [SELECT COUNT() FROM Book__c Where Id = :book.Id]);
        System.assertEquals(1, [SELECT COUNT() FROM Edition__c WHERE Book__c = :book.Id]);
		RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI + book.Id;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        
        //when
        String result = BookService.deleteBook();
        
        //then
        System.assertEquals(0, [SELECT COUNT() FROM Book__c Where Id = :book.Id]);
        System.assertEquals(0, [SELECT COUNT() FROM Edition__c WHERE Book__c = :book.Id]);
        System.assertEquals('Record deleted', result);
    }
    
    @isTest
    static void testEmptyBookDelete() {
        //given
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI + '111';
        request.httpMethod = 'DELETE';
        RestContext.request = request;
      	String EXCEPTION_MSG = null;
        //when
        try{
        BookService.deleteBook();
        }catch(Exception e){
            EXCEPTION_MSG = e.getMessage();
        }
        //then
        System.assertEquals(true, EXCEPTION_MSG.contains(TestDataFactory.ERROR_NO_ROWS));
    }
}