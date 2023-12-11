<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Waitlist Passengers</title>
</head>
<body>
    <h2>Waitlist Passengers</h2>
    
    <%
    	PreparedStatement pstmt = null;
    	String flightNumber = request.getParameter("fnumber");
        try {
        	ApplicationDB db = new ApplicationDB();	
    		Connection con = db.getConnection();

            String sql = "SELECT waitlist FROM FlightAssignedTo WHERE fnumber = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(flightNumber));
            ResultSet rs = pstmt.executeQuery();

            while(rs.next()) {
                String waitlist = rs.getString("waitlist");
                String[] passengers = waitlist.split(":");

                out.println("<h3>Flight Waitlist:</h3>");
                for (String passenger : passengers) {
                    out.println("<p>" + passenger + "</p>");
                }
            }
            pstmt.close();
            con.close();
            rs.close();
        } catch(Exception e) {
            e.printStackTrace();
        } 
    %>
    <a href="flightListForWaitlist.jsp" class="button">Back to Flights</a>
</body>
</html>