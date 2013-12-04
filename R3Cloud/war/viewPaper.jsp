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
	
		<div id="titleDiv">
		<fieldset>
  		<legend><label>Paper title:</label></legend>
  		<form action="/editpaper" method="post">
  		<span id="titleDiv">
	    <!-- <label for="titleLabel">Paper title</label> -->
	    <input type="submit" name= "saveTitle" id="saveTitle" value="save" onclick="saveTitle()" disabled/>&nbsp;&nbsp;&nbsp;&nbsp;
	    <input type="text" name="title" id="title" value="<%= paper.getTitle() %>" disabled>&nbsp;&nbsp;&nbsp;&nbsp;
	    <input type="hidden" name="changed" value="title"/>
	    <input type="hidden" name="paperID" value="<%= paper.getId() %>"/>
	    </span>
	    </form>
	    <input type="button" name= "editTitle" id="editTitle"  value="edit" onclick="editTitle()"/><br>
	    </fieldset>
	    </div>
		
		<div id="abstractDiv">
		<fieldset>
  		<legend><label>Paper abstract:</label></legend>
  		<form action="/editpaper" method="post">
  		<span id="abstractDiv">
<!-- 	    <label for="abstractLabel">Paper abstract</label><br>  -->
		<input type="submit" name= "saveAbstract" id="saveAbstract" value="save" disabled/>&nbsp;&nbsp;&nbsp;&nbsp;
	    <textarea id="abstract" name="abstract" rows="10" cols="70" disabled> <%= paper.getAbstractPaper() %></textarea>
	    	    <input type="hidden" name="changed" value="abstract"/>
	    <input type="hidden" name="paperID" value="<%= paper.getId() %>"/>
	    </span>
	    </form>
	    <input type="button" name= "editAbstract" id="editAbstract"  value="edit" onclick="editAbstract()"/><br>
	    
	    </fieldset>
	    </div>
	    
	    <div id="paperContent">
	    <fieldset>
  		<legend><label>Paper:</label></legend>
	    
	    <div id="textDiv">
 		<%
		
		if(paper.isText()){
			pageContext.setAttribute("paper", paper.getContent().getKeyString());
		%>
		
		<form action="/serve" method="get">
      	<input type="submit" value="View paper" />
		<input type="hidden" name="blob-key" value="${fn:escapeXml(paper)}"/>
   	    </form>
	    </div>
	
	 <div id="urlDiv">
		<%
		}else{
			%>
			<label for="Url">Paper url</label>
		  	<input type="text" name="insertedURL" value="<%= paper.getUrl() %>" disabled><br>
		<%
		}
		%>
 	 </div>
 	 
 	 </fieldset>
 	 </div>
 	 
 	 
 		<div id="keywordsDiv">
 		<fieldset>
 		<legend><label>Keywords Label:</label></legend>
		<%
		String[] keywordz = paper.getKeywords();
		if(keywordz.length == 0){
		%>
			<p><i>No keywords were specified</i></p>
		<%
		}
		else{
			%>
			<form action="/editpaper" method="post">
			<span id="keywordsSpan">
			<%
			int i=0;
			for(String keyword : keywordz){
				//pageContext.setAttribute("keyword", keyword);
				String kwString = "keyword"+i;
				pageContext.setAttribute("kwString", kwString);
				String removeKW = "remove"+i;
				pageContext.setAttribute("removeKW", removeKW);
				pageContext.setAttribute("i", i);
				
				
			%>	
	<%-- 				<td>${fn:escapeXml(keyword)}</td> --%>
					<input type="text" name="keyword" id="${fn:escapeXml(kwString)}" value="<%= keyword%>" disabled>
					<input type="hidden" name="removeKW" id="${fn:escapeXml(removeKW)}" value="X" onclick="removeKeywords(${fn:escapeXml(i)})" disabled>
					<%
					i++;
					
					
			}
			pageContext.setAttribute("i", i);
		}
		%>
		</span>
		</br>
		<input type="submit" name= "saveKW" id="saveKW" value="save" onclick="saveKW()" disabled/>
		<input type="hidden" name="changed" value="keywordss"/>
	    <input type="hidden" name="paperID" value="<%= paper.getId() %>"/>
		</form>
		<input type="button" name= "addKeywords" id="addKeywords"  value="add keyword" onclick="addKeywords()" disabled/><br>
		<input type="button" name= "editKeywords" id="editKeywords"  value="edit" onclick="editKeywords(${fn:escapeXml(i)})"/><br>
		</fieldset>
		</div>
		
		<div id="topicDiv">
		<fieldset>
 		<legend><label>Paper Topic:</label></legend>
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
	    </div>
	    
	    
	    <div id="authorsDiv">
	    <fieldset>
 		<legend><label>Authors:</label></legend>
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
		
	<div id="deleteDiv">
	<%if( paper.getOwner().equals( Key.create( r3cloud.User.class, user.getNickname() ) ) ){%>
	
		<form action="/editpaper" method="post">
		<input Onclick="return ConfirmDelete();" type="submit" name="actiondelete" value="Delete">
		<input type="hidden" name="changed" value="delete"/>
	    <input type="hidden" name="paperID" value="<%= paper.getId()%>"/>
		
		</form>
	<%
	}
 }
	%>
	</div>
	
