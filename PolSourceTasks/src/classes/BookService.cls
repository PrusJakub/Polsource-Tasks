@RestResource(urlMapping='/Book/*')
global with sharing class BookService {

    @HttpGet
    global static ItemWrapper getBookByISBN() {
        RestRequest request = RestContext.request;
        String bookISBN = request.requestURI.substring(request.requestURI.lastIndexOf('Book/')+5);
        if(!bookISBN.isNumeric()){
            throw new MyException('ISBN must contain only from digits!');
        }
        Decimal bookISBNdec = Decimal.valueOf(bookISBN);      
        Book__c book = [SELECT Title__c, Author__c, Id, Name FROM Book__c WHERE ISBN__c = :bookISBNdec]; 
        List<Edition__c> editions = [SELECT Name, Price__c, Cover__c, Release_Date__c, Id FROM Edition__c WHERE Book__c = :book.Id]; 
        ItemWrapper wrapper = new ItemWrapper();
        wrapper.name = book.Name;
        wrapper.title = book.Title__c;
        wrapper.author = book.Author__c;
        wrapper.id = book.Id;
        for(Integer i = 0; i < editions.size(); i++) {
            ListWrapper lwrapper = new ListWrapper();
            lwrapper.name = editions.get(i).Name;
            lwrapper.price = editions.get(i).Price__c;
            lwrapper.cover = editions.get(i).Cover__c;
            lwrapper.releaseDate = editions.get(i).Release_Date__c;
            lwrapper.id = editions.get(i).Id;
            wrapper.editions.add(lwrapper);
        }        
        return wrapper;
    }
    
    @HttpPost
    global static Id createBook(String title, String author, String isbn, Id publisher, String cover, Decimal price, String name, Date releaseDate, Boolean active) {
        Book__c book = new Book__c();
        Edition__c edition = new Edition__c();
        book.Publisher__c = publisher;
        book.Title__c = title;
        book.Author__c = author;
        book.ISBN__c = Decimal.valueOf(isbn);
        insert book;
        if(cover != null && price != null){
        	edition.Book__c = book.Id;
        	edition.Cover__c = cover;
        	edition.Price__c = price;
        	edition.Name = name;
            edition.Release_Date__c = releaseDate;
            edition.Active__c = active;
            insert edition;
        }
        return book.Id;
    }
    
    @HttpDelete
    global static String deleteBook() {
        RestRequest request = RestContext.request;
        String bookID = request.requestURI.substring(request.requestURI.lastIndexOf('Book/')+5);
        Book__c book = [SELECT Id FROM Book__c WHERE Id = :bookID];
        delete book;
        return 'Record deleted';
    }    
}