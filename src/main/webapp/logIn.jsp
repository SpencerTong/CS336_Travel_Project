<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Travel Project Log In</title>
	</head>
	
	<body>
	<br>
		<form method="post" action="processLogin.jsp">
			<label for="username">Username:</label><br>
		 	<input type="text" id="username" name="username"><br>
		  	<label for="password">Password:</label><br>
		  	<input type="text" id="password" name="password"><br>
		  	<input type="submit" value="Log In">
		</form>
	<br>
	
	<% HttpSession ses = request.getSession();
		ses.setAttribute("CID", "");
		String errorMessage = (String) ses.getAttribute("logInError");
        if (errorMessage != null) { %>
        <p style="color: red;"><%= errorMessage %></p>
    <% } %>

</body>
</html>