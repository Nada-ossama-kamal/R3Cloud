package r3cloud;


import static r3cloud.OfyService.ofy;
import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.Key;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobInfo;
import com.google.appengine.api.blobstore.BlobInfoFactory;
import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.datastore.QueryResultIterable;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.appengine.labs.repackaged.org.json.JSONException;
import com.googlecode.objectify.Key;

public class RatingServlet extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		ofy().clear();
		String username = req.getParameter("username");
		long paperId = Long.parseLong(req.getParameter("paperId"));
		double rating = Double.parseDouble(((req
				.getParameter("rating").equals("undefined")) ? "0" : req
				.getParameter("rating")));
		if (rating != 0)
			r3cloud.Paper.addRatingById(paperId, username, rating);
		else
			r3cloud.Paper.deleteRatingById(paperId, username);

		// res.setContentType("application/json");
		// res.setCharacterEncoding("UTF-8");
		ofy().clear();
		res.getWriter().write(
				Math.round(r3cloud.Paper.loadPaperById(paperId).rating * 2)
						/ 2.0f + "&"
						+ r3cloud.Rating.getByPaper(paperId).size());

	

	}
}
