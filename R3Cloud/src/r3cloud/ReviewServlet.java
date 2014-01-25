package r3cloud;

import java.io.IOException;



import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.Key;

public class ReviewServlet extends HttpServlet{
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        
		 	String username = req.getParameter("userKey");
			Key<r3cloud.User> userKey = r3cloud.User.getUserKey(username);
	        String text = req.getParameter("text");
	        long paperId = Long.parseLong(req.getParameter("paperKey"));
			Key<r3cloud.Paper> paperKey = r3cloud.Paper.getPaperKey(paperId);
	      
	        
			Review review = Review.createReview(userKey, paperKey, text);               
	       
	        resp.sendRedirect("/viewPaperUser.jsp?id="+paperId);
    }
}
