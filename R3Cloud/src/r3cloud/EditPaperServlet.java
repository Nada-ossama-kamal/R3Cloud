package r3cloud;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class EditPaperServlet extends HttpServlet{
	
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
		
		Long paperID = Long.parseLong(req.getParameter("paperID"));
		String changedItem = req.getParameter("changed");
		System.out.println("Edit");
		if(changedItem.equalsIgnoreCase("topic")){
			String topic = req.getParameter("topic");
			Paper.setTopicByID(paperID, topic);
		}
		
		System.out.println("GAT");
		resp.sendRedirect("/viewPaper.jsp?id=" + paperID);
		
	}
}
