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
		//UserService userService = UserServiceFactory.getUserService();
		//User user = userService.getCurrentUser();
		/* BlobstoreService blobstoreService =  BlobstoreServiceFactory.getBlobstoreService(); */
		r3cloud.User user = ((r3cloud.User)session.getAttribute("user"));
		

		if (user == null) {
	%>
	<p>
		Hello! <a
			href="/login.jsp">Sign
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
		Hello, ${fn:escapeXml(user.username)}! (You can <a
			href="">sign
			out</a>.)
	</p>
	
	 <p>
	    Created by: <%=paper.getOwner().getName()%>
	</p>
	<p>
		At: ${fn:escapeXml(paper.date)}
    </p>
    <p>
		Last modified at: ${fn:escapeXml(paper.lastUpdatedDate)}
	</p>
	
		<div id="titleDiv">
		<fieldset>
  		<legend><label>Paper title:</label></legend>
  		<form action="/editpaper" method="post" onsubmit="return validateTitle();">
  		<span id="titleDiv">
	    <!-- <label for="titleLabel">Paper title</label> -->
	    <%if( paper.getOwner().equals( Key.create( r3cloud.User.class, user.getUsername() ) ) ){%>
	    <input type="submit" name= "saveTitle" id="saveTitle" value="save" onclick="saveTitle()" disabled/>&nbsp;&nbsp;&nbsp;&nbsp;
	    <%}%>
	    <input type="text" name="title" id="title" value="<%= paper.getTitle() %>" disabled>&nbsp;&nbsp;&nbsp;&nbsp;
	    <input type="hidden" name="changed" value="title"/>
	    <input type="hidden" name="paperID" value="<%= paper.getId() %>"/>
	    </span>
	    </form>
	    <%if( paper.getOwner().equals( Key.create( r3cloud.User.class, user.getUsername() ) ) ){%>
	    <input type="button" name= "editTitle" id="editTitle"  value="edit" onclick="editTitle()"/><br>
	    <%} %>
	    </fieldset>
	    </div>
		
		<div id="abstractDiv">
		<fieldset>
  		<legend><label>Paper abstract:</label></legend>
  		<form action="/editpaper" method="post" onsubmit="return validateAbstract();">
  		<span id="abstractDiv">
<!-- 	    <label for="abstractLabel">Paper abstract</label><br>  -->
		<%if( paper.getOwner().equals( Key.create( r3cloud.User.class, user.getUsername() ) ) ){%>
		<input type="submit" name= "saveAbstract" id="saveAbstract" value="save" disabled/>&nbsp;&nbsp;&nbsp;&nbsp;
		<%} %>
	    <textarea id="abstract" name="abstract" rows="10" cols="70" disabled> <%= paper.getAbstractPaper() %></textarea>
	    	    <input type="hidden" name="changed" value="abstract"/>
	    <input type="hidden" name="paperID" value="<%= paper.getId() %>"/>
	    </span>
	    </form>
	    <%if( paper.getOwner().equals( Key.create( r3cloud.User.class, user.getUsername() ) ) ){%>
	    <input type="button" name= "editAbstract" id="editAbstract"  value="edit" onclick="editAbstract()"/><br>
	    <%} %>
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
      	<input type="submit" value="View Paper" />
		<input type="hidden" name="blob-key" value="${fn:escapeXml(paper)}"/>
   	    </form>
	    </div>
	
	 <div id="urlDiv">
		<%
		}else{
			%>
			<label for="Url">Paper url</label>
			<a href="<%= paper.getUrl() %>">Go to paper</a>
<%-- 		  	<input type="text" name="insertedURL" value="<%= paper.getUrl() %>" disabled><br> --%>
		<%
		}
		%>
 	 </div>
 	 
 	    
   	    <form action="<%= blobstoreService.createUploadUrl("/editpaper") %>" method="post" enctype="multipart/form-data" name="editContentForm" onsubmit="return validateContent();">
		<span id="editContentSpan" style="visibility: hidden;">

   	     </span>
   	    <input type="hidden" name="changed" value="content"/>
    	<input type="hidden" name="paperID" value="<%= paper.getId() %>"/>
   	    </form>
   	  
 	 
 	 <%if( paper.getOwner().equals( Key.create( r3cloud.User.class, user.getUsername() ) ) ){%>
	    <input type="button" name= "editContent" id="editContent"  value="edit" onclick="editContent()"/><br>
	    <%} %>
	   
 	 </fieldset>
 	 </div>
 	 
 	 
 		<div id="keywordsDiv">
 		<fieldset>
 		<legend><label>Keywords Label:</label></legend>
		<%
		String[] keywords = paper.getKeywords();
		if(keywords.length == 0){
		%>
			<p><i>No keywords were specified</i></p>
		<%
		}
		else{
			%>
			<form action="/editpaper" method="post" onsubmit="return validateKeyword();">
			<span id="keywordsSpan">
			<%
			int i=0;
			for(String keyword : keywords){
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
		<%if( paper.getOwner().equals( Key.create( r3cloud.User.class, user.getUsername() ) ) ){%>
		<input type="submit" name= "saveKW" id="saveKW" value="save" onclick="saveKW()" disabled/>
		<%}%>
		<input type="hidden" name="changed" value="keywordss"/>
	    <input type="hidden" name="paperID" value="<%= paper.getId() %>"/>
		</form>
		<%if( paper.getOwner().equals( Key.create( r3cloud.User.class, user.getUsername() ) ) ){%>
		<input type="button" name= "addKeywords" id="addKeywords"  value="add keyword" onclick="addKeywords()" disabled/><br>
		<input type="button" name= "editKeywords" id="editKeywords"  value="edit" onclick="editKeywords(${fn:escapeXml(i)})"/><br>
		<%}%>
		</fieldset>
		</div>
		
		<div id="topicDiv">
		<fieldset>
 		<legend><label>Paper Topic:</label></legend>
<!-- 		<label for="topic">Paper Topic</label> -->
	
    	<form action="/editpaper" method="post">
    	<span id="topicDiv">
    	<%if( paper.getOwner().equals( Key.create( r3cloud.User.class, user.getUsername() ) ) ){%>
    	<input type="submit" name= "saveTopic" id="saveTopic" value="save" onclick="saveTopic()" disabled/>&nbsp;&nbsp;&nbsp;&nbsp;
    	<%}%>
	    <input type="text" id= "topicValue" name="topic" value="<%= paper.getTopic() %>" disabled>&nbsp;&nbsp;&nbsp;&nbsp;
	    
	    <input type="hidden" name="changed" value="topic"/>
	    <input type="hidden" name="paperID" value="<%= paper.getId() %>"/>
	    </span>
	    </form>
	    <%if( paper.getOwner().equals( Key.create( r3cloud.User.class, user.getUsername() ) ) ){%>
	    <input type="button" name= "editTopic" id="editTopic"  value="edit" onclick="editTopic()"/><br>
	    <%} %>
	    </fieldset>
	    </div>
	    
	    
	    <div id="authorsDiv">
	    <fieldset>
 		<legend><label>Authors:</label></legend>
<!-- 	    <label for="Author">Authors:</label> -->
	    
		<%
		List<Key<Author>> authorKeys = paper.getAuthors();
	    List<Author> authors = Author.getAuthorsByKey(authorKeys);
		
		if(authors.size() == 0){
		%>
			<p><i>No authors were specified</i></p>
		<%
		}
		else{
			%>
			<form action="/editpaper" method="post" onsubmit="return validateAuthor();">
			<span id='authorsSpan'>
			<% 
			int j=0;
			for(Author author : authors){
				String title = "author"+j+"title";
				String fName = "author"+j+"FName";
				String lName = "author"+j+"LName";
				String aff = "author"+j+"Aff";
				String removeAuthor = "removeAuthor"+j;
				String authorAccount = "authorAccount"+j;
				pageContext.setAttribute("j", j);
		
				pageContext.setAttribute("author", author);
				pageContext.setAttribute("title", title);
				pageContext.setAttribute("fName", fName);
				pageContext.setAttribute("lName", lName);
				pageContext.setAttribute("aff", aff);
				pageContext.setAttribute("removeAuthor", removeAuthor);
				pageContext.setAttribute("authorAccount", authorAccount);
				j++;
			
			%>	
				
				<input type="text" name="authorAccount" id= "${fn:escapeXml(authorAccount)}" value="<%= author.getAccount()%>" disabled>
				<input type="hidden" name="removeAuthor" id="${fn:escapeXml(removeAuthor)}" value="X" onclick="removeAuthors(${fn:escapeXml(j)})" disabled>
				<input type="text" name="authorTitle" id= "${fn:escapeXml(title)}" value="<%= author.getTitle()%>" disabled>
				<input type="text" name="authorFName" id= "${fn:escapeXml(fName)}" value="<%= author.getFirstName()%>" disabled>
			    <input type="text" name="authorLName" id= "${fn:escapeXml(lName)}" value="<%= author.getLastName()%>" disabled>
			    <input type="text" name="authorAff" id= "${fn:escapeXml(aff)}" value="<%= author.getAffiliation()%>" disabled>
				</br>
				
	
			<%
			}
		
			pageContext.setAttribute("numberOfAuthors", j);
			%>
			</span>
			<%
		}
		%>
		<%if( paper.getOwner().equals( Key.create( r3cloud.User.class, user.getUsername() ) ) ){%>
		<input type="submit" name= "saveAuthors" id="saveAuthors" value="save" onclick="saveAuthors()" disabled/>
		<%}%>
		<input type="hidden" name="changed" value="authors"/>
	    <input type="hidden" name="paperID" value="<%= paper.getId() %>"/>
		</form>
		<%if( paper.getOwner().equals( Key.create( r3cloud.User.class, user.getUsername() ) ) ){%>
		<input type="button" name= "addAuthors" id="addAuthors"  value="add author" onclick="addAuthors()" disabled/><br>
		<input type="button" name= "editAuthors" id="editAuthors"  value="edit" onclick="editAuthors(${fn:escapeXml(numberOfAuthors)})"/><br>
		<%}%>
		</fieldset>
		</div>
		
	<div id="deleteDiv">
	<%if( paper.getOwner().equals( Key.create( r3cloud.User.class, user.getUsername() ) ) ){%>
	
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


var nextKeywordID = 0;
var validKeyWordsIDs = new Array();

var nextAuthorID = 0;
var validAuthorssIDs = new Array();

Array.prototype.contains=function(other){
	
	for (k=0;k<this.length;k++){
			if(this[k] == other){
				return true;
			}
	  }
	  return false;
	};

Array.prototype.remove=function(other){
	alert("remove func "+other);
	alert(this);
	var newArray = new Array();
	var newArrayIndex = 0;
	for (k=0;k<this.length;k++){
		alert("remove func "+other+"  "+this[k]);
			if(this[k] != other){
				newArray[newArrayIndex] = this[k];
				newArrayIndex++;
			}
	  }
	  return newArray;
};

function textSelected(){
	var text = document.getElementById("myFile");
	var url = document.getElementById("insertedURL");
	text.disabled = false;
	url.disabled = true;
	
};
function urlSelected(){
	var text = document.getElementById("myFile");
	var url = document.getElementById("insertedURL");
	text.disabled = true;
	url.disabled = false;
};

function editContent(){
	var span = document.getElementById("editContentSpan");
		span.style.visibility="visible";
	
	 var element1 = document.createElement("label");
	    element1.setAttribute("for", "url");
	    element1.innerHTML = "Insert paper url";
	   
	
	    
	 var element2 = document.createElement("input");
	    element2.setAttribute("type", "radio");
	    element2.setAttribute("value", "false");
	    element2.setAttribute("name", "text");
	    element2.setAttribute("id", "url");
	    element2.setAttribute("OnClick","urlSelected()");
	  
	 var element3 = document.createElement("label");
	    element3.setAttribute("for", "text");
	    element3.innerHTML = "Upload paper text";
	    
	    var element4 = document.createElement("input");
	    element4.setAttribute("type", "radio");
	    element4.setAttribute("value", "true");
	    element4.setAttribute("name", "text");
	    element4.setAttribute("id", "text");
	    element4.setAttribute("OnClick","textSelected()");
	    element4.checked="true";
	    
	    
	    var element5 = document.createElement("label");
	    element5.setAttribute("for", "insertUrl");
	    element5.innerHTML = "Paper url";
	  
	    
	    var element6 = document.createElement("input");
	    element6.setAttribute("type", "text");
	    element6.setAttribute("name", "insertedURL");
	    element6.setAttribute("id", "insertedURL");
	    element6.disabled="true";
	    
	    
	    
	    var element7 = document.createElement("label");
	    element7.setAttribute("for", "chooseFile");
	    element7.innerHTML = "Specify file(s) to upload";
	    
	    var element8 = document.createElement("input");
	    element8.setAttribute("type", "file");
	    element8.setAttribute("name", "myFile");
	    element8.setAttribute("id", "myFile");
	    
	    var element9 = document.createElement("input");
	    element9.setAttribute("type", "submit");
	    element9.setAttribute("value", "save");
	    element9.setAttribute("name", "saveContent");
	    element9.setAttribute("id", "saveContent");
	    element9.setAttribute("OnClick","saveContent()");

	    
	    
	   
	    span.appendChild(element1);
	    span.appendChild(element2);
	    span.appendChild(document.createElement ("br"));
	    span.appendChild(element3);
	    span.appendChild(element4);
	    span.appendChild(document.createElement ("br"));
	    span.appendChild(element5);
	    span.appendChild(element6);
	    span.appendChild(document.createElement ("br"));
	    span.appendChild(element7);
	    span.appendChild(element8);
	    span.appendChild(document.createElement ("br"));
	    span.appendChild(element9);
	    span.appendChild(document.createElement ("br"));
	    
//       <label for="url">Insert paper url</label>	
//   	<input type="radio" name="text" id="url" value="false" onchange="urlSelected()"><br>
//   	<label for="text">Upload paper text</label>
//   	<input type="radio" name="text" id="text" value="true" onchange="textSelected()" checked><br>
  	
//   	<label for="insertUrl">Paper url</label>
//   	<input type="text" name="insertedURL" id="insertedURL"  disabled><br> 
  	
//   	<label for="chooseFile">Specify file(s) to upload</label>
// 	<input type="file" name="myFile" id= "myFile"><br>
	
    
    
	var elem = document.getElementById('saveContent');
	elem.disabled = false;
	var elem = document.getElementById('editContent');
	elem.disabled = true;
	
};

function editTitle(){
	var elem = document.getElementById('saveTitle');
	elem.disabled = false;
	var elem = document.getElementById('editTitle');
	elem.disabled = true;
	var elem = document.getElementById('title');
	elem.disabled = false;
	
};

function editAuthors(authorsNumber){

	
	nextAuthorID = authorsNumber;
	
	for(i=0; i<authorsNumber; i++){
		
		var elem1 = document.getElementById("author"+i+"title");
		var parent1 = elem1.parentNode;
		parent1.removeChild(elem1);
		
		var elem2 = document.getElementById("author"+i+"FName");
		var parent2 = elem2.parentNode;
		parent2.removeChild(elem2);
		
		var elem3 = document.getElementById("author"+i+"LName");
		var parent3 = elem3.parentNode;
		parent3.removeChild(elem3);
		
		var elem4 = document.getElementById("author"+i+"Aff");
		var parent4 = elem4.parentNode;
		parent4.removeChild(elem4);
		
		var elem5 = document.getElementById('authorAccount'+i);
		elem5.disabled = false;
		
		var elem6 = document.getElementById('removeAuthor'+i);
		elem6.disabled = false;
		elem6.type="button";
		
		var elem7 = document.getElementById('addAuthors');
		elem7.disabled = false;
		
		var elem7 = document.getElementById('saveAuthors');
		elem7.disabled = false;
		
		validAuthorssIDs[i]=i;
		
	}
};

function addAuthors(){
	var author = document.createElement("input");
    author.setAttribute("type", "text");
    author.setAttribute("value", "Author's account");
    author.setAttribute("name", "authorAccount");
    author.setAttribute("id", "authorAccount"+nextKeywordID);
    
    var element2 = document.createElement("input");
    element2.setAttribute("type", "button");
    element2.setAttribute("value", "X");
    element2.setAttribute("name", "removeAuthor");
    element2.setAttribute("id", "removeAuthor"+nextKeywordID);
    element2.setAttribute("OnClick","removeAuthors("+nextKeywordID+")");
   alert("authorAccount"+nextKeywordID);
 
    var lineBreak = document.createElement ("br");

     var authorsSpan = document.getElementById("authorsSpan");

     authorsSpan.appendChild(author);
     authorsSpan.appendChild(element2);
     authorsSpan.appendChild(lineBreak);
     
    
     validKeyWordsIDs[validKeyWordsIDs.length] = nextKeywordID;
     nextKeywordID = nextKeywordID +1;
     
};



function removeAuthors(author){
	validKeyWordsIDs = validKeyWordsIDs.remove(author);
	
	var authorsSpan = document.getElementById("authorsSpan");
	alert("removeAuthor"+author);
	var elem = document.getElementById("removeAuthor"+author);
	var elem2 = document.getElementById("authorAccount"+author);
	
	authorsSpan.removeChild(elem);
	authorsSpan.removeChild(elem2);
};

function editKeywords(keywordsNumber){
	
	nextKeywordID = keywordsNumber;
	
	for(i=0; i<keywordsNumber; i++){
		var elem = document.getElementById('keyword'+i);
		elem.disabled = false;
		elem = document.getElementById("remove"+i);
		elem.disabled = false;
		elem.type="button";
		
		validKeyWordsIDs[i]=i;
		
	}
	var elem2 = document.getElementById('saveKW');
	elem2.disabled = false;
	
	var elem3 = document.getElementById('addKeywords');
	elem3.disabled = false;
	
	var elem3 = document.getElementById('editKeywords');
	elem3.disabled=true;
	alert("validKeyWordsIDs: "+validKeyWordsIDs.length);
};

function addKeywords(){

	//Create an input type dynamically.
     var element = document.createElement("input");
     element.setAttribute("type", "text");
     element.setAttribute("value", "keyword");
    element.setAttribute("name", "keyword");
     element.setAttribute("id", "keyword"+nextKeywordID);
     alert(element.id);
     var element2 = document.createElement("input");
     element2.setAttribute("type", "button");
     element2.setAttribute("value", "X");
    element2.setAttribute("name", "removeKW");
     element2.setAttribute("id", "remove"+nextKeywordID);
     element2.setAttribute("OnClick","removeKeywords("+nextKeywordID+")");
    
  
    
 
      var addKeyWords = document.getElementById("keywordsSpan");
 
     addKeyWords.appendChild(element);
     addKeyWords.appendChild(element2);
     alert("Adding: "+nextKeywordID);
    
     validKeyWordsIDs[validKeyWordsIDs.length] = nextKeywordID;
     nextKeywordID = nextKeywordID +1;
     
     alert("validKeyWordsIDs: "+validKeyWordsIDs.length);
};

function removeKeywords(kwID){
	validKeyWordsIDs = validKeyWordsIDs.remove(kwID);
	alert("remove"+kwID);
	 alert("validKeyWordsIDs: "+validKeyWordsIDs.length);
	 
	var KeyWordsSpan = document.getElementById("keywordsSpan");
	
	var elem = document.getElementById("keyword"+kwID);
	var elem2 = document.getElementById("remove"+kwID);
	KeyWordsSpan.removeChild(elem);
	KeyWordsSpan.removeChild(elem2);
};

function validateKeyword(){
	
	if(validKeyWordsIDs.length < 1){
		alert("Please enter at least one keyword !!");
		 return false;
	}else{
		
		alert("#valid KWs  "+validKeyWordsIDs.length);
		for(i=0; i< validKeyWordsIDs.length; i++){
			alert("keyword"+i);
			  var kw = document.getElementById("keyword"+validKeyWordsIDs[i]);
			  alert(validKeyWordsIDs[i]+"  "+kw.value);
			  if(kw.value == ""){
				  var num = i+1;
				  alert("Please enter a value for keyword number "+num);
				  kw.focus();
				  return false;
			  }
		  }
	}
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
	var parent = elem2.parentNode;
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
};

function validateTitle(){
	if( document.getElementById('title').value==""){
      	alert("The Title field is left blank");
      	document.getElementById('title').focus();
      	return false;
    }
};

function validateAbstract(){
	if( document.getElementById('abstract').value==""){
      	alert("The Abstract field is left blank");
      	document.getElementById('abstract').focus();
      	return false;
    }
};
	

function validateAuthor(){
	alert("da5al");
	if(authorsNumberScript<1){
		alert("Please enter at least one Author account !!");
		 return false;
	}else{
		
		var k=0;
		alert(authorsNumberScript);
		for(k=0; k<authorsNumberScript; k++){
			alert("authorAccount"+k);
			  var author = document.getElementById("authorAccount"+k);
			  alert(authorsNumberScript+"  "+author.value);
			  if(author.value == ""){
				  var num = k+1;
				  alert("Please enter a value for author account number "+num);
				  author.focus();
				  return false;
			  }
		  }
	}

};
	

function validateContent(){
	if(document.getElementById('text').checked && (document.getElementById('myFile').files[0]==null || document.getElementById('myFile').files[0].size == 0)){
     	alert("No file or a file of 0 size was selected");
     	//document.createPaperForm.myFile.focus();
     	return false;
	}else if(document.getElementById('url').checked && document.getElementById('insertedURL').value==""){
 	   alert("The url field is left blank");
 	  document.getElementById('insertedURL').focus();
 	   return false;
	}else if(document.getElementById('insertedURL').value!=""){
		var urlregex = new RegExp(
        "^(http:\/\/www.|https:\/\/www.|ftp:\/\/www.){1}([0-9A-Za-z]+\.)");	
	      var valid= urlregex.test(document.getElementById('insertedURL').value);
	      if(!valid){
	    	  alert("Please insert a valid url value: \n http:\/\/www.(\/path) \n https:\/\/www.(\/path) \n ftp:\/\/www.(\/path)");
	    	  document.getElementById('insertedURL').focus();
	    	  return false;
	      }
	}

	
}
</SCRIPT>
</html>