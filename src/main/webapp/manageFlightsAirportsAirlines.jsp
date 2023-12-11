<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Airports and Flights</title>
</head>
<body>
	<fieldset>
    <h2>Manage Airports</h2>
    
    <!-- Add Airport Form -->
    <h3>Add Airport</h3>
    <form method="post">
        Airport ID: <input type="text" name="airportID"><br>
        <input type="submit" value="Add Airport">
    </form>
    <%
        String airportID = request.getParameter("airportID");
        try {
        	ApplicationDB db = new ApplicationDB();	
    		Connection con = db.getConnection();
    		
            String sql = "INSERT INTO Airport (airportID) VALUES (?)";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, airportID);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<p>Airport added successfully!</p>");
            } else {
                out.println("<p>Error adding airport.</p>");
            }
            pstmt.close();
            con.close();
        } catch(Exception e) {
            e.printStackTrace();
            out.println("<p>Error adding airport.</p>");
        } 
    %>

    <!-- Edit Airport Form -->
    <h3>Edit Airport</h3>

    <!-- Delete Airport Form -->
    <h3>Delete Airport</h3>
    <form method="post">
        <label for="airportID">Select Airport:</label>
        <select name="airportID" id="airportID">
            <%
                try {
                	ApplicationDB db = new ApplicationDB();	
            		Connection con = db.getConnection();
            		
                    Statement stmt = con.createStatement();
                    String sql = "SELECT airportID FROM Airport";
                    ResultSet rs = stmt.executeQuery(sql);

                    while(rs.next()) {
                        out.println("<option value='" + rs.getString("airportID") + "'>" + rs.getString("airportID") + "</option>");
                    }
                    
                    rs.close();
                    stmt.close();
                	con.close();
                } catch(Exception e) {
                    e.printStackTrace();
                } 
            	
            %>
        </select>
        <br>
        <br>
        <input type="submit" value="Delete Airport">
    </form>
    <%
        try {
        	ApplicationDB db = new ApplicationDB();	
    		Connection con = db.getConnection();
    		
            String sql = "DELETE FROM Airport WHERE airportID = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, (airportID));
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<p>Airport deleted successfully!</p>");
            } else {
                out.println("<p>No airport found with the specified id.</p>");
            }
            
            pstmt.close();
            con.close();
        } catch(Exception e) {
            e.printStackTrace();
            out.println("<p>Error deleting airport.</p>");
        } 
    %>
    </fieldset>
    
	<fieldset>
    <h2>Manage Flights</h2>

    <!-- Add Flight Form -->
    <h3>Add Flight</h3>
    <form action="addFlightAction.jsp" method="post"> <!-- Replace with actual action page -->
        Flight Number: <input type="text" name="flightNumber"><br>
        <!-- Other flight fields -->
        <input type="submit" value="Add Flight">
    </form>

    <!-- Edit Flight Form -->
    <h3>Edit Flight</h3>
    <!-- Form to select and edit a flight -->

    <!-- Delete Flight Form -->
    <h3>Delete Flight</h3>
    <!-- Form to select and delete a flight -->
    </fieldset>
    
    <fieldset>
    <h2>Manage Aircrafts</h2>
    
    <h3>Add Aircraft</h3>
    <form method="post"> <!-- Replace with actual action page -->
        Airline ID: <input type="text" name="aircraftID"><br>
        <input type="submit" value="Add Aircraft">
    </form>

    <!-- Edit Flight Form -->
    <h3>Edit Aircraft</h3>
    <!-- Form to select and edit a flight -->

    <!-- Delete Flight Form -->
    <h3>Delete Aircraft</h3>
    <form method="post">
        <label for="aircraftID">Select Aircraft:</label>
        <select name="aircraftID" id="aircraftID">
            <%
                try {
                	ApplicationDB db = new ApplicationDB();	
            		Connection con = db.getConnection();
            		
                    Statement stmt = con.createStatement();
                    String sql = "SELECT aircraftID FROM Aircraft";
                    ResultSet rs = stmt.executeQuery(sql);

                    while(rs.next()) {
                        out.println("<option value='" + rs.getString("aircraftID") + "'>" + rs.getString("aircraftID") + "</option>");
                    }
                    
                    rs.close();
                    stmt.close();
                	con.close();
                } catch(Exception e) {
                    e.printStackTrace();
                } 
            	
            %>
        </select>
        <br>
        <br>
        <input type="submit" value="Delete Aircraft">
    </form>
    <%
        String airlineID = request.getParameter("aircraftID");
        try {
        	ApplicationDB db = new ApplicationDB();	
    		Connection con = db.getConnection();
    		
            String sql = "DELETE FROM Aircraft WHERE aircraftID = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, (airlineID));
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<p>Aircraft deleted successfully!</p>");
            } else {
                out.println("<p>No aircraft found with the specified id.</p>");
            }
            
            pstmt.close();
            con.close();
        } catch(Exception e) {
            e.printStackTrace();
            out.println("<p>Error deleting aircraft, aircraft has a flight scheduled.</p>");
        } 
    %>
    </fieldset>
    
    

    <!-- Include server-side scripting for handling form submissions -->

</body>
</html>