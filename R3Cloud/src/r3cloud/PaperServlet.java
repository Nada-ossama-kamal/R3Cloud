package r3cloud;




import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;









import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.Key;


import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.blobstore.BlobstoreService;

import r3cloud.Paper;

public class PaperServlet extends HttpServlet{
	
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User googleUser = userService.getCurrentUser();
      
        BlobstoreService blobstoreService =  BlobstoreServiceFactory.getBlobstoreService();
		Map<String, BlobKey> blobs = blobstoreService.getUploadedBlobs(req);
		BlobKey blobKey = blobs.get("myFile");
		System.out.print(blobKey+">>>>>>>>>>>>>>>>>>>>");
	
        //r3cloud.User r3User = r3cloud.User.createUser(googleUser.getUserId(), googleUser.getNickname());
        String title = req.getParameter("title");
        String abstractPaper = req.getParameter("abstract");
        //final Part filePart = request.getPart("file");
        //Key<r3cloud.User> userKey = Key.create(r3cloud.User.class, r3User.firstName);
        boolean isText = (req.getParameter("text").equals("true"));
        //boolean isText = false;
        String url = req.getParameter("insertedURL");
        String[] keywords = req.getParameterValues("keyword");
        
    
        
        String topic = req.getParameter("topic");
        String username = req.getParameter("userKey");
       	Key<r3cloud.User> userKey = r3cloud.User.getUserKey(username);
       	String[] authorsAccounts = req.getParameterValues("AuthorAccount");
        //String[] authorTitle = req.getParameterValues("AuthorTitle");
        //String[] fNames = req.getParameterValues("AuthorFirstName");
        //String[] lName = req.getParameterValues("AuthorLastName");
        //String[] affiliation = req.getParameterValues("Affiliation");
        ArrayList<Key<Author>> authors = Author.getAuthorsKeysByAccount(authorsAccounts);
        System.out.println(authors);
        
       Paper paper = Paper.createPaper(title,isText, url, blobKey, abstractPaper, userKey, topic, keywords, authors);
       
        
        

        resp.sendRedirect("/viewAllPapers.jsp");
    }
	
	
//	private static ArrayList<Key<Author>> createAuthors(String[] authorTitle, String[] fNames, String[] lName, String[] affiliation, Key<r3cloud.User> userKey){
//		ArrayList<Key<Author>> authors= new ArrayList<Key<Author>>();
//		
//		for(int i=0; i< authorTitle.length; i++){
//			Author author = Author.createAuthor(fNames[i], lName[i], authorTitle[i], affiliation[i], userKey);
//			authors.add(author.getKey());
//		}
//		
//		return authors;
//	}

}
