<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<!--Import necessary libraries -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
    <title>Flight List</title>
</head>
<body>
<form action="customerRepUI.jsp" method="get">
	<input type="submit" name="backToUI" value="Back To Customer Rep UI">
</form>
    <h2>Enter Airport ID to Find Flights</h2>
    <form action="flights.jsp" method="get">
        Airport ID: <input type="text" name="airportId">
        <input type="submit" value="Submit">
    </form>
    <%
        String airportId = request.getParameter("airportId");
        if(airportId != null && !airportId.isEmpty()) {
            try {
                ApplicationDB db = new ApplicationDB();    
                Connection con = db.getConnection();

                String checkAirportSql = "SELECT COUNT(*) AS airportCount FROM Airport WHERE airportID = ?";
                PreparedStatement pstmt = con.prepareStatement(checkAirportSql);
                pstmt.setString(1, airportId);
                ResultSet rsCheck = pstmt.executeQuery();
                int airportCount = 0;
                if(rsCheck.next()) {
                    airportCount = rsCheck.getInt("airportCount");
                }
                rsCheck.close();
                pstmt.close();

                if(airportCount == 0) {
                    out.println("<p>Airport does not exist.</p>");
                } else {
                    String sql = "SELECT * FROM FlightAssignedTo WHERE fromAirport = ? OR toAirport = ?";
                    pstmt = con.prepareStatement(sql);
                    pstmt.setString(1, airportId);
                    pstmt.setString(2, airportId);
                    ResultSet rs = pstmt.executeQuery();

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
                    pstmt.close();
                }
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    %>
</body>
</html>