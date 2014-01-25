<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>User Login</title>
</head>
<body>
	<div id="wrapper">

	<form name="login-form" class="login-form" action="login" method="post">
	
		<div class="header">
		<h1>Login Form</h1>
		</div>
	
		<div class="content">
			<input name="username" type="text" class="input username" placeholder="Username" />
			<div class="user-icon"></div>
			<input name="password" type="password" class="input password" placeholder="Password" />
			<div class="pass-icon"></div>
			<input type="submit" name="login" value="Login" class="button" />
				
		</div>
	
	</form>

</div>
	
</body>
</html>