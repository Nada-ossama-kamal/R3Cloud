<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Register Author</title>
</head>
<body>

	<form action="registerAuthor" method="post">
		<label for="username">Username</label>
	    <input type="text" name="username"><br /> 
	    <label for="password">Password</label>
	    <input type="text" name="password"><br />
	    <label for="email">Email</label>
	    <input type="text" name="email"><br /> 
 		<input type="button" name="Add author" value="Complete author fields" onclick="addAuthor(); "/><br/>
 		<input type="hidden" name="normal_user" id ="normal_user" value="1"/>
	    <span id="author_form" style="visibility: hidden;">
			<label for="authorFirstName">First name</label>
		    <input type="text" name="first_name"><br /> 
		    <label for="authorLastName">Last name</label>
		    <input type="text" name="last_name"><br /> 
		    <label for="authorTitle">Title</label>
			<select name="title">
		        <option value="Professor">Professor</option>
		  		<option value="Dipl. Ing.">Dipl. Ing.</option>
		  		<option value="PhD">PhD</option>
		  		<option value="MSc">MSc</option>
		  		<option value="BSc">BSc</option>
			</select><br />
			<label for="authorAffiliation">Affiliation</label>
			<input type="text" name="affiliation"><br />
		</span>
		<input type="submit" name="register_author" />
	</form>
	
</body>
<script language="javascript">
	function addAuthor() {
		 //make the part of the form for the author visible
		 document.getElementById("author_form").style.visibility="visible";
		 document.getElementById("normal_user").value="0";
	}
</script>
</html>