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
<%@ page import="r3cloud.Rating" %>





<%
    BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>View Paper</title>


<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
<script src="Js/jquery.rating.js"></script>
<script src="Js/jquery.MetaData.js"></script>
<script src="Js/jquery.form.js"></script>
<link rel="stylesheet" type="text/css" href="stylesheets/jquery.rating.css">
<script>

$(function(){
	var firstRun=true;

var str="<%=Paper.loadPaperById(Long.parseLong(request.getParameter("id"))).getUrl()+"" %>";
//alert(str);
$('.star').rating({ callback: function(value, link){ 
	if(firstRun==false){
	$.ajax({
		url : "rating?username="+ "<%=((r3cloud.User)session.getAttribute("user")).getUsername()%>"+"&paperId="+<%=request.getParameter("id")%>+"&rating="+value,
		type : "GET",
		success : function(data) {
			
			var split=data.split("&"); 
			document.getElementById("votes").innerHTML=split[1];
			document.getElementById("ActualRating").innerHTML=split[0];
			
		

		}
	});}
	
} });

$('.star').rating('select',"<%=Math.round((Rating.getByPaperAndUser(Long.parseLong(request.getParameter("id")), ((r3cloud.User)session.getAttribute("user")).getUsername())!=null)? Rating.getByPaperAndUser(Long.parseLong(request.getParameter("id")), ((r3cloud.User)session.getAttribute("user")).getUsername()).getScore()*2:0)/2.0f+""%>");


firstRun=false;
}); 
</script>

</head>
<body>

