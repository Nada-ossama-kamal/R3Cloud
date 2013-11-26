package r3cloud;

import static r3cloud.OfyService.ofy;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class User {
	@Id
	String id;
	String firstName;

	public User() {

	}
	
	public User(String id, String firstName){
		this.id = id;
		this.firstName = firstName;
	}
	
	public static User createUser(String id, String firstName){
		User user = new User(id, firstName);
		ofy().save().entities(user).now();
		return user;
	}

}
