public with sharing class NewBookController {
    
    public Book__c book {get; set;}
    public Edition__c edition {get; set;}
    
    public NewBookController(ApexPages.StandardController controller) {
    	this.book = new Book__c();
        this.edition = new Edition__c();
    }
    
    public void save(){                   
        PageReference result = new PageReference('/' + book.Id);
	    result.setRedirect(true);
	    createRecord(book, edition, result);
    }
    
    public void saveAndNew() {        
		PageReference result = Page.NewBook;  
        createRecord(book, edition, result);           
    }
    
    public PageReference cancel() {
        PageReference result = new PageReference('/a05/o');
        return result;
    }
    
    private static PageReference createRecord(Book__c book, Edition__c edition, PageReference result){
         try{            
            if(!isISBNUnique(book)){
                throw new MyException('ISBN is not unique');
            }
            insert book;
            edition.Book__c = book.Id;
            edition.Active__c = true;
       		insert edition;
        }catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        } 
        return result;
    }
    
    private static Boolean isISBNUnique(Book__c book){
        List<Book__c> books = [SELECT Id, ISBN__c FROM Book__c WHERE ISBN__c =: book.ISBN__c];
        if(books.size() == 0){
            return true;
        }
        else {
            return false;
        }
    }
}