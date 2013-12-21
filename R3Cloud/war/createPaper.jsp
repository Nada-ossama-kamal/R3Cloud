<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%> --%>


<%@page import="r3cloud.Author"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%-- <%@ page import="com.google.appengine.api.users.User"%> --%>
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
<%@ page import="r3cloud.User" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create Paper</title>
</head>


<body>
	<% 
		
		
		r3cloud.User user = ((r3cloud.User)session.getAttribute("user"));
		BlobstoreService blobstoreService =  BlobstoreServiceFactory.getBlobstoreService();
		

		if (user == null) {
	%>
	<p>
		Hello! <a
			href="/login.jsp">Sign in</a>
	</p>
<!-- 	<p> -->
<!-- 		Hello! <a -->
<%-- 			href="<%=userService.createLoginURL(request.getRequestURI())%>">Sign --%>
<!-- 			in</a> -->
<!-- 	</p> -->
	<%
		} else {

			pageContext.setAttribute("user", user);
			
	%>
	<p>
		Hello, ${fn:escapeXml(user.username)}! (You can <a
			href="">sign
			out</a>.)
	</p>




<%-- 	  	<form action="<%= blobstoreService.createUploadUrl("/upload") %>" method="post" enctype="multipart/form-data" name="createPaperForm"> --%>
		<%String validAuthors = Author.getAllAuthorsAccountsString();
	      pageContext.setAttribute("validAuthors", validAuthors);
	     %>
 	  	<form action="<%= blobstoreService.createUploadUrl("/createPaper") %>" method="post" enctype="multipart/form-data" name="createPaperForm" onsubmit="return validateForm();">
<!--  	<form action="/createPaper" method="post" name="createPaperForm"> -->


		<div>
		<fieldset>
	    <legend><label for="titleLabel">Paper title</label></legend>
	    <input type="text" name="title"><br> 
	    </fieldset>
		</div>
		 
		 <div>
		 <fieldset>
	    <legend><label for="abstractLabel">Paper abstract</label></legend>
	    <textarea id="abstract" name="abstract" rows="10" cols="70"></textarea> <br>
	    </fieldset>
		</div>
		
		<div>
		<fieldset>
	    <legend><label for="paper">Paper</label></legend>
		<label for="url">Insert paper url</label>
	  	<input type="radio" name="text" id="url" value="false" onchange="urlSelected()"><br>
	  	<label for="text">Upload paper text</label>
	  	<input type="radio" name="text" id="text" value="true" onchange="textSelected()" checked><br>
	  	
	  	<label for="insertUrl">Paper url</label>
	  	<input type="text" name="insertedURL" id="insertedURL"  disabled><br> 
	  	
	  	<label for="chooseFile">Specify file(s) to upload</label>
		<input type="file" name="myFile" id= "myFile"><br>
		</fieldset>
		</div>
		
		<div>
		<fieldset>
	    <legend><label for="addKeyword">Add Keyword</label></legend>
		<INPUT type="button" value="Add Keyword" onclick="add()"/>
  		<span id="addKeyWords" name="keywords" >
  		<input type="text" name="keyword" id="keyword0" value="keyword">
  		</span><br>
  		</fieldset>
		</div>
		
		<div>
		<fieldset>
	    <legend><label for="chooseTopic">Choose Topic</label></legend>
		<select name="topic">
        <option value="Biology">Biology</option>
  		<option value="Chemistry">Chemistry</option>
  		<option value="Physics">Physics</option>
  		<option value="Mathematics">Mathematics</option>
  		<option value="Computer Science">Computer Science</option>
		</select><br>
		</fieldset>
		</div>
		
		<div>
		<fieldset>
	    <legend><label for="addAuthor">Add Author</label></legend>
		<INPUT type="button" value="Add Author" onclick="add2()"/>
  		<span id="addAuthors" name="authors" >
  		<input type="text" name="AuthorAccount" id="author0" value="Author's account">
  		</span><br>
  		</fieldset>
		</div>
		<input type="hidden" name="userKey" value='<%=((r3cloud.User)session.getAttribute("user")).getUsername()%>' />
		<input type="submit" value="Create paper" />
		<input type="hidden" name="validAuthors" id="validAuthors" value='<%=validAuthors%>' />
	</form> 
		
<%-- 	<form action="<%= blobstoreService.createUploadUrl("/upload") %>" method="post" enctype="multipart/form-data">
        <input type="file" name="myFile">
        <input type="submit" value="Submit">
    </form>  --%>
    

	<%
		}
	%>
