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
	String query = "SELECT DISTINCT TicketHasFlight.ticketNumber, FlightAssignedTo.fnumber, departure, arrival " +
					"FROM TicketReserves " +
					"INNER JOIN TicketHasFlight " +
					"ON TicketReserves.ticketNumber = TicketHasFlight.ticketNumber " +
					"INNER JOIN FlightAssignedTo " +
					"ON TicketHasFlight.fnumber = FlightAssignedTo.fnumber and TicketHasFlight.airlineID = FlightAssignedTo.airlineID " +
					"INNER JOIN Aircraft " +
					"WHERE TicketReserves.CID = " + userCID; 
	if (request.getParameter("displayPastFlights") != null) {
    	query += " AND FlightAssignedTo.departure < CURDATE();";
	} else if (request.getParameter("displayUpcomingFlights") != null) {
	    query += " AND FlightAssignedTo.departure > CURDATE();";
	} else if (request.getParameter("cancelReservation") != null) {
    	String deleteInfoQuery = "SELECT * FROM TicketReserves INNER JOIN TicketHasFlight ON TicketReserves.ticketNumber = TicketHasFlight.ticketNumber WHERE TicketReserves.ticketNumber = (?);";
        String ticketNumber = request.getParameter("ticketNumber");
        PreparedStatement pstmt = con.prepareStatement(deleteInfoQuery);

        pstmt.setString(1, ticketNumber);
        ResultSet rs2 = pstmt.executeQuery();
    	
        while (rs2.next()){
         	String fnumber = rs2.getString("fnumber");
        	pstmt = con.prepareStatement("SELECT waitlist FROM FlightAssignedTo WHERE fnumber = '" + fnumber + "';");
        	ResultSet rs3 = pstmt.executeQuery();
        	while (rs3.next()){
        		if (rs3.getString("waitlist")!=null){
        			String[] customersToNotify = rs3.getString("waitlist").split(":");
            		for (String cid : customersToNotify){
            			if(cid!=""){
            				pstmt = con.prepareStatement("SELECT notifications from Customer WHERE CID = '" + cid + "';");
                        	ResultSet rs4 = pstmt.executeQuery();
                        	while (rs4.next()){
                        		String notifications = rs4.getString("notifications");
                            	notifications += ":Spot opened up for flight " + fnumber + " which you were on the waitlist for!";
                            	pstmt = con.prepareStatement("UPDATE Customer SET notifications = '" + notifications + "' WHERE CID = '" + cid + "';");
        						pstmt.executeUpdate();
                        	}
            			}
            		}
        		}
        		
        	}
        	rs3.close();
        }
        
        rs2.close();
        
        
        pstmt = con.prepareStatement("DELETE FROM TicketReserves WHERE ticketNumber = (?)");
        pstmt.setString(1, ticketNumber);
		pstmt.executeUpdate();
		pstmt.close();
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
        out.println("<input type='submit' name='cancelReservation' value='Cancel Reservation'>");
        out.println("</form>");
        out.println("</td>");
        // Add other columns as needed
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