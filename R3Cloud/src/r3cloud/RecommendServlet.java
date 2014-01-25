package r3cloud;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.Key;


public class RecommendServlet extends HttpServlet{
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        
			String id = req.getParameter("request_id");
			Long reqId = Long.parseLong(id);
			Key<Request> request = Request.getRequestKey(reqId);
			List<Key<Paper>> papers = new ArrayList<Key<Paper>>();
			String username = req.getParameter("user");			
			Key<r3cloud.User> userKey = r3cloud.User.getUserKey(username);
			
			String noOfPapers = req.getParameter("no_of_papers");
			int noOfPps = Integer.parseInt(noOfPapers);
			for  (int i=1 ; i<= noOfPps; i++){
				long paperId = Long.parseLong(req.getParameter("paper"+i));
				Key<r3cloud.Paper> paperKey = r3cloud.Paper.getPaperKey(paperId);
				papers.add(paperKey);
			}
			Recommendation.createRecommendation(userKey, request, papers);             
	       
	        resp.sendRedirect("/viewRequest.jsp?id="+reqId);
			return;
			
    }

}
