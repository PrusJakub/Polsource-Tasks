global class EditionWrapper implements Wrapper {

    public String name { get; set; }
    public Decimal price { get; set; }
    public String cover { get; set; }
    public Date releaseDate { get; set; }
    public Id id { get; set; }
    public Boolean active { get; set; }

    public EditionWrapper(String name, Decimal price, String cover, Date releaseDate, Id id, Boolean active) {
        this.name = name;
        this.price = price;
        this.cover = cover;
        this.releaseDate = releaseDate;
        this.id = id;
        this.active = active;
    }

    public Edition__c getSObject(){
        Edition__c edition = new Edition__c();
        edition.Cover__c = this.cover;
        edition.Price__c = this.price;
        edition.Name = this.name;
        edition.Release_Date__c = this.releaseDate;
        edition.Active__c = this.active;
        return edition;
    }

    public String serialize(){
        return JSON.serialize(this);
    }
}