package r3cloud;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.googlecode.objectify.Key;

public class LoginServlet extends HttpServlet{
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
		
		//get information from the form about the new user to be created
	    String username = req.getParameter("username");
	    String password = req.getParameter("password");
	    
	    r3cloud.User user = r3cloud.User.loadUserByUsername(username);
	    if (user != null){
	    	if (user.getPassword().equals(password)){
	    		HttpSession session = req.getSession();
	    		session.setAttribute("user", user);
	    		resp.sendRedirect("/viewAllPapers.jsp");
	    	}
	    	else
	    		System.out.println("Invalid password");
	    }
	    else
	    	System.out.println ("no such user");
	    //Key<r3cloud.User> userKey = Key
	   
	    resp.sendRedirect("/index.jsp");
	    
	}
}
