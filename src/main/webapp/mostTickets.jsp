<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
    <!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Most Lucrative Flights</title>
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
			String query = "SELECT fat.fnumber, fat.airlineID, fat.departure, fat.arrival, fat.fromAirport, fat.toAirport, fat.numStops, fat.travelType, COUNT(thf.ticketNumber) AS ticketsSold " +
					"FROM flightassignedto fat " +
					"LEFT JOIN tickethasflight thf ON fat.fnumber = thf.fnumber AND fat.airlineID = thf.airlineID " +
					"GROUP BY fat.fnumber, fat.airlineID, fat.departure, fat.arrival, fat.fromAirport, fat.toAirport, fat.numStops, fat.travelType " +
					"ORDER BY ticketsSold DESC ";
			
		    ResultSet rs = stmt.executeQuery(query);
		    
		    out.println("<h2>Here are the flights, sorted by how many tickets they sold.</h2>");
		    out.println("<table border='1'>");
		    out.println("<tr><th>Flight Number</th><th>Airline ID</th><th>Departure Time</th><th>Arrival Time</th><th>Departure Airport</th><th>Arrival Airport</th><th>Stops</th><th>Travel Type</th><th>Tickets Sold</th></tr>");

		    while (rs.next()) {
		        out.println("<tr>");
		        out.println("<td>" + rs.getString("fnumber") + "</td>");
		        out.println("<td>" + rs.getString("airlineID") + "</td>");
		        out.println("<td>" + rs.getString("departure") + "</td>");
		        out.println("<td>" + rs.getString("arrival") + "</td>");
		        out.println("<td>" + rs.getString("fromAirport") + "</td>");
		        out.println("<td>" + rs.getString("toAirport") + "</td>");
		        out.println("<td>" + rs.getString("numStops") + "</td>");
		        out.println("<td>" + rs.getString("travelType") + "</td>");
		        out.println("<td>" + rs.getString("ticketsSold") + "</td>");
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