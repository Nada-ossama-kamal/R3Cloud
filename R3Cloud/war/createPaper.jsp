<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%> --%>


<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create Paper</title>
</head>


<body>
	<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		BlobstoreService blobstoreService =  BlobstoreServiceFactory.getBlobstoreService();
		

		if (user == null) {
	%>
	<p>
		Hello! <a
			href="<%=userService.createLoginURL(request.getRequestURI())%>">Sign
			in</a>
	</p>
	<%
		} else {

			pageContext.setAttribute("user", user);
	%>
	<p>
		Hello, ${fn:escapeXml(user.nickname)}! (You can <a
			href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign
			out</a>.)
	</p>




	<form action="<%= blobstoreService.createUploadUrl("/createPaper") %>" method="post" enctype="multipart/form-data" name="createPaperForm">
	    <label for="titleLabel">Paper title</label>
	    <input type="text" name="title"><br> 
			 
	    <label for="abstractLabel">Paper abstract</label><br> 
	    <textarea id="abstract" name="abstract" rows="10" cols="70"></textarea> <br>
	
		<label for="url">Insert paper url</label>
	  	<input type="radio" name="text" id="url" value="false"><br>
	  	<label for="text">Upload paper text</label>
	  	<input type="radio" name="text" id="text" value="true"><br>
	  	
	  	<label for="insertUrl">Paper url</label>
	  	<input type="text" name="insertedURL"><br> 
	  	
	  	<label for="chooseFile">Specify file(s) to upload</label>
		<input type="file" name="myFile"><br>
		
		<label for="addKeyword">Add Keyword</label>
		<INPUT type="button" value="Add Keyword" onclick="add()"/>
  		<span id="addKeyWords" name="keywords" >&nbsp;</span><br>


		<input type="submit" value="Create paper" />
	</form>
	
	<%-- <form action="<%= blobstoreService.createUploadUrl("/upload") %>" method="post" enctype="multipart/form-data">
        <input type="file" name="myFile">
        <input type="submit" value="Submit">
    </form> --%>
    

	<%
		}
	%>
</body>


<SCRIPT language="javascript">
function add() {
 
    //Create an input type dynamically.
    var element = document.createElement("input");
 
    //Assign different attributes to the element.
    element.setAttribute("type", "text");
    element.setAttribute("value", "keyword");
    element.setAttribute("name", "keyword");
 
 
    var addKeyWords = document.getElementById("addKeyWords");
 
    //Append the element in page (in span).
    addKeyWords.appendChild(element);
 
}
</SCRIPT>
</html>