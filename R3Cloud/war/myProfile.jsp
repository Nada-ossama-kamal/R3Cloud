<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.googlecode.objectify.Key"%>
    
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="r3cloud.Paper" %>
<%@ page import="r3cloud.Author" %>
<%@ page import="r3cloud.Review" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href="stylesheets/main_css.css" rel="stylesheet">

<title>MyProfile</title>
</head>
<body>
	<h2>User Account Information</h2>
	<h4>Welcome on your profile, <%= ((r3cloud.User) (session.getAttribute("user"))).getUsername() %>!</h4>
	<br/>
	<% if (session.getAttribute("message") != null) {
		if(session.getAttribute("message").equals("Changes successfully recorded!")){%>
		<span class="message_info">Changes successfully recorded!</span><br />
	<%
		
	} 
	else{%>
		<span class="form_error">Invalid input for current password! Profile not updated</span><br />
	<%}
		session.removeAttribute("message");
	}%>
	<input type="radio" name="action" checked="true" onclick="showPapers();" value="view_papers">View Published Papers <br />
	<input type="radio" name="action" onclick="showForm();" value="update_profile">Update Profile Information<br />
	<div id="info_update">
	<h3>Update your information</h3>
	<form method="post" action="/updateProfile" name="update_profile" onsubmit="return validateUpdateProfileForm()">
		<table>
			<tr>
				<td><p>New password</p></td>
				<td><input type="password" id="new_pass" name="new_pass" />
				<span class="form_error" id="new_pass_error"></span>
				</td>
			</tr>
			<tr>
				<td><p>Confirm password</p></td>
				<td><input type="password" id="confirm_pass" name="confirm_pass"  />
				<span class="form_error" id="confirm_pass_error"></span>
				</td>
			</tr>
			<tr>
				<td><p>Email Address</p></td>
				<td><input type="email" name="new_email" value="<%= ((r3cloud.User) (session.getAttribute("user"))).getEmail() %>" />
				<span class="form_error" id="email_error"></span>
				</td>
			</tr>
			<tr>
				<%
					
					r3cloud.User user = (r3cloud.User)(session.getAttribute("user"));
					Key<r3cloud.User> userKey = r3cloud.User.getUserKey(user.getUsername());
					Author auth = Author.getAuthorByUserAccount(userKey);
					//System.out.print(auth.getFirstName());
					//System.out.print(user.getUsername());
					//Key<r3cloud.User> userKey = r3cloud.User.getUserKey(u.getUsername());
					//r3cloud.User //uTest = (r3cloud.User)(session.getAttribute("user"));
					//System.out.print(uTest.getUsername());
					//Author auth = Author.getAuthorByUserAccount(userKey);
				%>
				<td><p>Affiliation</p></td>
				<td><input type="text" name="new_affiliation" id="affiliation" value="<%= auth.getAffiliation() %>" />
					<span class="form_error" id="affiliation_error"></span>
				</td>
			</tr>
			<tr>
				<td><p>Title</p></td>
				<td><select name="new_title">
				        <option value="Professor"
				        	<%if (auth.getTitle().equals("Professor")) {%>
				        		selected="true"
				        	<% }%>
				        >Professor</option>
				  		<option value="Dipl. Ing."
				  		<% if (auth.getTitle().equals("Dipl. Ing.")) {%>
				        		selected
				        	<% }%>
				  		>Dipl. Ing.</option>
				  		<option value="PhD"
				  		<% if (auth.getTitle().equals("PhD")) {%>
				        		selected
				        	<% }%>
				  		>PhD</option>
				  		<option value="MSc"
				  		<% if (auth.getTitle().equals("MSc")) {%>
				        		selected
				        	<% }%>
				  		>MSc</option>
				  		<option value="BSc"
				  		<% if (auth.getTitle().equals("BSc")) {%>
				        		selected="true"
				        	<% }%>
				  		>BSc</option>
					</select>
					<span class="form_error" id="title_error"></span>
					<br />
				</td>
			</tr>
			<tr>
				<td><p>Current password</p></td>
				<td><input type="password" id="current_pass" name="current_pass" />
					<span class="form_error" id="current_pass_error"></span>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="hidden" name="username" value="<%=user.getUsername() %>" />
					<input type="submit" value="Update Profile" />
				</td>
			</tr>
		</table>
	</form>
	</div>
	<div id="user_papers">
		<ul>
		<% 
		r3cloud.User u = (r3cloud.User)(session.getAttribute("user"));
		Key<r3cloud.User> uKey = r3cloud.User.getUserKey(user.getUsername());
		List<Paper> userPapers = Paper.getPapersByUser(uKey);
  		for (Paper p : userPapers){%>
  			<li><a href="viewPaperUser.jsp?id=<%=p.getId() %>"><%= p.getTitle() %></a></li>
			
	    <%}%>
	    </ul>
	</div>
</body>
<script>
function showPapers(){
	document.getElementById("user_papers").style.display="block";
	document.getElementById("info_update").style.display="none";
}
function showForm(){
	document.getElementById("user_papers").style.display="none";
	document.getElementById("info_update").style.display="block";
}
function validateUpdateProfileForm(){
	ok = true;
	new_pass = document.getElementById("new_pass").value;
	confirm_pass = document.getElementById("confirm_pass").value;
	current_pass = document.getElementById("current_pass").value; 
	affiliation = document.getElementById("affiliation").value;
	/* 
	if (new_pass.length == 0){
		ok = false;
		document.getElementById("new_pass_error").innerHTML = "Please fill in the new password field!";
	}
	 
	if (confirm_pass.length == 0){
		ok = false;
		document.getElementById("confirm_pass_error").innerHTML = "Please fill in the confirm password field!";
	}*/
	if (current_pass.length == 0){
		ok = false;
		document.getElementById("current_pass_error").innerHTML = "Please fill in the current password field!";
	}
	
	if (!(new_pass == confirm_pass)){
		ok = false;
		document.getElementById("confirm_pass_error").innerHTML = "Passwords mismatch!";
	}
	if (affiliation.length == 0){
		ok = false;
		document.getElementById("affiliation_error").innerHTML = "Please fill in the affiliation field!";
	}
	
	return ok;
}

</script>
</html>