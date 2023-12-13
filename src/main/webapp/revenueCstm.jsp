<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
    <!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Greatest Customer Of All Time</title>
</head>
<body>

	<form method="GET">
		<input type="submit" name="backToHome" value="Back To Admin Home">
	</form><br><br>

	<%
		try{
			HttpSession ses = request.getSession();
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			if(request.getParameter("backToHome") != null) {
				response.sendRedirect("adminUI.jsp");
			}
			
			Statement stmt = con.createStatement();
			String query = "SELECT tf.airlineID, tf.fnumber, tr.ticketNumber, tr.CID " +
					"FROM tickethasflight tf " +
					"JOIN ticketreserves tr ON tf.ticketNumber = tr.ticketNumber " +
					"WHERE tf.fnumber = " + flightNumber + " " + 
					"ORDER BY tf.airlineID ";
			
		    ResultSet rs = stmt.executeQuery(query);
		    
		    out.println("<h2>Here is the reservation list.</h2>");
		    out.println("<table border='1'>");
		    out.println("<tr><th>Airline</th><th>Flight Number</th><th>Ticket Number</th><th>Customer ID</th></tr>");

		    while (rs.next()) {
		        out.println("<tr>");
		        out.println("<td>" + rs.getString("airlineID") + "</td>");
		        out.println("<td>" + rs.getString("fnumber") + "</td>");
		        out.println("<td>" + rs.getString("ticketNumber") + "</td>");
		        out.println("<td>" + rs.getString("CID") + "</td>");
		        out.println("<td>");
		        out.println("</tr>");
		    }
		    out.println("</table>");
		    rs.close();
		    stmt.close();
		    con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	%>

	<h2>Here is the customer that generated the most revenue.</h2>

</body>
</html>