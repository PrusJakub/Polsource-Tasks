public with sharing class NewBookController {
    
    public Book__c book {get; set;}
    public Edition__c edition {get; set;}
    public ApexPages.StandardController stController;
    private static final String NOT_UNIQUE_MESSAGE = 'Insert failed. First exception on row 0; first error: DUPLICATE_VALUE, duplicate value found: <unknown> duplicates value on record with id: <unknown>: []';
    
    public NewBookController(ApexPages.StandardController controller) {
    	this.book = new Book__c();
        this.edition = new Edition__c();
        this.stController = controller;
    }
    
    public PageReference save(){       
		Id retId = null;
        try{ 
			retId = createRecord(book, edition);            
		}catch(Exception e){
            if(e.getMessage() == NOT_UNIQUE_MESSAGE){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'ISBN is not unique'));
            }else{
            ApexPages.addMessages(e);
            }
            return null;
        }                 
        PageReference result = new PageReference('/' + retId);
	    return result;       
    }
    
    public PageReference saveAndNew() {
        try{
            createRecord(book, edition);
        }catch(Exception e){
            if(e.getMessage() == NOT_UNIQUE_MESSAGE){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'ISBN is not unique'));
            }else{
            ApexPages.addMessages(e);
            }
            return null;
        } 
		PageReference result = Page.NewBook;
        result.setRedirect(true);
        return result;
    }
    
    private static Id createRecord(Book__c book, Edition__c edition) {
		if(edition.Price__c < 0){
        	throw new MyException('Price cannot be negative');
        }
		if(book.ISBN__c < 0){
        	throw new MyException('ISBN cannot be negative');
        }
        if(book.PublicationDate__c != null && book.PublicationDate__c > edition.Release_Date__c){
            throw new MyException('Release date cannot be earlier than publication date');
        }
        insert book;
        edition.Book__c = book.Id;
        edition.Active__c = true;            
		insert edition;
        return book.Id;
    }
}