<%
		r3cloud.User user = ((r3cloud.User)session.getAttribute("user"));
		
		if (user == null) {
	%>
	<p>
		Hello! <a
			href="/login.jsp">Sign in</a>
	</p>
	<%
		} else {

			pageContext.setAttribute("user", user);
			String id = request.getParameter("id");
			Long idL = Long.parseLong(id);
			Paper paper = Paper.loadPaperById(idL);
			
			pageContext.setAttribute("paper", paper);
			List<Key<Author>> authorKeys = paper.getAuthors();
		    List<Author> authors = Author.getAuthorsByKey(authorKeys);
		    String[] keywords = paper.getKeywords();
		    
		    String topic = paper.getTopic();
			if(topic == null){
				topic="none";
			}else if(topic.equalsIgnoreCase("Biology")){
				topic = "biology";
			}else if(topic.equalsIgnoreCase("Chemistry")){
				topic = "chemistry";
			}else if(topic.equalsIgnoreCase("Physics")){
				topic = "physics";
			}else if(topic.equalsIgnoreCase("Mathematics")){
				topic = "maths";
			}else if(topic.equalsIgnoreCase("Computer Science")){
				topic = "cs";
			}else{
				topic = "none";
			}
		    
		    int abstractSpan = 3;
		    if(authors.size()>3){
		    	abstractSpan += authors.size();
		    }else{
		    	abstractSpan += 3;
		    }
			
	%>
	<p>
		Hello, ${fn:escapeXml(user.username)}! (You can <a
			href="">sign
			out</a>.)
	</p>
	<div>
	<table border="0" width="100%">
  
  <tr> 
  <td colspan="2"><%= paper.getTitle()%></td>
  </tr>
    <tr> 
  <td colspan="2"><a href="/viewAllPapers.jsp?topic=<%=topic%>"><%=paper.getTopic() %></a></td>
  </tr>
 <tr>
 	<td rowspan="<%= abstractSpan %>" width="5%">&nbsp;&nbsp;</td>
 	
    <td rowspan="<%= abstractSpan %>" width="45%"><textarea spellcheck="true" readonly="readonly" id="abstract" name="abstract" rows="<%= abstractSpan %>" cols="70"> <%= paper.getAbstractPaper()%></textarea></td>
    <td rowspan="<%= abstractSpan %>" width="5%">&nbsp;&nbsp;</td>  
	<%String authorDisplayName = authors.get(0).getLastName() +", "+ authors.get(0).getFirstName(); %>
    <td width="20%"><a href=""><%=authorDisplayName%></a></td> 
    <td width="25%">Created by: <a href=""><%=paper.getOwner().getName()%></a></td>
 
  </tr>
  <tr>
  	
  	<%if(authors.size()>1){
  		authorDisplayName = authors.get(1).getLastName() +", "+ authors.get(1).getFirstName(); 
  	%>
    <td><a href=""><%=authorDisplayName%></a></td>
    <%}else{%>
    <td>&nbsp;&nbsp;</td>
    <%}%>
    <td>Created on: <%=paper.getDate()%></td>
  
  </tr>
     <tr>
    
    <%if(authors.size()>2){
        authorDisplayName = authors.get(2).getLastName() +", "+ authors.get(2).getFirstName();
    %>
    <td><a href=""><%=authorDisplayName%></a></td>
    <%}else{%>
    <td></td>
    <%}%>
    <td>Last Modified on: <%=paper.getLastUpdatedDate() %></td>
  
  </tr>
  
  <%
  if(authors.size()>3){
	   
	  for(int i=3; i<authors.size(); i++){
		  %>
		  <tr>
		  <%
		  authorDisplayName = authors.get(i).getLastName() +", "+ authors.get(i).getFirstName();
		  %><td><a href=""><%=authorDisplayName%></a></td>
		  </tr>
		  <% 
	  }
  }
  %>
  <tr>

    <td nowrap></td>
  
  </tr>
 <tr>
    <td nowrap></td>
  </tr>
 <tr>
  	<td >
    <div id="textDiv">
 		<%
		
		if(paper.isText()){
			pageContext.setAttribute("paper", paper.getContent().getKeyString());
		%>
		
		<form action="/serve" method="get">
      	<input type="submit" value="View Paper" />
		<input type="hidden" name="blob-key" value="<%= paper.getContent().getKeyString()%>"/>
   	    </form>
	    </div>
	
	 <div id="urlDiv">
		<%
		}else{
			%>
			<a href="<%= paper.getUrl() %>">Go to paper</a>
		<%
		}
		%>
 	 </div>
    </td>
    <td>
    
    <span id="ratingStars">
        <input name="starRating" type="radio" value="0.5" class="star {split:2}"/>
		<input name="starRating" type="radio" value="1.0" class="star  {split:2}"/> 
		<input name="starRating" type="radio" value="1.5" class="star  {split:2}"/>
		<input name="starRating" type="radio" value="2.0" class="star {split:2}"/>
		<input name="starRating" type="radio" value="2.5" class="star  {split:2}"/> 
		<input name="starRating" type="radio" value="3.0" class="star {split:2}"/>
		<input name="starRating" type="radio" value="3.5" class="star {split:2}"/> 
		<input name="starRating" type="radio" value="4.0" class="star  {split:2}"/> 
		<input name="starRating" type="radio" value="4.5" class="star {split:2}"/>
		<input name="starRating" type="radio" value="5.0"class="star  {split:2}"/> 
		</span>
		<p id="ratingScore">Rating: <strong id="ActualRating"><%=Paper.loadPaperById(Long.parseLong(request.getParameter("id"))).getRating()%></strong> / 5 stars - <strong id="votes">	<%=Paper.getVotesNoById(Long.parseLong(request.getParameter("id")))%></strong> vote(s).</p>
	
    </td>
  
  </tr>
  <tr>
  <td></td>
  <td colspan="4">
	  <table border="0">
	
	
		<tr>
		<%for(String keyword:keywords){%>
		
	    <td bgcolor="#F0F8FF"><%=keyword%></td>
	   
	    <%}%>
	  	 </tr>
	  
	</table>
  </td>
  </tr>
  
  <%if( paper.getOwner().equals( Key.create( r3cloud.User.class, user.getUsername() ) ) ){%>
  		<tr>
		<td><a href="viewPaper.jsp?id=<%=paper.getId()%>">Edit Paper</a></td>
		 </tr>
	<%
	}
	%>
 

</table>


	</div>
	
	<%
}
	%>

</body>
</html>
