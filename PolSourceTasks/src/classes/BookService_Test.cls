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

        //then
        System.assert(testBook != null);
        System.assert(testBook instanceof BookWrapper);
        BookWrapper bw = (BookWrapper) testBook;
        System.assertEquals(book.ISBN__c, bw.isbn);
        System.assertEquals(book.Id, bw.id);
        System.assertEquals(book.Publisher__c, bw.publisherId);
        System.assertEquals(editions.size(), bw.bookEditions.size());
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

        //then
        System.assert(test instanceof MessageWrapper);
        MessageWrapper mw = (MessageWrapper) test;
        System.assertEquals(TestDataFactory.ERROR_NO_DIGITS_ISBN, mw.message);

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

        //then
        System.assert(test instanceof MessageWrapper);
        MessageWrapper mw = (MessageWrapper) test;
        System.assertEquals(TestDataFactory.ERROR_NO_ROWS, mw.message);
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

        //then
        System.assert(newBook instanceof BookWrapper);
        BookWrapper bw = (BookWrapper) newBook;
        System.assertEquals('hh', bw.title);
        System.assertEquals('Stefan Zeromski', bw.author);
        System.assertEquals(453453, bw.isbn);
        System.assertEquals(acc.Id, bw.publisherId);
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

        //then
        System.assert(newBook instanceof MessageWrapper);
        MessageWrapper mw = (MessageWrapper) newBook;
        System.assertEquals(TestDataFactory.ERROR_REQUIRED_FIELD, mw.message);
    }

    @isTest
    static void testCreateBookWithEdition() {
        //given
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI;
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(TestDataFactory.CREATE_BOOK_WITH_EDITION_JSON);
        RestContext.request = request;

        //when
        Wrapper newBook = BookService.createBook();

        //then
        System.assert(newBook instanceof BookWrapper);
        BookWrapper bw = (BookWrapper) newBook;
        System.assertEquals('Skazani na Shawshank', bw.title);
        System.assertEquals(6, bw.isbn);
        System.assertEquals('0010O00001tN63C', bw.publisherId);
    }

    @isTest
    static void testBookDelete() {
        //given 
        Book__c book = TestDataFactory.prepareBook(true);
        Edition__c edition = TestDataFactory.prepareEdition(true, book, true) ;
        Id bookId = book.Id;
        System.assertEquals(1, [SELECT COUNT() FROM Book__c Where Id = :bookId]);
        System.assertEquals(1, [SELECT COUNT() FROM Edition__c WHERE Book__c = :bookId]);
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI + book.Id;
        request.httpMethod = 'DELETE';
        RestContext.request = request;

        //when
        Wrapper result = BookService.deleteBook();

        //then
        System.assert(result instanceof MessageWrapper);
        MessageWrapper mw = (MessageWrapper) result;
        System.assertEquals(TestDataFactory.RECORD_DELETED, mw.message);
        System.assertEquals(0, [SELECT COUNT() FROM Book__c Where Id = :bookId]);
        System.assertEquals(0, [SELECT COUNT() FROM Edition__c WHERE Book__c = :bookId]);
    }

    @isTest
    static void testEmptyBookDelete() {
        //given
        Book__c book = TestDataFactory.prepareBook(true);
        Id bookId = book.Id;
        System.assertEquals(1, [SELECT COUNT() FROM Book__c Where Id = :bookId]);
        RestRequest request = new RestRequest();
        request.requestURI = TestDataFactory.REQUEST_URI + '111';
        request.httpMethod = 'DELETE';
        RestContext.request = request;

        //when
        Wrapper result = BookService.deleteBook();

        //then
        System.assert(result instanceof MessageWrapper);
        MessageWrapper mw = (MessageWrapper) result;
        System.assertEquals(TestDataFactory.ERROR_NO_ROWS, mw.message);
        System.assertEquals(1, [SELECT COUNT() FROM Book__c Where Id = :bookId]);
    }
}