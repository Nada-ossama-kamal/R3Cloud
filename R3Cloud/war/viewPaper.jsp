<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%> --%>
    
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.googlecode.objectify.Key"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="r3cloud.Paper" %>
<%@ page import="r3cloud.Author" %>


<%
    BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>View and Edit Paper</title>
</head>
<body>

	<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		/* BlobstoreService blobstoreService =  BlobstoreServiceFactory.getBlobstoreService(); */
		

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
			String id = request.getParameter("id");
			Long idL = Long.parseLong(id);
			Paper paper = Paper.loadPaperById(idL);
			
			pageContext.setAttribute("paper", paper);
	%>
	<p>
		Hello, ${fn:escapeXml(user.nickname)}! (You can <a
			href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign
			out</a>.)
	</p>
	
		<div>
		<fieldset>
  		<legend>Paper title:</legend>
	    <!-- <label for="titleLabel">Paper title</label> -->
	    <input type="text" name="title" value="<%= paper.getTitle() %>" disabled><br> 
	    </fieldset>
	    </div>
		
		<div>
		<fieldset>
  		<legend>Paper abstract:</legend>
<!-- 	    <label for="abstractLabel">Paper abstract</label><br>  -->
	    <textarea id="abstract" name="abstract" rows="10" cols="70" disabled> <%= paper.getAbstractPaper() %></textarea> <br>
	    </fieldset>
	    </div>
	
 		<%
		
		if(paper.isText()){
			pageContext.setAttribute("paper", paper.getContent());
		%>
		<form action="/serve" method="post">
		<input type="text" name="insertedURL" value="<%= paper.getUrl() %>"><br>
      <div><input type="submit" value="Download paper" /></div>

   	  </form>
		
		<%--       <input type="hidden" name="blob-key" value="${fn:escapeXml(paper)}"/> --%>
		<%
		}else{
			%>
			<label for="Url">Paper url</label>
		  	<input type="text" name="insertedURL" value="<%= paper.getUrl() %>" disabled><br>
		<%
		}
		%>
 	
 		<div>
 		<fieldset>
 		<legend>Keywords:</legend>
<!--  		<label for="Keyword">Keywords:</label> -->
 		<table>
		<tr>
		<%
		String[] keywords = paper.getKeywords();
		if(keywords.length == 0){
		%>
			<p><i>No keywords were specified</i></p>
		<%
		}
		else{
			for(String keyword : keywords){
				pageContext.setAttribute("keyword", keyword);
			%>	
	<%-- 				<td>${fn:escapeXml(keyword)}</td> --%>
					<td><input type="text" name="topic" value="<%= keyword%>" disabled></td>
			<%	
			}
		}
		%>
		</tr>
		</table>
		</fieldset>
		</div>
		
		
		<fieldset>
 		<legend>Paper Topic:</legend>
<!-- 		<label for="topic">Paper Topic</label> -->
	
    	<form action="/editpaper" method="post">
    	<span id="topicDiv">
    	<input type="submit" name= "saveTopic" id="saveTopic" value="save" onclick="saveTopic()" disabled/>&nbsp;&nbsp;&nbsp;&nbsp;
	    <input type="text" id= "topicValue" name="topic" value="<%= paper.getTopic() %>" disabled>&nbsp;&nbsp;&nbsp;&nbsp;
	    
	    <input type="hidden" name="changed" value="topic"/>
	    <input type="hidden" name="paperID" value="<%= paper.getId() %>"/>
	    </span>
	    </form>
	    <input type="button" name= "editTopic" id="editTopic"  value="edit" onclick="editTopic()"/><br>
	    </fieldset>
	    
	    
	    <div>
	    <fieldset>
 		<legend>Authors:</legend>
<!-- 	    <label for="Author">Authors:</label> -->
	    <table>
		<%
		List<Key<Author>> authorKeys = paper.getAuthors();
	    List<Author> authors = Author.getAuthorsByKey(authorKeys);
		
		if(authors.size() == 0){
		%>
			<p><i>No authors were specified</i></p>
		<%
		}
		else{
			for(Author author : authors){
				pageContext.setAttribute("author", author);
				
			%>	<tr>
				<td><input type="text" name="authorTitle" value="<%= author.getTitle()%>" disabled></td>
				<td><input type="text" name="authorFName" value="<%= author.getFirstName()%>" disabled></td>
				<td><input type="text" name="authorLName" value="<%= author.getLastName()%>" disabled></td>
				<td><input type="text" name="authorAff" value="<%= author.getAffiliation()%>" disabled></td>
				</tr>
			<% 
			}
		}
		%>
		</table>
		</fieldset>
		</div>
	
	<%
		}
	%>

</body>

<SCRIPT language="javascript">
function editTopic() {
	
	var elem = document.getElementById('saveTopic');
	elem.disabled = false;
	var elem = document.getElementById('editTopic');
	elem.disabled = true;
	var elem2 = document.getElementById('topicValue');
	var parent = elem2.parentNode
	parent.removeChild(elem2);
	

    var element2 = document.createElement("select");
    element2.name = "topic";
    
    var option1 = document.createElement("option");
    option1.innerHTML = "Biology";
    option1.value = "Biology";
    element2.add(option1, null);
    
    var option2 = document.createElement("option");
    option2.innerHTML = "Chemistry";
    option2.value = "Chemistry";
    element2.add(option2, null);
    
    var option3 = document.createElement("option");
    option3.innerHTML = "Physics";
    option3.value = "Physics";
    element2.add(option3, null);
    
    var option4 = document.createElement("option");
    option4.innerHTML = "Mathematics";
    option4.value = "Mathematics";
    element2.add(option4, null);
    
    var option5 = document.createElement("option");
    option5.innerHTML = "Computer Science";
    option5.value = "Computer Science";
    element2.add(option5, null);
    
    parent.appendChild(element2);
	
	
	
   
}
</SCRIPT>
</html>