global class BookWrapper implements Wrapper {

    public String name { get; set; }
    public String title { get; set; }
    public String author { get; set; }
    public String isbn { get; set; }
    public Id publisherId { get; set; }
    public Id id { get; set; }
    public List<EditionWrapper> bookEditions { get; set; }

    public BookWrapper(String name, String title, String author, Id id, String isbn, Id publisher) {
        this.name = name;
        this.title = title;
        this.author = author;
        this.id = id;
        this.isbn = isbn;
        this.publisherId = publisher;
        bookEditions = new List<EditionWrapper>();
    }

    public Book__c getSObject() {
        Book__c book = new Book__c();
        book.Publisher__c = this.publisherId;
        book.Title__c = this.title;
        book.Author__c = this.author;
        book.ISBN__c = Decimal.valueOf(this.isbn);
        return book;
    }

    public String serialize() {
        return JSON.serialize(this);
    }

}