</body>


<SCRIPT language="javascript">

Array.prototype.contains=function(other){
	
	for (k=0;k<this.length;k++){
			if(this[k] == other){
				return true;
			}
	  }
	  return false;
	};


var keywords =1;
var authors =1;
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
function add() {
 
    //Create an input type dynamically.
   
    var element = document.createElement("input");
 
    //Assign different attributes to the element.
    element.setAttribute("type", "text");
    element.setAttribute("value", "keyword");
    element.setAttribute("name", "keyword");
    element.setAttribute("id", "keyword"+keywords);
   
 
    var addKeyWords = document.getElementById("addKeyWords");

    //Append the element in page (in span).
    addKeyWords.appendChild(element);
   
    keywords = keywords+1;
   
 
};
function add2() {
	
    //Create an input type dynamically.
    
    var author = document.createElement("input");
    author.setAttribute("type", "text");
    author.setAttribute("value", "Author's account");
    author.setAttribute("name", "AuthorAccount");
    author.setAttribute("id", "author"+authors);
    
//     var fName = document.createElement("input");
//     fName.setAttribute("type", "text");
//     fName.setAttribute("value", "Author's first name");
//     fName.setAttribute("name", "AuthorFirstName");
    
//     var lName = document.createElement("input");
//     lName.setAttribute("type", "text");
//     lName.setAttribute("value", "Author's last name");
//     lName.setAttribute("name", "AuthorLastName");
    
//     var affiliation = document.createElement("input");
//     affiliation.setAttribute("type", "text");
//     affiliation.setAttribute("value", "Author's Affiliation");
//     affiliation.setAttribute("name", "Affiliation");
 	
    //var lineBreak = document.createElement ("br");

    var addAuthors = document.getElementById("addAuthors");
    
    //Append the element in page (in span).
    addAuthors.appendChild(author);
    authors = authors+1;
    alert(""+authors);
//     addAuthors.appendChild(fName);
//     addAuthors.appendChild(lName);
//     addAuthors.appendChild(affiliation);
    //addAuthors.appendChild(lineBreak);
    
};

function validateForm(){
	
	vauthors = document.createPaperForm.validAuthors.value;
	
	var validAuthors = new Array();
 	validAuthors = vauthors.split('#');
  
	if(document.createPaperForm.title.value==""){
      	alert("The Title field is left blank");
      	document.createPaperForm.title.focus();
      	return false;
    }else if(document.createPaperForm.abstract.value==""){
			alert("The Abstract field is left blank");
            document.createPaperForm.abstract.focus();
            return false;
     }else if(document.getElementById('text').checked && (document.getElementById('myFile').files[0]==null || document.getElementById('myFile').files[0].size == 0)){
	         	alert("No file or a file of 0 size was selected");
	         	//document.createPaperForm.myFile.focus();
	         	return false;
     }else if(document.getElementById('url').checked && document.createPaperForm.insertedURL.value==""){
         	   alert("The url field is left blank");
         	   document.createPaperForm.insertedURL.focus();
         	   return false;
     }else if(document.getElementById('insertedURL').value!=""){
    			var urlregex = new RegExp(
    	        "^(http:\/\/www.|https:\/\/www.|ftp:\/\/www.){1}([0-9A-Za-z]+\.)");	
    		      var valid= urlregex.test(document.getElementById('insertedURL').value);
    		      if(!valid){
    		    	  alert("Please insert a valid url value: \n http:\/\/www.(\/path) \n https:\/\/www.(\/path) \n ftp:\/\/www.(\/path)");
    		    	  document.createPaperForm.insertedURL.focus();
    		    	  return false;
    		      }
         		
      }else{
    	  for(i=0; i<keywords; i++){
    		  var kw = document.getElementById("keyword"+i);
    		  if(kw.value == ""){
    			  var num = i+1;
    			  alert("Please enter a value for keyword number "+num);
    			  kw.focus();
    			  return false;
    		  }
    	  }
    	  
    	  for(j=0; j<authors; j++){
    		  var author = document.getElementById("author"+j);
    		  var num2 = j+1;
    		  if(author.value == ""){
    			  alert("Please enter an account for author number "+num2);
    			  author.focus();
    			  return false;
    		  }
    		  if(!validAuthors.contains(author.value)){
    			  alert("Please enter a valid author account for author number " +num2)
    			  return false;
    		  }
    	  }
      }
	
};


</SCRIPT>
</html>