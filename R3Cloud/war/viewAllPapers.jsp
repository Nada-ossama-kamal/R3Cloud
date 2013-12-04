<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%> --%>


<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
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
<%@ page import="r3cloud.Paper" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>View all paper</title>
</head>
<body>
	<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();

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
			String topic = request.getParameter("topic");
			if(topic == null){
				topic="All Papers";
			}else if(topic.equalsIgnoreCase("biology")){
				topic = "Biology";
			}else if(topic.equalsIgnoreCase("chemistry")){
				topic = "Chemistry";
			}else if(topic.equalsIgnoreCase("physics")){
				topic = "Physics";
			}else if(topic.equalsIgnoreCase("maths")){
				topic = "Mathematics";
			}else if(topic.equalsIgnoreCase("cs")){
				topic = "Computer Science";
			}else if(topic.equalsIgnoreCase("none")){
				topic = "All Papers";
			}else{
				topic = "All Papers";
			}
	%>
	       <p>
		    Hello, ${fn:escapeXml(user.nickname)}! (You can <a
			href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign out</a>.)
	        </p>
	        
	        <div>
	        <fieldset>
	        <legend><label>Topics:</label></legend>
	        <a href="/viewAllPapers.jsp?topic=biology">Biology</a>
	        <a href="/viewAllPapers.jsp?topic=chemistry">Chemistry</a>
	        <a href="/viewAllPapers.jsp?topic=physics">Physics</a>
	        <a href="/viewAllPapers.jsp?topic=maths">Mathematics</a>
	        <a href="/viewAllPapers.jsp?topic=cs">Computer Science</a>
	        <a href="/viewAllPapers.jsp">All Papers</a>
	        </fieldset>
	        </div>

		<div>
		<%
		if(topic.equals("Err")){
		%>
			<p><i>This topic does not exist !!</i></p>
		   <% 
		}else{
			%>
			
			<fieldset>
	 		<%
			List<Paper> papers;
			if(topic.equals("All Papers")){
				papers = Paper.loadAll();
				%><legend><label>All Papers: </label></legend><%
			}else{
				papers = Paper.loadTopic(topic);
				pageContext.setAttribute("topic", topic);
				
				%><legend><label>${fn:escapeXml(topic)} Papers: </label></legend><%
			}
			
		  	if(papers.size()==0){
		  		%>
		  		<p><i>No papers to display !!</i></p>
		  		<%
		  	}else{
		  			%>
		  		   <table>
		  		   <%
			     for(Paper paper : papers) {
				    Long paperId = paper.getId();
					pageContext.setAttribute("id", paperId);
					pageContext.setAttribute("title", paper.getTitle());
			 		 %>
					<tr>
					<td><a href="/viewPaper.jsp?id=<%=paper.getId()%>">${fn:escapeXml(title)}</a></td>
					</tr>
					</br>
					</table>
		<%
					}
		  	}
		%>
	 	</fieldset>
	 	<%
				
		}
	 	%>
		</div>
	<%
	} //end else not signed in
	%>
</body>

<SCRIPT language="javascript">
function loadPaperTopic(topic){
	var elem = document.getElementById('saveTitle');
	elem.disabled = false;
	var elem = document.getElementById('editTitle');
	elem.disabled = true;
	var elem = document.getElementById('title');
	elem.disabled = false;
	List<Paper> papers = Paper.
	
};



</SCRIPT>
</html>