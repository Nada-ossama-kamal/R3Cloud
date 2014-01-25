<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="r3cloud.Paper" %>
<%@ page import="java.util.List"%> 
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="r3cloud.Request" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Request Page</title>
<link href="stylesheets/main_css.css" rel="stylesheet">

</head>
<body>
		<%
			String id = request.getParameter("id");
			SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
			Request r = Request.getRequestById(Long.parseLong(id));
			String username = ((r3cloud.User)session.getAttribute("user")).getUsername();
		%>
	<textarea rows="6" cols="70" id="request_view" disabled><%= r.getText() %></textarea>
	<p><%= (r3cloud.User.getUserByKey(r.getAuthor())).getUsername()+", "+df.format(r.getRequest_date()) %></p>
	<h3>Make Recommendation</h3>
	
	<form method="post" name="recommendation_form" action="submitRecommendation" onsubmit="return validateRecommendForm();">
		<div id="papers">
			<select name="paper1" id="paper1">
				<%
					List<Paper> papers = Paper.loadAll();
					for (Paper p : papers){%>
						<option value="<%=p.getId() %>"><%= p.getTitle() %></option>					
					<%}%>
			</select>
			</div>
		<br />
		
		<input type="hidden" value = "<%= username  %>" name="user" />
		<input type="hidden" value = "<%= id %>" name="request_id" />
		<input type="hidden" value = "1" name="no_of_papers" id="no_of_papers" />
		<input type="button" value="Add Paper" onclick="addPaperCombo();" />
		<input type="button" value="Remove Paper" onClick="removePaperCombo();" />		
		<input type="submit" value="Make Recommendation" />
	</form>
</body>
</html>
<script>
var cont = 1;
function addPaperCombo(){
	var first = document.getElementById('papers');
	var options = first.innerHTML;
	
	cont++;
	var current = "paper"+cont;
	var element = document.createElement("select");
	 
    //Assign different attributes to the element.
    element.setAttribute("name", current);
    element.setAttribute("id", current);
   	element.innerHTML = options;
	var child = document.getElementById(first);
	first.appendChild(element);
	document.getElementById("no_of_papers").value = cont;
	
}
function removePaperCombo(){
	var last = "paper"+cont;
	var elem = document.getElementById(last);
	elem.parentNode.removeChild(elem);
	cont --;
	document.getElementById("no_of_papers").value = cont;
}
function validateRecommendForm(){
	ok = true;
	for (int i = 1; i<= cont; i++){
		name = "paper"+i;
		document.getElementById(name);
	}
	
	return ok;
}

</script>