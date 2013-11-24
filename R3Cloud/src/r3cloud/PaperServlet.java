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
		System.out.print(blobKey);
		
        r3cloud.User r3User = r3cloud.User.createUser(googleUser.getUserId(), googleUser.getNickname());
        String title = req.getParameter("title");
        System.out.println(title+"Title");
        String abstractPaper = req.getParameter("abstract");
        //final Part filePart = request.getPart("file");
        Key<r3cloud.User> userKey = Key.create(r3cloud.User.class, r3User.firstName);
        boolean isText = (req.getParameter("text").equals("true"));
        String url = req.getParameter("insertedURL");
        String[] keywords = req.getParameterValues("keyword");
        for(int i = 0; i<keywords.length; i++){
        	System.out.println(keywords[i]);
        }
      
       Paper paper = Paper.createPaper(title,isText, url, blobKey, abstractPaper, userKey, "Trial", keywords, new ArrayList<Key<Author>>());
     
        
        

        resp.sendRedirect("/viewAllPapers.jsp");
    }

}
