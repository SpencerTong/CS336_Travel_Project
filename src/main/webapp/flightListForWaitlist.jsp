<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Flights and Waitlists</title>
</head>
<body>
<form action="customerRepUI.jsp" method="get">
	<input type="submit" name="backToUI" value="Back To Customer Rep UI">
</form>
    <h2>Flights and Their Waitlists</h2>
    <table border="1">
        <tr>
            <th>Flight Number</th>
            <th>Departure</th>
            <th>Arrival</th>
            <th>Check Waitlist</th>
        </tr>
    <%
        try {
        	ApplicationDB db = new ApplicationDB();	
    		Connection con = db.getConnection();

            Statement stmt = con.createStatement();
            
            String sql = "SELECT fnumber, departure, arrival FROM FlightAssignedTo";
            ResultSet rs = stmt.executeQuery(sql);

            while(rs.next()) {
            	int fnumber = rs.getInt("fnumber");
                String departure = rs.getString("departure");
                String arrival = rs.getString("arrival");

                out.println("<tr>");
                out.println("<td>" + fnumber + "</td>");
                out.println("<td>" + departure + "</td>");
                out.println("<td>" + arrival + "</td>");
                
                out.println("<td>");
                out.println("<form method='post'>");
                out.println("<input type='hidden' name='fnumber' value='" + fnumber + "'/>");
                out.println("<input type='submit' value='Check Waitlist'/>");
                out.println("</form>");
                out.println("</td>");
                out.println("</tr>");
            }
            rs.close();
            stmt.close();
            con.close();
        } catch(Exception e) {
            e.printStackTrace();
        } 

    %>
    </table>
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
</body>
</html>