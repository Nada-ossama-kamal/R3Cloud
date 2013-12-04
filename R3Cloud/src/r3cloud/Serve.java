package r3cloud;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobInfo;
import com.google.appengine.api.blobstore.BlobInfoFactory;
import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.Key;


public class Serve extends HttpServlet{
	// private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	 private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
       
    }
	
	
    

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse res)
        throws IOException {
            BlobKey blobKey = new BlobKey(req.getParameter("blob-key"));
            blobstoreService.serve(blobKey, res);

        }
	   
	
	
}
