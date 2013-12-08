<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>User Login</title>
</head>
<body>
	<form action="login" method="post">
		<label for="username">Username</label>
	    <input type="text" name="username"><br /> 
	    <label for="password">Password</label>
	    <input type="text" name="password"><br /> 
		<input type="submit" name="login" value="Login" />
	</form>
</body>
</html>