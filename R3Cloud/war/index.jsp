<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!-- The HTML 4.01 Transitional DOCTYPE declaration-->
<!-- above set at the top of the file will set     -->
<!-- the browser's rendering engine into           -->
<!-- "Quirks Mode". Replacing this declaration     -->
<!-- with a "Standards Mode" doctype is supported, -->
<!-- but may lead to some differences in layout.   -->
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<html lang="en">
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="R3Cloud is an electronic library put at the disposition of universities">
    <meta name="author" content="">
    <link href="stylesheets/login.css" rel="stylesheet">
    <link href="stylesheets/bootstrap.min.css" rel="stylesheet">
    <link href="stylesheets/main_css.css" rel="stylesheet">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>R3Cloud</title>
  </head>

    <body>

    <div id="container" class="container">
		<div id="header">
	        <img src="images/R3Clogo.png" alt="R3Cloud Logo" class="img-responsive" />
	        <%
		        r3cloud.User user = ((r3cloud.User)session.getAttribute("user"));
				BlobstoreService blobstoreService =  BlobstoreServiceFactory.getBlobstoreService();
				
	
				if (user == null) {
				    //response.sendRedirect("/login");
	        %>
	        	<span id="welcome_text"><a href="index.jsp?pag=login">Login</a></span>
	        <%
	        	
				}
	        	else{
	    			pageContext.setAttribute("user", user);
	        %>	        		
	        	<span id="welcome_text">Welcome, ${fn:escapeXml(user.username)}! &nbsp;
	        		<a href="${pageContext.request.contextPath}/logout">Logout</a>
	        	</span>
	        <%
	        	} 
        	%>
	        
        </div>
        <ul class="nav nav-justified">
          <li class="active"><a href="index.html">Home</a></li>
          <li><a href="index.jsp?pag=create">Create Paper</a></li>
          <li><a href="index.jsp?pag=viewAll">View All Papers</a></li>
          <li><a href="index.jsp?pag=myProfile">My Profile</a></li>
          <li><a href="index.jsp?pag=viewRequests">View Requests</a></li>
          <li><a href="contact.html">Contact</a></li>
        </ul>
        
      <div class="row space30"> <!-- row 1 begins -->
            <%
            	if(request.getParameter("pag") != null){
            		if (request.getParameter("pag").equalsIgnoreCase("create")) {            	
			            %>
			            <jsp:include page="createPaper.jsp"/>
			        	<%
            		}
            		if (request.getParameter("pag").equalsIgnoreCase("login")) {            	
			            %>
			            <jsp:include page="login.jsp"/>
			        	<%
            		}
            		if (request.getParameter("pag").equalsIgnoreCase("viewAll")) {            	
			            %>
			            <jsp:include page="viewAllPapers.jsp"/>
			        	<%
            		}
            		if (request.getParameter("pag").equalsIgnoreCase("myProfile")) {            	
			            %>
			            <jsp:include page="myProfile.jsp"/>
			        	<%
            		}
            		if (request.getParameter("pag").equalsIgnoreCase("viewRequests")) {            	
			            %>
			            <jsp:include page="requestPaper.jsp"/>
			        	<%
            		}
            		if (request.getParameter("pag").equalsIgnoreCase("viewPaper")) {            	
			            %>
			            <jsp:include page="viewPaperUser.jsp"/>
			        	<%
            		}
            	}
        	%>
      </div> <!-- /row 1 -->
      
      

      <!-- Site footer -->
      <div class="footer">
        <p>Copyright © 2013 Johannes Kepler University, Linz. Department of Telecooperation</p>
      </div>

    </div> 
  </body>
</html>
