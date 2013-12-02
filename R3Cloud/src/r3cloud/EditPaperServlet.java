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
		if(changedItem.equalsIgnoreCase("topic")){
			String topic = req.getParameter("topic");
			Paper.setTopicByID(paperID, topic);
		}else if(changedItem.equalsIgnoreCase("title")){
			String title = req.getParameter("title");
			Paper.setTitleByID(paperID, title);
		}else if(changedItem.equalsIgnoreCase("abstract")){
			String abs = req.getParameter("abstract");
			Paper.setAbstractByID(paperID, abs);
		}else if(changedItem.equalsIgnoreCase("delete")){
			Paper.deletePaperByID(paperID);
		}
		
		if(changedItem.equalsIgnoreCase("delete")){
			resp.sendRedirect("/viewAllPapers.jsp");
		}else{
			System.out.println(changedItem+"***");
		resp.sendRedirect("/viewPaper.jsp?id=" + paperID);
		}
	}
}
