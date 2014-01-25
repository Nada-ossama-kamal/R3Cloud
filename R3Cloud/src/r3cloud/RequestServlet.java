package r3cloud;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.Key;

public class RequestServlet extends HttpServlet{
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        
		 	String username = req.getParameter("username");
			Key<r3cloud.User> userKey = r3cloud.User.getUserKey(username);
	        String text = req.getParameter("request_text");
	        Date date = new Date();
	        Request.createRequest(userKey, date, text);
	        
	       
	        resp.sendRedirect("/requestPaper.jsp");
	        return;
    }

}
