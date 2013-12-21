package r3cloud;

import static com.googlecode.objectify.ObjectifyService.ofy;

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

public class AutoCompleteServlet extends HttpServlet {
	// private BlobstoreService blobstoreService =
	// BlobstoreServiceFactory.getBlobstoreService();

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

	}

	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		String searchTerm = req.getParameter("name");
		

		QueryResultIterable<Paper> listPapers = ofy().load().type(Paper.class)
				.order("title").iterable();
		
		ArrayList<String> listTitles = new ArrayList<String>();
		ArrayList<String> listKeywords = new ArrayList<String>();
		for (Paper p : listPapers) {
			listTitles.add(p.getTitle());
			if (!(p.getKeywords() == null)) {
				for (String k : p.getKeywords())
					if (!listKeywords.contains(k))
						listKeywords.add(k);
			}
		}
		StringBuilder sb = new StringBuilder();
		
		boolean found = false;
		// change number to specify number of items in autocomplete
		int noOfItemsToDisplay = 7;
		sb.append("[");
		for (String str : listTitles) {
			if (noOfItemsToDisplay == 0)
				break;
			if (str.toLowerCase().trim().contains(searchTerm.toLowerCase())) {
				found = true;

				sb.append("{ \"label\": ");
				sb.append("\"");
				sb.append(str);
				sb.append("\"");
				sb.append(", \"category\": \"Papers\" }");
				sb.append(",");
				noOfItemsToDisplay--;

			}

		}

		for (String str : listKeywords) {
			if (noOfItemsToDisplay == 0)
				break;
			if (str.toLowerCase().trim().contains(searchTerm.toLowerCase())) {
				found = true;

				sb.append("{ \"label\": ");
				sb.append("\"");
				sb.append(str);
				sb.append("\"");
				sb.append(", \"category\": \"Keywords\" }");
				sb.append(",");
				noOfItemsToDisplay--;
			}
		}
		if (found)
			sb.deleteCharAt(sb.length() - 1);

		sb.append("]");

		res.setContentType("application/json");
		res.setCharacterEncoding("UTF-8");
		res.getWriter().write(sb.toString());

	}

}
