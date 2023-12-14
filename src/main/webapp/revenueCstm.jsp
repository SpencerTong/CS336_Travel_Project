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
			String query = "SELECT c.CID, c.lastName, c.firstName, COUNT(tr.ticketNumber) AS numberOfTickets, SUM(tr.totalFare) AS totalRevenue " +
					"FROM customer c " +
					"JOIN ticketreserves tr ON c.CID = tr.CID " +
					"GROUP BY c.CID " +
					"ORDER BY totalRevenue DESC LIMIT 1 ";
			
		    ResultSet rs = stmt.executeQuery(query);
		    
		    out.println("<h2>Here is the customer who generated the most total revenue.</h2>");
		    out.println("<table border='1'>");
		    out.println("<tr><th>Customer ID</th><th>Last Name</th><th>First Name</th><th>Tickets Bought</th><th>Total Revenue</th></tr>");

		    while (rs.next()) {
		        out.println("<tr>");
		        out.println("<td>" + rs.getString("CID") + "</td>");
		        out.println("<td>" + rs.getString("lastName") + "</td>");
		        out.println("<td>" + rs.getString("firstName") + "</td>");
		        out.println("<td>" + rs.getString("numberOfTickets") + "</td>");
		        out.println("<td>" + "$" + rs.getString("totalRevenue") + "</td>");
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

</body>
</html>