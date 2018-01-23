public class ProjectUtils {

    public static final String REQUEST_URI = 'https://playful-goat-198379-dev-ed.my.salesforce.com/services/apexrest/Book/';
    public static final String CREATE_BOOK_WITH_EDITION_JSON = '{"title" : "Skazani na Shawshank", "author" : "Stephan King", "isbn" : "6456424684",  "publisherId" : "0010O00001tN63C", "bookEditions" : [{"cover" : "hard", "price" : 26.99, "name" : "Polish edition", "releaseDate" : "1989-06-14", "active" : true }]}';
    public static final String ERROR_NO_ROWS = 'There is not any book with this ID!';
    public static final String ERROR_REQUIRED_FIELD = 'REQUIRED_FIELD_MISSING';
    public static final Id RECORD_TYPE_PUBLISHER = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Publisher').getRecordTypeId();
    public static final String ERROR_NO_DIGITS_ISBN = 'ISBN must contain only from digits!';
    public static final String BOOK_SERVICE_URI_MAPPING = 'Book/';
    public static final String ERROR_DUPLICATED_VALUE = 'DUPLICATE_VALUE';
    public static final String RECORD_DELETED = 'Record deleted';
    public static final String ERROR_NO_ID = 'You have to insert ID of book you want delete!';
    public static final String ERROR_NO_ISBN = 'You have to insert ISBN of book you want get!';
    public static final String LIST_HAS_NO_ROWS = 'List has no rows for assignment to SObject';
    public static final String NO_PARAMETER = 'No parameter given!';
    public static final String INVALID_DECIMAL = 'Invalid decimal';
}