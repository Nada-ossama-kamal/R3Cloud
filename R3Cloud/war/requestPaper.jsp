<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="r3cloud.Request" %>
<%@ page import="java.util.List"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Request Paper</title>
<link href="stylesheets/main_css.css" rel="stylesheet">

</head>
<body>
	<table>
	<%
		r3cloud.User user = (r3cloud.User)(session.getAttribute("user"));
	%>
		<input type="button" id="open_request" value="Create Request" onClick="showHideRequestForm();" />
		<div id="request_div">
			<form action="/submitRequest" method="post" name="requestForm" onsubmit="return validateRequest();">
				<span>Request Text:</span>
				<textarea id="request_text" name="request_text" rows="6" cols="100">
				</textarea>
				<span class="form_error" id="text_error"></span>
				<br/>
				<input type="hidden" name="username" value="<%=user.getUsername() %>" />
				<input id="send_request" type="submit" value="Send Request" />
			</form>
		</div>
		
			<th>Text</th>
			<th>User</th>
			<th>Date</th>
		
		<% 
		List<Request> requests = Request.loadRequests();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
  		for (Request r : requests){%>
  			<tr>
  			<td><a href="viewRequest.jsp?id=<%=r.getId() %>"><%= r.getText() %></a></td>
  			<td><%= r3cloud.User.getUserByKey(r.getAuthor()).getUsername() %></td>
  			<td><%= dateFormat.format(r.getRequest_date()) %></td>
  			</tr>
			
	    <%}%>
		
	</table>
</body>
</html>
<script>
	open_form = false;
	function showHideRequestForm(){
		if (open_form){
			document.getElementById("request_div").style.display = "none";
			document.getElementById("open_request").value = "Create Request"

		}
		else{
			document.getElementById("request_div").style.display = "block";
			document.getElementById("open_request").value = "Close Form"
		}
		open_form = !open_form;

	}
	function validateRequest(){
		ok = true;
		text = document.getElementById("request_text").value;

		if (text.length == 0){
			ok = false;
			document.getElementById("text_error").innerHTML = "Please fill in the text field!";
		}
		
		
		return ok;
	}
</script>