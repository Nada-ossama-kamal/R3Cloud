package r3cloud;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.Key;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
 
import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
 
public class upload extends HttpServlet{
	
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
		BlobstoreService blobstoreService =  BlobstoreServiceFactory.getBlobstoreService();
		Map<String, BlobKey> blobs = blobstoreService.getUploadedBlobs(req);
		BlobKey blobKey = blobs.get("myFile");
		System.out.print(blobKey);
		if (blobKey == null) {
			System.out.print("Error");
		    resp.sendRedirect("/");
		} else {
			System.out.print(blobKey+"hehehrr");
			resp.sendRedirect("/serve?blob-key=" + blobKey.getKeyString());
		}
    }

	

}