</body>

<SCRIPT language="javascript">

var keywordsNumberScript = 0;
function editTitle(){
	var elem = document.getElementById('saveTitle');
	elem.disabled = false;
	var elem = document.getElementById('editTitle');
	elem.disabled = true;
	var elem = document.getElementById('title');
	elem.disabled = false;
	
};
function editKeywords(keywordsNumber){
	keywordsNumberScript = keywordsNumber;
	for(i=0; i<keywordsNumber; i++){
		var elem = document.getElementById('keyword'+i);
		elem.disabled = false;
		elem = document.getElementById("remove"+i);
		elem.disabled = false;
		elem.type="button";
		
	}
	var elem2 = document.getElementById('saveKW');
	elem2.disabled = false;
	
	var elem3 = document.getElementById('addKeywords');
	elem3.disabled = false;
	
	var elem3 = document.getElementById('editKeywords');
	elem3.disabled=true;

	
	
}
function addKeywords(){

	//Create an input type dynamically.
 	keywordsNumberScript = keywordsNumberScript +1;
     var element = document.createElement("input");
     element.setAttribute("type", "text");
     element.setAttribute("value", "keyword");
    element.setAttribute("name", "keyword");
     element.setAttribute("id", "keyword"+keywordsNumberScript);
     
     var element2 = document.createElement("input");
     element2.setAttribute("type", "button");
     element2.setAttribute("value", "X");
    element2.setAttribute("name", "removeKW");
     element2.setAttribute("id", "remove"+keywordsNumberScript);
     element2.setAttribute("OnClick","removeKeywords("+keywordsNumberScript+")");
    
  
    
 
      var addKeyWords = document.getElementById("keywordsSpan");
 
     addKeyWords.appendChild(element);
     addKeyWords.appendChild(element2);
};

function removeKeywords(kwID){
	keywordsNumberScript = keywordsNumberScript -1;
	var KeyWordsSpan = document.getElementById("keywordsSpan");
	
	var elem = document.getElementById("keyword"+kwID);
	alert(elem.id);
	var elem2 = document.getElementById("remove"+kwID);
	KeyWordsSpan.removeChild(elem);
	KeyWordsSpan.removeChild(elem2);
};

function editAbstract(){
	var elem = document.getElementById('saveAbstract');
	elem.disabled = false;
	var elem = document.getElementById('editAbstract');
	elem.disabled = true;
	var elem = document.getElementById('abstract');
	elem.disabled = false;
	
};

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
};


function ConfirmDelete(){
  var x = confirm("Are you sure you want to delete?");
  if (x)
      return true;
  else
    return false;
}

</SCRIPT>
</html>