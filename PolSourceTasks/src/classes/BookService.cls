@RestResource(urlMapping='/Book/*')
global with sharing class BookService {

    @HttpGet
    global static Wrapper getBookByISBN() {
        Book__c book;
        List<Edition__c> editions;

        try {
            String bookISBN = getBookFromURI(RestContext.request);
            Decimal bookISBNdec = Decimal.valueOf(bookISBN);
            book = [SELECT Title__c, Author__c, Id, Name, Publisher__c, ISBN__c FROM Book__c WHERE ISBN__c = :bookISBNdec];
            editions = [SELECT Name, Price__c, Cover__c, Release_Date__c, Id, Active__c FROM Edition__c WHERE Book__c = :book.Id];
        } catch (Exception e) {
            if (e.getMessage().contains(ProjectUtils.LIST_HAS_NO_ROWS)) {
                return new MessageWrapper(ProjectUtils.ERROR_NO_ROWS);
            } else if (e.getMessage().contains(ProjectUtils.NO_PARAMETER)) {
                return new MessageWrapper(ProjectUtils.NO_PARAMETER);
            } else if (e.getMessage().contains(ProjectUtils.INVALID_DECIMAL)) {
                return new MessageWrapper(ProjectUtils.ERROR_NO_DIGITS_ISBN);
            } else {
                return new MessageWrapper(e.getMessage());
            }
        }

        BookWrapper bWrapper = new BookWrapper(book, editions);
        return bWrapper;
    }

    @HttpPost
    global static Wrapper createBook() {
        Book__c book;
        List<Edition__c> editions;
        
        try {
            String jsonBody = RestContext.request.requestBody.toString();
            BookWrapper bWrapper = (BookWrapper) JSON.deserialize(jsonBody, BookWrapper.class);
            book = bWrapper.getSObject();
            editions = new List<Edition__c>();
            insert book;
            if (bWrapper.bookEditions != null) {
                for (Integer i = 0; i < bWrapper.bookEditions.size(); i++) {
                    EditionWrapper eWrapper = bWrapper.bookEditions.get(i);
                    if (eWrapper.cover != null && eWrapper.price != null) {
                        Edition__c edition = eWrapper.getSObject();
                        edition.Book__c = book.Id;
                        editions.add(edition);
                    }
                }
                insert editions;
            }
        } catch (Exception e) {
            if (e.getMessage().contains(ProjectUtils.ERROR_REQUIRED_FIELD)) {
                return new MessageWrapper(ProjectUtils.ERROR_REQUIRED_FIELD);
            } else if (e.getMessage().contains(ProjectUtils.ERROR_DUPLICATED_VALUE)) {
                return new MessageWrapper(ProjectUtils.ERROR_DUPLICATED_VALUE + ' of ISBN');
            } else {
                return new MessageWrapper(e.getMessage());
            }
        }

        BookWrapper retWrapper = new BookWrapper(book, editions);
        return retWrapper;
    }

    @HttpDelete
    global static Wrapper deleteBook() {
        try {
            String bookID = getBookFromURI(RestContext.request);
            Book__c book = [SELECT Id FROM Book__c WHERE Id = :bookID];
            delete book;
        } catch (Exception e) {
            if (e.getMessage().contains(ProjectUtils.LIST_HAS_NO_ROWS)) {
                return new MessageWrapper(ProjectUtils.ERROR_NO_ROWS);
            } else if (e.getMessage().contains(ProjectUtils.NO_PARAMETER)) {
                return new MessageWrapper(ProjectUtils.ERROR_NO_ID);
            } else {
                return new MessageWrapper(e.getMessage());
            }
        }
        return new MessageWrapper(ProjectUtils.RECORD_DELETED);
    }

    private static String getBookFromURI(RestRequest request) {
        String parameter = request.requestURI.substring(request.requestURI.lastIndexOf(ProjectUtils.BOOK_SERVICE_URI_MAPPING) + ProjectUtils.BOOK_SERVICE_URI_MAPPING.length());
        if (parameter.length() == 0) {
            throw new MyException(ProjectUtils.NO_PARAMETER);
        }
        return parameter;
    }
}