<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
    <!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Revenue Summaries</title>
</head>
<body>

	<form method="GET">
		<input type="submit" name="backToHome" value="Back To Admin Home">
	</form><br><br>
	
	<form method="GET">
		Only input a value for any one of the below parameters.<br>
		<label for="flight">Flight (i.e., CD456):</label><br>
		<input type="text" id="flight" name="flight"><br>
		<label for="airlineID">Airline ID:</label><br>
		<input type="text" id="airlineID" name="airlineID"><br>
		<label for="CID">Customer ID:</label><br>
		<input type="text" id="CID" name="CID"><br>
		<input type="submit" name="displayRevenue" value="Display Revenue According to Parameters">
	</form><br>
	
	<%
	try{
		HttpSession ses = request.getSession();
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		String flight = "";
		if(request.getParameter("flight") != null) {
			flight = (String) request.getParameter("flight").toUpperCase();
		}
		String airlineID = "";
		if(request.getParameter("airlineID") != null) {
			airlineID = (String) request.getParameter("airlineID").toUpperCase();
		}
		String CID = "";
		if(request.getParameter("CID") != null) {
			CID = (String) request.getParameter("CID");
		}
		
		if(request.getParameter("backToHome") != null) {
			response.sendRedirect("adminUI.jsp");
		}
		else if(request.getParameter("displayRevenue") != null) {
			
			if(!flight.equals("")) {
				String aID = flight.substring(0,2);
				String flightNumber = flight.substring(2);
				Statement stmt = con.createStatement();
				String query = "SELECT f.airlineID, f.fnumber, COUNT(tf.ticketNumber) AS totalTickets, SUM(tr.totalFare) AS totalRevenue " +
						"FROM flightassignedto f " +
						"JOIN tickethasflight tf ON f.fnumber = tf.fnumber AND f.airlineID = tf.airlineID " +
						"JOIN ticketreserves tr ON tf.ticketNumber = tr.ticketNumber " +
						"WHERE f.fnumber = " + flightNumber + " AND f.airlineID = '" + aID + "' " +
						"GROUP BY f.fnumber, f.airlineID ";
				
			    ResultSet rs = stmt.executeQuery(query);
			    
			    out.println("<h2>Here is the generated revenue summary according to flight " + flight + ".</h2>");
			    out.println("<table border='1'>");
			    out.println("<tr><th>Airline</th><th>Flight Number</th><th>Total Tickets</th><th>Total Revenue</th></tr>");

			    while (rs.next()) {
			        out.println("<tr>");
			        out.println("<td>" + rs.getString("airlineID") + "</td>");
			        out.println("<td>" + rs.getString("fnumber") + "</td>");
			        out.println("<td>" + rs.getString("totalTickets") + "</td>");
			        out.println("<td>" + "$" + rs.getString("totalRevenue") + "</td>");
			        out.println("<td>");
			        out.println("</tr>");
			    }
			    out.println("</table>");
			    rs.close();
			    stmt.close();
			}
			else if(!airlineID.equals("")) {
			//else if(request.getParameter("airlineiD") != null){
				Statement stmt = con.createStatement();
				String query = "SELECT f.airlineID, COUNT(tf.ticketNumber) AS totalTickets, SUM(tr.totalFare) AS totalRevenue " +
						"FROM flightassignedto f " +
						"JOIN tickethasflight tf ON f.fnumber = tf.fnumber AND f.airlineID = tf.airlineID " +
						"JOIN ticketreserves tr ON tf.ticketNumber = tr.ticketNumber " +
						"WHERE f.airlineID = '" + airlineID + "' " +
						"GROUP BY f.airlineID ";
				
			    ResultSet rs = stmt.executeQuery(query);
			    
			    out.println("<h2>Here is the generated revenue summary according to airline " + airlineID + ".</h2>");
			    out.println("<table border='1'>");
			    out.println("<tr><th>Airline</th><th>Total Tickets</th><th>Total Revenue</th></tr>");

			    while (rs.next()) {
			        out.println("<tr>");
			        out.println("<td>" + rs.getString("airlineID") + "</td>");
			        out.println("<td>" + rs.getString("totalTickets") + "</td>");
			        out.println("<td>" + "$" + rs.getString("totalRevenue") + "</td>");
			        out.println("<td>");
			        out.println("</tr>");
			    }
			    out.println("</table>");
			    rs.close();
			    stmt.close();
			}
			else if(!CID.equals("")){
				Statement stmt = con.createStatement();
				String query = "SELECT tr.CID, c.lastName, c.firstName, COUNT(tf.ticketNumber) AS totalTickets, SUM(tr.totalFare) AS totalRevenue " +
						"FROM ticketreserves tr " +
						"JOIN tickethasflight tf ON tr.ticketNumber = tf.ticketNumber " +
						"JOIN customer c ON tr.CID = c.CID " +
						"WHERE tr.CID = '" + CID + "' " +
						"GROUP BY tr.CID, c.lastName, c.firstName ";
				
			    ResultSet rs = stmt.executeQuery(query);
			    
			    out.println("<h2>Here is the generated revenue summary according to customer ID " + CID + ".</h2>");
			    out.println("<table border='1'>");
			    out.println("<tr><th>Customer ID</th><th>Last Name</th><th>First Name</th><th>Total Tickets</th><th>Total Revenue</th></tr>");

			    while (rs.next()) {
			        out.println("<tr>");
			        out.println("<td>" + rs.getString("CID") + "</td>");
			        out.println("<td>" + rs.getString("lastName") + "</td>");
			        out.println("<td>" + rs.getString("firstName") + "</td>");
			        out.println("<td>" + rs.getString("totalTickets") + "</td>");
			        out.println("<td>" + "$" + rs.getString("totalRevenue") + "</td>");
			        out.println("<td>");
			        out.println("</tr>");
			    }
			    out.println("</table>");
			    rs.close();
			    stmt.close();
			}
		}
		con.close();
	} catch(Exception e) {
		e.printStackTrace();
	}

%>
	
</body>
</html>