<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Reserved Flights</title>
</head>
<body>
<form action="customerRepUI.jsp" method="get">
	<input type="submit" name="backToUI" value="Back To Customer Rep UI">
</form>
    <h2>Enter Customer ID to View Reserved Flights</h2>
    <form method="post">
        <label for="cidInput">Customer ID:</label>
        <input type="hidden" name="formType1" value="delete">
        <input type="text" id="cidInput" name="cidInput">
        <input type="submit" value="Submit CID">
    </form>
    <%
    if (request.getParameter("cidInput") != null) {
        String cid = request.getParameter("cidInput").trim();
        HttpSession ses = request.getSession();
        ses.setAttribute("CID", cid);
    }
%>

    <%
    String cid = request.getParameter("cidInput");

    if (cid != null && !cid.trim().isEmpty()) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            String query = "SELECT DISTINCT TicketHasFlight.ticketNumber, FlightAssignedTo.fnumber, departure, arrival, cancellationFee " +
					"FROM TicketReserves " +
					"INNER JOIN TicketHasFlight " +
					"ON TicketReserves.ticketNumber = TicketHasFlight.ticketNumber " +
					"INNER JOIN FlightAssignedTo " +
					"ON TicketHasFlight.fnumber = FlightAssignedTo.fnumber and TicketHasFlight.airlineID = FlightAssignedTo.airlineID " +
					"INNER JOIN Aircraft " +
					"WHERE TicketReserves.CID = ?"; 
            PreparedStatement pstmt = con.prepareStatement(query);
            pstmt.setString(1, cid);
            ResultSet rs = pstmt.executeQuery();

            if (!rs.isBeforeFirst()) {
                out.println("<p>No flights reserved for CID: " + cid + "</p>");
            } else {
                out.println("<table border='1'><tr><th>Ticket Number</th><th>Flight Number</th><th>Departure Date</th><th>Arrival Date</th><th>Cancel Flight</th><th>Cancellation Fee</th></tr>");
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("ticketNumber") + "</td>");
                    out.println("<td>" + rs.getString("fnumber") + "</td>");
                    out.println("<td>" + rs.getString("departure") + "</td>");
                    out.println("<td>" + rs.getString("arrival") + "</td>");
                    out.println("<td>");
                    out.println("<form method='POST'>");
                    out.println("<input type='hidden' name='formType' value='cancelFlight'>");
                    out.println("<input type='hidden' name='ticketNumber' value='" + rs.getString("ticketNumber") + "'>");
                    out.println("<input type='submit' name='cancelReservation' value='Cancel Reservation'>");
                    out.println("</form>");
                    out.println("</td>");
                    out.println("<td>" + rs.getString("cancellationFee") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }
            rs.close();
            pstmt.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    %>
    <% 
    	String formType = request.getParameter("formType");
    	String flightToDelete = request.getParameter("ticketNumber");

    	if ("cancelFlight".equals(formType)) {
    	if (flightToDelete != null && !flightToDelete.trim().isEmpty()) {
        	try {
            	ApplicationDB db = new ApplicationDB();
            	Connection con = db.getConnection();
            	
            	HttpSession ses = request.getSession();
            	String usercid = (String) session.getAttribute("CID");
            	
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
                    		for (String cidToNotify : customersToNotify){
                    			if(cidToNotify!=""){
                    				pstmt = con.prepareStatement("SELECT notifications from Customer WHERE CID = '" + cidToNotify + "';");
                                	ResultSet rs4 = pstmt.executeQuery();
                                	while (rs4.next()){
                                		String notifications = rs4.getString("notifications");
                                    	notifications += "Spot opened up for flight [" + fnumber + "] which you were on the waitlist for! :";
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
				
            	String deleteQuery = "DELETE FROM TicketReserves WHERE ticketNumber = ? AND CID = ?";
            	PreparedStatement pstmt2 = con.prepareStatement(deleteQuery);
            	pstmt2.setString(1, flightToDelete);
            	pstmt2.setString(2, usercid);
            	int rowAffected = pstmt2.executeUpdate();
            	if (rowAffected > 0) {
                	out.println("<p>Flight reservation deleted successfully.</p>");
            	}
            	pstmt2.close();
            	con.close();
        	} catch (Exception e) {
            	e.printStackTrace();
        	}
    	}
    	}
    %>
    </body>
    </html>
