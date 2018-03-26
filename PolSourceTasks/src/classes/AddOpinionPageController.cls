public with sharing class AddOpinionPageController {

    public Opinion__c opinion { get; set; }
    public Book__c book { get; set; }
    public Contact con { get; set; }
    public ApexPages.StandardController standardController;

    public AddOpinionPageController(ApexPages.StandardController controller) {
        this.opinion = new Opinion__c();
        this.book = new Book__c();
        this.con = new Contact();
        this.standardController = controller;
    }

    public PageReference save() {
        Id retId;
        try {
            retId = createRecord(opinion, book, con);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        return new PageReference('/' + retId);
    }

    @TestVisible private Id createRecord(Opinion__c op, Book__c bk, Contact cn) {
        List<Book__c> bookIds = [SELECT Id FROM Book__c WHERE ISBN__c = :bk.ISBN__c];
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Email = :cn.Email];

        if (bk.ISBN__c < 0) {
            throw new MyException(ProjectUtils.NEGATIVE_ISBN);
        }
        if (bookIds.size() == 0) {
            throw new MyException(ProjectUtils.ERROR_NO_ROWS_ISBN);
        }
        if (contacts.size() == 0) {
            cn.LastName = ProjectUtils.NEW_CONTACT_NAME;
            insert cn;
        }
        op.Book__c = bookIds.get(0).Id;
        op.Contact__c = contacts.get(0).Id;
        insert op;
        return op.Id;
    }

}