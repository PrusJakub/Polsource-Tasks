@isTest
public class BookService_Test {

    @isTest
    static void testGetBookByCorrectISBN() {
        //given
        Book__c book = TestDataFactory.prepareBook(true);
        List<Edition__c> editions = TestDataFactory.prepareEditions(true, book, true, 1);
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI + book.ISBN__c;
        request.httpMethod = 'GET';
        RestContext.request = request;

        //when
        Wrapper testBook = BookService.getBookByISBN();
        String test = testBook.serialize();

        //then
        System.assert(testBook != null);
        System.assertEquals(true, test.contains('bookEditions'));
    }

    @isTest
    static void testGetBookByWrongISBN() {
        //given
        String EXCEPTION_MSG = null;
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI + 'dasd';
        request.httpMethod = 'GET';
        RestContext.request = request;

        //when
        Wrapper test = BookService.getBookByISBN();
        String testString = test.serialize();

        //then
        System.assertEquals(true, testString.contains(TestDataFactory.ERROR_NO_DIGITS_ISBN));
    }

    @isTest
    static void testISBNWithoutBook() {
        String EXCEPTION_MSG = null;
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI + '1';
        request.httpMethod = 'GET';
        RestContext.request = request;

        //when
        Wrapper test = BookService.getBookByISBN();
        String testString = test.serialize();

        //then
        System.assertEquals(true, testString.contains(TestDataFactory.ERROR_NO_ROWS));
    }

    @isTest
    static void testCreateBookWithoutEdition() {
        //given
        Account acc = new Account(Name = 'a', RecordTypeId = TestDataFactory.RECORD_TYPE_PUBLISHER);
        insert acc;
        System.debug(acc);
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI;
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');

        request.requestBody = Blob.valueOf('{"title" : "hh", "author" : "Stefan Zeromski",  "isbn" : "453453",  "publisherId" : "' + acc.Id + '"}');
        RestContext.request = request;

        //when
        Wrapper newBook = BookService.createBook();
        String testString = newBook.serialize();

        //then
        System.assertEquals(false, testString.contains('bookEditions'));
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
        Wrapper newBook = BookService.createBook();
        String testString = newBook.serialize();

        //then
        System.assertEquals(true, testString.contains(TestDataFactory.ERROR_REQUIRED_FIELD));
    }

    @isTest
    static void testCreateBookWithEdition() {
         //given
        Account acc = new Account(Name = 'a', RecordTypeId = TestDataFactory.RECORD_TYPE_PUBLISHER);
        insert acc;
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI;
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(TestDataFactory.CREATE_BOOK_WITH_EDITION_JSON);
        RestContext.request = request;
        
        //when
        Wrapper newBook = BookService.createBook();
        String testString = newBook.serialize();

        //then
        System.assertEquals(false, testString.contains('_'));
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
        Wrapper result = BookService.deleteBook();
        String testString = result.serialize();
        
        //then
        System.assertEquals(true, testString.contains(TestDataFactory.RECORD_DELETED));
    }

    @isTest
    static void testEmptyBookDelete() {
        //given
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI + '111';
        request.httpMethod = 'DELETE';
        RestContext.request = request;

        //when
        Wrapper result =BookService.deleteBook();
        String testString = result.serialize();

        //then
        System.assertEquals(true, testString.contains(TestDataFactory.ERROR_NO_ROWS));
    }
}