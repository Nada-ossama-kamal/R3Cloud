package r3cloud;

import static r3cloud.OfyService.ofy;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.Key;

public class UpdateProfileServlet extends HttpServlet{
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
 
		req.getSession().setAttribute("update_req",1);
		String password = "";
		if (req.getParameter("new_pass") != null)
			password = req.getParameter("new_pass");
		String email = req.getParameter("new_email");
		String affiliation = req.getParameter("new_affiliation");
		String title = req.getParameter("new_title");
		String check_pass = req.getParameter("current_pass");
		String username = req.getParameter("username");
		Key<r3cloud.User> userKey = r3cloud.User.getUserKey(username);
		r3cloud.User user = r3cloud.User.getUserByKey(userKey);
		Author auth = Author.getAuthorByUserAccount(User.getUserKey(user.getUsername()));
		if (user.getPassword().equals(check_pass)){
			
			user.setEmail(email);
			if (!password.equals(""))			
				user.setPassword(password);
			ofy().save().entity(user).now();
			auth.setAffiliation(affiliation);
			auth.setTitle(title);
			auth.setAccount(userKey);
			ofy().save().entity(auth).now();
			req.getSession().setAttribute("message", "Changes successfully recorded!");
			req.getSession().setAttribute("user", user);
		}
		else{
			req.getSession().setAttribute("message", "Invalid input for current password! Profile not updated");

		}
 
        resp.sendRedirect("/myProfile.jsp");

    }
}
