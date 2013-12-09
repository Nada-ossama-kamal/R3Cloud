package r3cloud;

import static r3cloud.OfyService.ofy;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

@Entity
public class Author {
	@Id
	Long id;
	String firstName;
	String lastName;
	String title;
	String affiliation;
	@Index
	Key<User> account;

	public Author() {

	}

	public Author(String firstName, String lastName, String title,
			String affiliation, Key<User> account) {
		this.firstName = firstName;
		this.lastName = lastName;
		this.title = title;
		this.affiliation = affiliation;
		this.account = account;
	}

	public static Author createAuthor(String firstName, String lastName, String title,
			String affiliation, Key<User> account) {

		Author author = new Author(firstName, lastName, title, affiliation, account);
		ofy().save().entity(author).now();
		return author;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getAffiliation() {
		return affiliation;
	}

	public void setAffiliation(String affiliation) {
		this.affiliation = affiliation;
	}

	public Long getId() {
		return id;
	}

	public Key<Author> getKey() {
		Key<Author> authorKey = Key.create(Author.class, this.id);
		return authorKey;
	}
	
	public static List<Author> getAuthorsByKey(List<Key<Author>> authorKeys){
		Collection<Author> authorsCollection =  ofy().load().keys(authorKeys).values();
		ArrayList<Author> authors = new ArrayList<Author>(authorsCollection);
		return authors;
		
	}
	
	public static Author getAuthorByUserName(String userName){
		Key<User> authorUserKey = r3cloud.User.getUserKey(userName);
		Author author = ofy().load().type(Author.class).filter("acount",authorUserKey).first().get();
		return author;
	}
	
	public static Author getAuthorByUserAccount(Key<User> account){
	
		Author author = ofy().load().type(Author.class).filter("account",account).first().get();
		return author;
	}
	
	public static ArrayList<Key<Author>> getAuthorsKeysByAccount(String[] authorsAccounts){
		ArrayList<Key<Author>> authorsKeys = new ArrayList<Key<Author>>();
		
		for(String account: authorsAccounts){
			Author author = Author.getAuthorByUserAccount(Key.create (r3cloud.User.class, account));
			if(author != null){
			Key<Author> authorKey = author.getKey();
			authorsKeys.add(authorKey);
			}
		}
		
		return authorsKeys;
		
	}
	
	public String getAccount(){
		return (this.account).getName();
	}
	
	public static List<Author> getAllAuthors(){
		List<Author> allAuthors = ofy().load().type(Author.class).list();
		return allAuthors;
	}
	
	public static List<String> getAllAuthorsAccounts(){
		List<Author> allAuthors = getAllAuthors();
		
		List<String> accounts = new ArrayList<String>();
		for(Author author : allAuthors){
			accounts.add(author.getAccount());
		}
		
		return accounts;
	}
	
	public static String getAllAuthorsAccountsString(){
		List<Author> allAuthors = getAllAuthors();
		
		String accounts = "";
		for(Author author : allAuthors){
			accounts = accounts + author.getAccount() +"#";
		}
		
		return accounts;
	}
	
	
	


}
