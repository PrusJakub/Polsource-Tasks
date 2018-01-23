@RestResource(urlMapping='/Book/*')
global with sharing class BookService {

    @HttpGet
    global static Wrapper getBookByISBN() {
        RestRequest request = RestContext.request;
        String bookISBN = getBookFromURI(request);
        Book__c book;
        List<Edition__c> editions;
        Decimal bookISBNdec;

        try {
            checkParameter(bookISBN);
            bookISBNdec = Decimal.valueOf(bookISBN);
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

        BookWrapper bWrapper = new BookWrapper(book);
        for (Integer i = 0; i < editions.size(); i++) {
            EditionWrapper editionsWrapper = new EditionWrapper(editions.get(i));
            bWrapper.bookEditions.add(editionsWrapper);
        }
        return bWrapper;
    }

    @HttpPost
    global static Wrapper createBook() {
        RestRequest request = RestContext.request;
        String jsonBody = request.requestBody.toString();
        BookWrapper bWrapper;
        try {
            bWrapper = (BookWrapper) JSON.deserialize(jsonBody, BookWrapper.class);
        } catch (Exception e) {
            return new MessageWrapper(e.getMessage());
        }
        Book__c book = new Book__c();
        book = bWrapper.getSObject();
        List<Edition__c> editions = new List<Edition__c>();
        try {
            insert book;
        } catch (Exception e) {
            if (e.getMessage().contains(ProjectUtils.ERROR_REQUIRED_FIELD)) {
                return new MessageWrapper(ProjectUtils.ERROR_REQUIRED_FIELD);
            } else if (e.getMessage().contains(ProjectUtils.ERROR_DUPLICATED_VALUE)) {
                return new MessageWrapper(ProjectUtils.ERROR_DUPLICATED_VALUE + ' of ISBN');
            } else {
                return new MessageWrapper(e.getMessage());
            }
        }
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
        BookWrapper retWrapper = new BookWrapper(book);
        for (Integer i = 0; i < editions.size(); i++) {
            EditionWrapper editionsWrapper = new EditionWrapper(editions.get(i));
            retWrapper.bookEditions.add(editionsWrapper);
        }
        return retWrapper;
    }

    @HttpDelete
    global static Wrapper deleteBook() {
        RestRequest request = RestContext.request;
        Book__c book;
        String bookID = getBookFromURI(request);
        try {
            checkParameter(bookID);
            book = [SELECT Id FROM Book__c WHERE Id = :bookID];
        } catch (Exception e) {
            if (e.getMessage().contains(ProjectUtils.LIST_HAS_NO_ROWS)) {
                return new MessageWrapper(ProjectUtils.ERROR_NO_ROWS);
            } else if (e.getMessage().contains(ProjectUtils.NO_PARAMETER)) {
                return new MessageWrapper(ProjectUtils.ERROR_NO_ID);
            } else {
                return new MessageWrapper(e.getMessage());
            }
        }
        delete book;
        return new MessageWrapper(ProjectUtils.RECORD_DELETED);
    }

    private static String getBookFromURI(RestRequest request) {
        return request.requestURI.substring(request.requestURI.lastIndexOf(ProjectUtils.URI_MAPPING) + ProjectUtils.URI_MAPPING.length());
    }

    private static void checkParameter(String parameter) {
        if (parameter.length() == 0) {
            throw new MyException(ProjectUtils.NO_PARAMETER);
        }
    }
}