<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
    <!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Manage Users</title>
</head>
<body>

	<form method="GET">
		<input type="submit" name="backToHome" value="Back To Admin Home">
	</form><br><br>
	
	<form method="GET">
		To add an account, you MUST enter all of the below information.<br>
		To edit an account, input its current ID and a new value for any of the other parameters.<br>
		To delete an account, simply input ONLY its ID. <br><br>
		<label for="username">Username:</label><br>
		<input type="text" id="username" name="username"><br>
		<label for="password">Password:</label><br>
		<input type="text" id="password" name="password"><br>
		<label for="reservationPortfolio">Reservation Portfolio:</label><br>
		<input type="text" id="reservationPortfolio" name="reservationPortfolio"><br>
		<label for="CID">ID/CID:</label><br>
		<input type="text" id="CID" name="CID"><br>
		<input type="submit" name="add" value="Add a user">
		<input type="submit" name="edit" value="Edit a user">
		<input type="submit" name="delete" value="Delete a user">
	</form><br>
	
	<%
	try{
		HttpSession ses = request.getSession();
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		
		if(request.getParameter("backToHome") != null) {
			response.sendRedirect("adminUI.jsp");
		}
		Statement stmt1 = con.createStatement();
		String query1 = "SELECT * from associatedaccount;";
		
	    ResultSet rs1 = stmt1.executeQuery(query1);
	    
	    out.println("<h2>Here is the current information of accounts in the database.</h2>");
	    out.println("<table border='1'>");
	    out.println("<tr><th>Username</th><th>Password</th><th>Reservation Portfolio</th><th>CID/ID</th></tr>");

	    while (rs1.next()) {
	        out.println("<tr>");
	        out.println("<td>" + rs1.getString("username") + "</td>");
	        out.println("<td>" + rs1.getString("password") + "</td>");
	        out.println("<td>" + rs1.getString("reservationPortfolio") + "</td>");
	        out.println("<td>" + rs1.getString("CID") + "</td>");
	        out.println("</tr>");
	    }
	    out.println("</table>");
	    rs1.close();
	    stmt1.close();
		

	    if(request.getParameter("add") != null) {
	    	
	    	String username = (String) request.getParameter("username");
	    	String password = (String) request.getParameter("password");
	    	String reservationPortfolio = (String) request.getParameter("reservationPortfolio");
	    	String CID = (String) request.getParameter("CID");
	    	
	    	Statement stmt = con.createStatement();
			String operation = "INSERT INTO customer VALUES ('filler', 'filler', '" + CID + "', '')";
		    stmt.executeUpdate(operation);
		    operation = "INSERT INTO associatedaccount VALUES ('" + username + "', '" + password + "', '" + reservationPortfolio + "', '" + CID + "') ";
			stmt.executeUpdate(operation);
		    stmt.close();
		    response.setHeader("Refresh", "0; URL=http://localhost:8080/TravelProject/manageUsers.jsp");

		}
		else if(request.getParameter("edit") != null) {
			
			String username = "";
			if(request.getParameter("username") != null) {
				username = (String) request.getParameter("username");
			}
			String password = "";
			if(request.getParameter("password") != null) {
				password = (String) request.getParameter("password");
			}
			String reservationPortfolio = "";
			if(request.getParameter("reservationPortfolio") != null) {
				reservationPortfolio = (String) request.getParameter("reservationPortfolio");
			}
			String CID = "";
			if(request.getParameter("CID") != null) {
				CID = (String) request.getParameter("CID");
			}
			
			if (!CID.equals("")) {
				
				if(!username.equals("")) {
					Statement stmt = con.createStatement();
					String operation = "UPDATE associatedaccount " +
							"SET username = '" + username + "' " +
							"WHERE CID = '" + CID + "';";
				    stmt.executeUpdate(operation);
				    stmt.close();
				    response.setHeader("Refresh", "0; URL=http://localhost:8080/TravelProject/manageUsers.jsp");
				}
				if(!password.equals("")) {
					Statement stmt = con.createStatement();
					String operation = "UPDATE associatedaccount " +
							"SET password = '" + password + "' " +
							"WHERE CID = '" + CID + "';";
				    stmt.executeUpdate(operation);
				    stmt.close();
				    response.setHeader("Refresh", "0; URL=http://localhost:8080/TravelProject/manageUsers.jsp");
				}
				if(!reservationPortfolio.equals("")) {
					Statement stmt = con.createStatement();
					String operation = "UPDATE associatedaccount " +
							"SET reservationPortfolio = '" + reservationPortfolio + "' " +
							"WHERE CID = '" + CID + "';";
				    stmt.executeUpdate(operation);
				    stmt.close();
				    response.setHeader("Refresh", "0; URL=http://localhost:8080/TravelProject/manageUsers.jsp");
				}
			}
			
			
		}
		else if(request.getParameter("delete") != null) {
	    	String CID = (String) request.getParameter("CID");
	    	
	    	Statement stmt = con.createStatement();
			String operation = "DELETE FROM associatedaccount WHERE CID = '" + CID + "';";
		    stmt.executeUpdate(operation);
		    operation = "DELETE FROM customer WHERE CID = '" + CID + "';";
			stmt.executeUpdate(operation);
		    stmt.close();
		    response.setHeader("Refresh", "0; URL=http://localhost:8080/TravelProject/manageUsers.jsp");
		}
		
		con.close();
	} catch(Exception e) {
		e.printStackTrace();
	}

%>
	
</body>
</html>