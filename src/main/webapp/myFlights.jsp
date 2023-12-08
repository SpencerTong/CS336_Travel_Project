<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Flights</title>
</head>
<body>
<h1>Display Flights</h1>

<form method="GET">
	<input type="submit" name="displayAllFlights" value="Display All Flights">
    <input type="submit" name="displayUpcomingFlights" value="Display Upcoming Flights">
    <input type="submit" name="displayPastFlights" value="Display Past Flights">
</form>
<%
	try {
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	String userCID = /* request.getParameter("CID"); */ "'sxt'";


	Statement stmt = con.createStatement();
	String query = "SELECT * " +
					"FROM TicketReserves " +
					"INNER JOIN TicketHasFlight " +
					"ON TicketReserves.ticketNumber = TicketHasFlight.ticketNumber " +
					"INNER JOIN FlightAssignedTo " +
					"ON TicketHasFlight.fnumber = FlightAssignedTo.fnumber and TicketHasFlight.airlineID = FlightAssignedTo.airlineID " +
					"WHERE TicketReserves.CID = " + userCID; 
	if (request.getParameter("displayPastFlights") != null) {
    	query += " AND FlightAssignedTo.departure < CURDATE();";
	} else if (request.getParameter("displayUpcomingFlights") != null) {
	    query += " AND FlightAssignedTo.departure > CURDATE();";
	} 
	
    ResultSet rs = stmt.executeQuery(query);

    out.println("<h2>Flight Information</h2>");
    out.println("<table border='1'>");
    out.println("<tr><th>Ticket Number</th><th>Flight Number</th><th>Departure Date</th><th>Arrival Date</th><th>Other Columns...</th></tr>");

    while (rs.next()) {
        out.println("<tr>");
        out.println("<td>" + rs.getString("ticketNumber") + "</td>");
        out.println("<td>" + rs.getString("fnumber") + "</td>");
        out.println("<td>" + rs.getString("departure") + "</td>");
        out.println("<td>" + rs.getString("arrival") + "</td>");
        out.println("<td>");
        out.println("<form method='POST'>");
        out.println("<input type='hidden' name='ticketNumber' value='" + rs.getString("ticketNumber") + "'>");
        out.println("<input type='submit' value='Cancel Reservation'>");
        out.println("</form>");
        out.println("</td>");
        // Add other columns as needed
        out.println("</tr>");
    }

    out.println("</table>");
    
    String deleteQuery = "DELETE FROM TicketReserves WHERE ticketNumber = ?";
    String ticketNumber = request.getParameter("ticketNumber");
    PreparedStatement pstmt = con.prepareStatement(deleteQuery);
    pstmt.setString(1, ticketNumber);
    int rowsDeleted = pstmt.executeUpdate();
    rs.close();
    stmt.close();
    con.close();

	} catch (Exception e) {
        e.printStackTrace();
	}





%>
</body>
</html>