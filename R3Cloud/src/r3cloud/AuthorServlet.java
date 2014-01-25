package r3cloud;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.Key;

public class AuthorServlet extends HttpServlet{
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
		
		//get information from the form about the new user to be created
	    String username = req.getParameter("username");
	    String email = req.getParameter("email");
	    String password = req.getParameter("password");
	    r3cloud.User newUser = r3cloud.User.createUser(username, password, email);
	
	    Key<r3cloud.User> userKey = Key.create (r3cloud.User.class, newUser.username);
	    
	    //get information from the form about the new author to be registered
	    int type = Integer.parseInt(req.getParameter("normal_user"));
	    if (type == 0){
		    String firstName = req.getParameter("first_name");
		    String lastName = req.getParameter("last_name");
		    String title = req.getParameter("title");
		    String affiliation = req.getParameter("affiliation");
		    Author author = Author.createAuthor(firstName, lastName, title, affiliation, userKey);
	    }
	   
	    resp.sendRedirect("/login.jsp");
	}
}
