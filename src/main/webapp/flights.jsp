<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html>
<html>
<head>
    <title>Flight List</title>
</head>
<body>
    <h2>Enter Airport ID to Find Flights</h2>
    <form action="flights.jsp" method="get">
        Airport ID: <input type="text" name="airportId">
        <input type="submit" value="Submit">
    </form>
</body>
<%
    String airportId = request.getParameter("airportId");
    if(airportId != null && !airportId.isEmpty()) {
        try {
        	ApplicationDB db = new ApplicationDB();	
    		Connection con = db.getConnection();

            // Query to find flights associated with the given airport ID
            String sql = "SELECT * FROM FlightAssignedTo WHERE fromAirport = '" + airportId + "' OR toAirport = '" + airportId + "'";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            // Display the result
            out.println("<h2>Flights for Airport ID: " + airportId + "</h2>");
            while (rs.next()) {
                int fnumber = rs.getInt("fnumber");
                String departure = rs.getString("departure");
                String arrival = rs.getString("arrival");
                String fromAirport = rs.getString("fromAirport");
                String toAirport = rs.getString("toAirport");

                out.println("Flight Number: " + fnumber + ", Departure: " + departure + ", Arrival: " + arrival + ", From: " + fromAirport + ", To: " + toAirport + "<br>");
            }
            rs.close();
            stmt.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        
        }
    }
%>
</html>