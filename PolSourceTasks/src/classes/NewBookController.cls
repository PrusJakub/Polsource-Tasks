public with sharing class NewBookController {
    
    public Book__c book {get; set;}
    public Edition__c edition {get; set;}
    
    public NewBookController(ApexPages.StandardController controller) {
    	this.book = new Book__c();
        this.edition = new Edition__c();
    }
    
    public PageReference save(){       
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
        PageReference result = new PageReference('/' + book.Id);
	    result.setRedirect(true);
	    return result;       
    }
    
    public PageReference saveAndNew() {
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
		PageReference result = Page.NewBook;     
        return result;
    }
    
    public PageReference cancel() {
        PageReference result = new PageReference('/a05/o');
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