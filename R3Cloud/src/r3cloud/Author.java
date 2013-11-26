package r3cloud;

import static r3cloud.OfyService.ofy;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class Author {
	@Id
	Long id;
	String firstName;
	String lastName;
	String title;
	String affiliation;

	public Author() {

	}

	public Author(String firstName, String lastName, String title,
			String affiliation) {
		this.firstName = firstName;
		this.lastName = lastName;
		this.title = title;
		this.affiliation = affiliation;
	}

	public static Author createAuthor(String firstName, String lastName, String title,
			String affiliation) {

		Author author = new Author(firstName, lastName, title, affiliation);
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

}
