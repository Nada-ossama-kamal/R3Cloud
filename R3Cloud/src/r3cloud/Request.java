package r3cloud;

import static r3cloud.OfyService.ofy;

import java.util.Collections;
import java.util.Date;
import java.util.List;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

@Entity
public class Request implements Comparable<Request>{
	@Id
	Long id;
	@Index
	Date request_date;
	@Index
	Key<User> author;
	@Index
	String text;
	public Request(){
		
	}
	public Request(Key<User> author, String text, Date request_date){
		this.author = author;
		this.text = text;
		this.request_date = request_date;
	}
	public static Request createRequest(Key<User> author, Date date, String text) {
		Request req = new Request (author, text, date);
		ofy().save().entity(req).now();
		return req;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Date getRequest_date() {
		return request_date;
	}
	public void setRequest_date(Date request_date) {
		this.request_date = request_date;
	}
	public Key<User> getAuthor() {
		return author;
	}
	public void setAuthor(Key<User> author) {
		this.author = author;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public static List<Request> loadRequests(){
		List<Request> requests = ofy().load().type(Request.class).list();
		Collections.sort(requests);
		return requests;
	}
	public static Request getRequestById(long id){
		r3cloud.Request req = ofy().load().type(r3cloud.Request.class).id(id).get();
		return req;
	}
	public static Key<r3cloud.Request> getRequestKey(long id){
		Key<r3cloud.Request> requestKey = Key.create(r3cloud.Request.class, id);
		return requestKey ;
	}
	public int compareTo(Request o) {
		// TODO Auto-generated method stub
		if (this.getRequest_date().after(o.getRequest_date()))
			return -1;
		else 
			return 1;
	}
	public static Request loadUserById(long id){		
		Request req = ofy().load().type(r3cloud.Request.class).id(id).get();
		return req;
	}
}
