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
        List<Edition__c> editions = [SELECT Name, Price__c, Cover__c, Release_Date__c FROM Edition__c WHERE Book__c = :book.Id]; 
        if(book.Id == null){
            throw new MyException('There is not any book with this ISBN number');
        }
        ItemWrapper wrapper = new ItemWrapper();
        wrapper.name = book.Name;
        wrapper.title = book.Title__c;
        wrapper.author = book.Author__c;
        for(Integer i = 0; i < editions.size(); i++) {
            ListWrapper lwrapper = new ListWrapper();
            lwrapper.name = editions.get(i).Name;
            lwrapper.price = editions.get(i).Price__c;
            lwrapper.cover = editions.get(i).Cover__c;
            lwrapper.releaseDate = editions.get(i).Release_Date__c;
            wrapper.editions.add(lwrapper);
        }        
        return wrapper;
    }
}