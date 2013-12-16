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

<style type="text/css">

.pg-normal { 
color: #000000; 
font-size: 15px; 
cursor: pointer; 
background: #00BFFF; 
padding: 2px 4px 2px 4px; 
}

.pg-selected { 
color: #fff; 
font-size: 15px; 
background: #000000; 
padding: 2px 4px 2px 4px; 
}

table.yui { 
font-family:arial;  
border: none;
font-size:small; 
}

table.yui td { 
padding: 5px; 
/* border-right: solid 1px #7f7f7f;  */
}

table.yui .even { 
background-color: #EEE8AC; 
}

table.yui .odd { 
background-color: #F9FAD0; 
}

table.yui th { 
border: 1px solid #7f7f7f; 
padding: 5px; 
height: auto; 
background: #D0B389; 
}

table.yui th a { 
text-decoration: none; 
text-align: center; 
padding-right: 20px; 
font-weight:bold; 
white-space:nowrap; 
}

table.yui tfoot td { 
border-top: 1px solid #7f7f7f; 
background-color:#E1ECF9; 
}

table.yui thead td { 
vertical-align:middle; 
background-color:#E1ECF9; 
border:none; 
}

table.yui thead .tableHeader { 
font-size:larger; 
font-weight:bold; 
}

table.yui thead .filter { 
text-align:right; 
}

table.yui tfoot { 
background-color:#E1ECF9; 
text-align:center; 
}

table.yui .tablesorterPager { 
padding: 10px 0 10px 0; 
}

table.yui .tablesorterPager span { 
padding: 0 5px 0 5px; 
}

table.yui .tablesorterPager input.prev { 
width: auto; 
margin-right: 10px; 
}

table.yui .tablesorterPager input.next { 
width: auto; 
margin-left: 10px; 
}

table.yui .pagedisplay { 
font-size:10pt; 
width: 30px; 
border: 0px; 
background-color: #E1ECF9; 
text-align:center; 
vertical-align:top; 
}
</style>

<script type="text/javascript">

function Pager(tableName, itemsPerPage) {

this.tableName = tableName;

this.itemsPerPage = itemsPerPage;

this.currentPage = 1;

this.pages = 0;

this.inited = false;

this.showRecords = function(from, to) {

var rows = document.getElementById(tableName).rows;

// i starts from 1 to skip table header row

for (var i = 1; i < rows.length; i++) {

if (i < from || i > to)

rows[i].style.display = 'none';

else

rows[i].style.display = '';

}

}

this.showPage = function(pageNumber) {

if (! this.inited) {

alert("not inited");

return;

}

var oldPageAnchor = document.getElementById('pg'+this.currentPage);

oldPageAnchor.className = 'pg-normal';

this.currentPage = pageNumber;

var newPageAnchor = document.getElementById('pg'+this.currentPage);

newPageAnchor.className = 'pg-selected';

var from = (pageNumber - 1) * itemsPerPage + 1;

var to = from + itemsPerPage - 1;

this.showRecords(from, to);

}

this.prev = function() {

if (this.currentPage > 1)

this.showPage(this.currentPage - 1);

}

this.next = function() {

if (this.currentPage < this.pages) {

this.showPage(this.currentPage + 1);

}

}

this.init = function() {

var rows = document.getElementById(tableName).rows;

var records = (rows.length - 1);

this.pages = Math.ceil(records / itemsPerPage);

this.inited = true;

}

this.showPageNav = function(pagerName, positionId) {

if (! this.inited) {

alert("not inited");

return;

}

var element = document.getElementById(positionId);

var pagerHtml = '<span onclick="' + pagerName + '.prev();" class="pg-normal"> Prev </span> ';

for (var page = 1; page <= this.pages; page++)

pagerHtml += '<span id="pg' + page + '" class="pg-normal" onclick="' + pagerName + '.showPage(' + page + ');">' + page + '</span> ';

pagerHtml += '<span onclick="'+pagerName+'.next();" class="pg-normal"> Next </span>';

element.innerHTML = pagerHtml;

}

}

</script>

<title>View all paper</title>
</head>
<body>
	<%
		//UserService userService = UserServiceFactory.getUserService();
		//User user = userService.getCurrentUser();
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
			%>
			<p>
			Hello, ${fn:escapeXml(user.username)}! (You can <a
				href="">sign
				out</a>.)
		    </p>
			<%
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
				%>
				<legend><label>All Papers: </label></legend>
				<%
			}else{
				papers = Paper.loadTopic(topic);
				pageContext.setAttribute("topic", topic);
				
				%>
				<legend><label>${fn:escapeXml(topic)} Papers: </label></legend>
				<%
			}
			
		  	if(papers.size()==0){
		  		%>
		  		<p><i>No papers to display !!</i></p>
		  		<%
		  	}else{
		  			%>
		  		   <table id="tablepaging" class="yui" align="left">
		  		   <thead>
		  		   <tr></tr>
		  		   </thead>
		  		   <tbody>
		  		   <%
			     for(Paper paper : papers) {
				    Long paperId = paper.getId();
					pageContext.setAttribute("id", paperId);
					pageContext.setAttribute("title", paper.getTitle());
			 		 %>
					<tr >
					<td><a href="/viewPaperUser.jsp?id=<%=paper.getId()%>">${fn:escapeXml(title)}</a></td>
					</tr>
					
		<%
					}
		  		   %>
		  		   </tbody>
					</table>
		  		   <% 
		  	}
		%>
	 	</fieldset>
	 	<%
				
		}
	 	%>
		</div>
		
		<div id="pageNavPosition" style="padding-top: 20px" align="center">
		</div>
	<%
	} //end else not signed in
	%>
</body>


<script type="text/javascript">
<!--
var pager = new Pager('tablepaging', 5);
pager.init();
pager.showPageNav('pager', 'pageNavPosition');
pager.showPage(1);
</script>

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