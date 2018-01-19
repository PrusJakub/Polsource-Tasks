public class MessageWrapper implements Wrapper {

    String message {get; set;}

    public MessageWrapper(String message){
        this.message = message;
    }

    public Wrapper getObject(){
        return this;
    }
}