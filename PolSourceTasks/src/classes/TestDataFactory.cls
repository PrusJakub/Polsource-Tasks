@isTest
public class TestDataFactory {

    public static final String REQUEST_URI = 'https://playful-goat-198379-dev-ed.my.salesforce.com/services/apexrest/Book/';
    public static final String CREATE_BOOK_WITH_EDITION_JSON = '{"title" : "Skazani na Shawshank", "author" : "Stephan King", "isbn" : "6456424684",  "publisherId" : "0010O00001tN63C", "bookEditions" : [{"cover" : "hard", "price" : 26.99, "name" : "Polish edition", "releaseDate" : "1989-06-14", "active" : true }]}';
    public static final String ERROR_NO_ROWS = 'There is not any book with this ID!';
    public static final String ERROR_REQUIRED_FIELD = 'REQUIRED_FIELD_MISSING';
    public static final Id RECORD_TYPE_PUBLISHER = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Publisher').getRecordTypeId();
    public static final String ERROR_NO_DIGITS_ISBN = 'ISBN must contain only from digits!';
    public static final String URI_MAPPING = 'Book/';
    public static final String ERROR_DUPLICATED_VALUE = 'DUPLICATE_VALUE';
    public static final String RECORD_DELETED = 'Record deleted';
    public static final String ERROR_NO_ID = 'You have to insert ID of book you want delete!';
    public static final String ERROR_NO_ISBN = 'You have to insert ISBN of book you want get!';

    public static Book__c prepareBook(Boolean shouldInsert) {
        Account acc = new Account(Name = 'a', RecordTypeId = RECORD_TYPE_PUBLISHER);
        insert acc;
        Book__c book = new Book__c(Title__c = 'abc', ISBN__c = 1, Author__c = 'a', Publisher__c = acc.Id, Available_editions__c = 0);

        if (shouldInsert) {
            insert book;
        }
        return book;
    }

    public static List<Edition__c> prepareEditions(Boolean shouldInsert, Book__c book, Boolean isActive, Integer numberOfEditions) {
        List<Edition__c> editions = new List<Edition__c>();
        for (Integer i = 0; i < numberOfEditions; i++) {
            editions.add(prepareEdition(false, book, isActive));
        }
        if (shouldInsert) {
            upsert editions;
        }
        return editions;
    }

    public static Edition__c prepareEdition(Boolean shouldInsert, Book__c book, Boolean isActive) {
        Edition__c edition = new Edition__c(Name = ('e'), Book__c = book.Id, Cover__c = 'Soft', Release_Date__c = date.today(), Active__c = isActive, Price__c = 10);
        if (shouldInsert) {
            insert edition;
        }
        return edition;
    }


}