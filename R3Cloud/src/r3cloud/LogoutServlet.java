package r3cloud;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LogoutServlet extends HttpServlet{
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
		
		//get information from the form about the new user to be created
		HttpSession session = req.getSession(false);
		if(session != null)
		    session.invalidate();
	   
	    resp.sendRedirect("/index.jsp");
	    
	}

}
