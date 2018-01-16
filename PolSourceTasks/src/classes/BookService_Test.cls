@isTest
public class BookService_Test {

    @isTest
    static void testGetBookByCorrectISBN() {
        //given
        Book__c book = TestDataFactory.prepareBook(true);
        List<Edition__c> editions = TestDataFactory.prepareEditions(true, book, true, 3);
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.requestURI + book.ISBN__c;
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
        String exceptionMsg = null;
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.requestURI + 'dasd';
        request.httpMethod = 'GET';
        RestContext.request = request;
        String expectedError = 'ISBN must contain only from digits!';
        
        //when
        try{
        	ItemWrapper test = BookService.getBookByISBN();
        }catch(Exception e){
            exceptionMsg = e.getMessage();
        }       
        
        //then
        System.assertEquals(exceptionMsg.contains(expectedError), true);
    }
    
    @isTest
    static void testISBNWithoutBook() {
        String exceptionMsg = null;
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.requestURI + '1';
        request.httpMethod = 'GET';
        RestContext.request = request;
        String expectedError = 'List has no rows';
        
        //when
        try{
        	ItemWrapper test = BookService.getBookByISBN();
        }catch(Exception e){
            exceptionMsg = e.getMessage();
        }       
        
        //then
        System.assertEquals(exceptionMsg.contains(expectedError), true);
    }
    
    @isTest
    static void testCreateBook() {
        //given
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Publisher').getRecordTypeId();
        Account acc = new Account(Name = 'a', RecordTypeId = recordTypeId);
        insert acc;
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.requestURI;
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"title" : "hh", "author" : "Stefan Zeromski",  "isbn" : "453453",  "publisher" : "' + acc.Id + '"}');
        RestContext.request = request;
        
        //when
        Id newBook = BookService.createBook('hh', 'Stefan Zeromski', '453453', acc.Id);
        
        //then
        System.assertEquals(1, [SELECT COUNT() FROM Book__c Where Id = :newBook]);
    }
}