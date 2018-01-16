@isTest
public class BookService_Test {

    @isTest
    static void testGetBookByCorrectISBN() {
        //given
        Book__c book = TestDataFactory.prepareBook(true);
        List<Edition__c> editions = TestDataFactory.prepareEditions(true, book, true, 3);
        RestRequest request = new RestRequest();
        request.requestURI = 'https://playful-goat-198379-dev-ed.my.salesforce.com/services/apexrest/Book/' + book.ISBN__c;
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
        request.requestURI = 'https://playful-goat-198379-dev-ed.my.salesforce.com/services/apexrest/Book/dasd';
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
        request.requestURI = 'https://playful-goat-198379-dev-ed.my.salesforce.com/services/apexrest/Book/1';
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
}