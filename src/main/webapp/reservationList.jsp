<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
    <!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Reservation List</title>
</head>
<body>

<form method="GET">
	<input type="submit" name="backToHome" value="Back To Admin Home">
</form><br><br>

<form method="GET">
	Only input a value for flight number OR customer name, not both.<br>
	<label for="flightNumber">Flight Number:</label><br>
	<input type="text" id="flightNumber" name="flightNumber"><br>
	<label for="customerName">Customer Name (First and Last Name):</label><br>
	<input type="text" id="customerName" name="customerName"><br>
	<input type="submit" name="showReservationsList" value="Find Reservations">
</form><br>

<%
	try{
		HttpSession ses = request.getSession();
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		String flightNumber = "";
		if(request.getParameter("flightNumber") != null) {
			flightNumber = (String) request.getParameter("flightNumber");
		}
		
		if(request.getParameter("backToHome") != null) {
			response.sendRedirect("adminUI.jsp");
		}
		else if(request.getParameter("showReservationsList") != null) {
			if(!flightNumber.equals("")) {
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
			}
			else if(request.getParameter("customerName") != null){
				String name = (String) request.getParameter("customerName");
				int index = name.indexOf(' ');
				String firstName = name.substring(0, index);
				String lastName = name.substring(index+1);
				Statement stmt = con.createStatement();
				String query = "SELECT c.lastName, c.firstName, tr.cid, f.airlineID, tf.fnumber, tf.ticketNumber " +
						"FROM flightassignedto f " +
						"JOIN tickethasflight tf ON f.fnumber = tf.fnumber AND f.airlineID = tf.airlineID " +
						"JOIN ticketreserves tr ON tf.ticketNumber = tr.ticketNumber " +
						"JOIN customer c ON tr.CID = c.CID " +
						"WHERE c.lastName = '" + lastName  + "' AND c.firstName = '" + firstName + "' " +
						"ORDER BY c.lastName, c.firstName, f.airlineID ";
				
			    ResultSet rs = stmt.executeQuery(query);
			    
			    out.println("<h2>Here is the reservation list.</h2>");
			    out.println("<table border='1'>");
			    out.println("<tr><th>Last Name</th><th>First Name</th><th>Customer ID</th><th>Airline ID</th><th>Flight Number</th><th>Ticket Number</th></tr>");

			    while (rs.next()) {
			        out.println("<tr>");
			        out.println("<td>" + rs.getString("lastName") + "</td>");
			        out.println("<td>" + rs.getString("firstName") + "</td>");
			        out.println("<td>" + rs.getString("cid") + "</td>");
			        out.println("<td>" + rs.getString("airlineID") + "</td>");
			        out.println("<td>" + rs.getString("fnumber") + "</td>");
			        out.println("<td>" + rs.getString("ticketNumber") + "</td>");
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
