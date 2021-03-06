package r3cloud;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.googlecode.objectify.Key;

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
		}else if(changedItem.equalsIgnoreCase("keywordss")){
			String[] keywordsz = req.getParameterValues("keyword");
			Paper.setKeywordsByID(paperID, keywordsz);
		}else if(changedItem.equalsIgnoreCase("authors")){
			String[] authorsAccounts = req.getParameterValues("authorAccount");
			ArrayList<Key<Author>> authorsKeys = Author.getAuthorsKeysByAccount(authorsAccounts);
			Paper.setAuthorsByID(paperID, authorsKeys);
		}else if(changedItem.equalsIgnoreCase("content")){
			BlobstoreService blobstoreService =  BlobstoreServiceFactory.getBlobstoreService();
			Map<String, BlobKey> blobs = blobstoreService.getUploadedBlobs(req);
			BlobKey blobKey = blobs.get("myFile");
			System.out.print(blobKey+">>>>>>>>>>>>>>>>>>>>");
			boolean isText = (req.getParameter("text").equals("true"));
	        String url = req.getParameter("insertedURL");
	        Paper.setContentByID(paperID, isText, url, blobKey);
		}
		
		
		if(changedItem.equalsIgnoreCase("delete")){
			resp.sendRedirect("/viewAllPapers.jsp");
		}else{
			System.out.println(changedItem+"***");
		resp.sendRedirect("/viewPaper.jsp?id=" + paperID);
		}
	}
}
