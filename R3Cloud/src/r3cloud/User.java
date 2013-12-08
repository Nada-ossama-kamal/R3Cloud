package r3cloud;

import static r3cloud.OfyService.ofy;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
@Entity
public class User implements Serializable{
	@Id
	String username;
	String password;
	String email;
	int role;

	public User() {

	}
	
	public User(String username, String password, String email){
		this.username = username;
		this.password = password;
		this.email = email;
	}
	
		public static User createUser(String username, String password, String email){
		User user = new User(username, password, email);
		user.setRole(1);
		//ofy().save().entities(user).now();
		ofy().save().entity(user).now();
		return user;
	}
	
	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public int getRole() {
		return role;
	}

	public void setRole(int role) {
		this.role = role;
	}
	//public void
	public static r3cloud.User loadUserByUsername(String username){		
		r3cloud.User user = ofy().load().type(r3cloud.User.class).id(username).get();
		return user;
	}
	public static r3cloud.User getUserByKey(Key<User> userKey){
		r3cloud.User user = ofy().load().key(userKey).getValue();
		return user;
	}
	public static Key<r3cloud.User> getUserKey(String username){
		Key<r3cloud.User> userKey = Key.create(r3cloud.User.class, username);
		return userKey ;
	}
}
