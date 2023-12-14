<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.time.LocalDateTime,java.time.format.DateTimeFormatter"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Airports and Flights</title>
</head>
<body>
<form action="customerRepUI.jsp" method="get">
	<input type="submit" name="backToUI" value="Back To Customer Rep UI">
</form>
	<fieldset>
    <h2>Manage Airports</h2>
    
    <!-- Add Airport Form -->
    <h3>Add Airport</h3>
    <form method="post">
    	<input type="hidden" name="formType1" value="add">
        Airport ID: <input type="text" name="airportID"><br>
        <input type="submit" value="Add Airport">
    </form>
    <%
    String formType1 = request.getParameter("formType1");
    String airportID = request.getParameter("airportID");
    if(!(formType1 == null) && formType1.equals("add")){
    if (airportID != null && !airportID.trim().isEmpty()) {
        
        try {
        	ApplicationDB db = new ApplicationDB();	
    		Connection con = db.getConnection();
    		
            String sql = "INSERT INTO Airport VALUES (?)";
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
    }
    }
    %>

    <!-- Edit Airport Form -->
    <h3>Edit Airport</h3>
    <form method="post">
    	<input type="hidden" name="formType2" value="edit">
        <label for="currentAirportID">Select Airport:</label>
        <select name="currentAirportID" id="currentAirportID">
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
        <label for="newAirportID">New Airport ID:</label>
        <input type="text" id="newAirportID" name="newAirportID"><br>
        <input type="submit" value="Update Airport">
    </form>
    <%
    String formType2 = request.getParameter("formType2");
    String currentAirportID = request.getParameter("currentAirportID");
    String newAirportID = request.getParameter("newAirportID");
    if(!(formType2 == null) && formType2.equals("edit")){
    if (currentAirportID != null && newAirportID != null && !currentAirportID.isEmpty() && !newAirportID.isEmpty()) {
        try {
        	ApplicationDB db = new ApplicationDB();	
    		Connection con = db.getConnection();
    		
            String sql = "UPDATE Airport SET airportID = ? WHERE airportID = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, newAirportID);
            pstmt.setString(2, currentAirportID);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<p>Airport ID updated successfully!</p>");
            } else {
                out.println("<p>Error updating airport ID.</p>");
            }
            pstmt.close();
            con.close();
        } catch(Exception e) {
            e.printStackTrace();
            out.println("<p>Error updating airport ID: " + e.getMessage() + "</p>");
        } 
    }
    }
%>

    <!-- Delete Airport Form -->
    <h3>Delete Airport</h3>
    <form method="post">
    	<input type="hidden" name="formType3" value="delete">
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
    	String formType3 = request.getParameter("formType3");
    	if(!(formType3 == null) && formType3.equals("delete")){
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
    	}
    %>
    </fieldset>
    
	<fieldset>
    <h2>Manage Flights</h2>

    <!-- Add Flight Form -->
    <h3>Add Flight</h3>
    <form method="post">
    	<input type="hidden" name="addFlight" value="add">
        <label for="fnumber">Flight Number:</label>
        <input type="text" id="fnumber" name="fnumber"><br>

        <label for="departureDate">Departure Date (YYYY-MM-DD):</label>
        <input type="date" id="departureDate" name="departureDate"><br>

        <label for="departureTime">Departure Time (HH:MM):</label>
        <input type="time" id="departureTime" name="departureTime"><br>

        <label for="arrivalDate">Arrival Date (YYYY-MM-DD):</label>
        <input type="date" id="arrivalDate" name="arrivalDate"><br>

        <label for="arrivalTime">Arrival Time (HH:MM):</label>
        <input type="time" id="arrivalTime" name="arrivalTime"><br>
        
        <label for="returnDepartureDate">Return Departure Date if applicable (YYYY-MM-DD):</label>
        <input type="date" id="returnDepartureDate" name="returnDepartureDate"><br>

        <label for="returnDepartureTime">Return Departure Time if applicable(HH:MM):</label>
        <input type="time" id="returnDepartureTime" name="returnDepartureTime"><br>

        <label for="returnArrivalDate">Return Arrival Date if applicable(YYYY-MM-DD):</label>
        <input type="date" id="returnArrivalDate" name="returnArrivalDate"><br>

        <label for="returnArrivalTime">Return Arrival Time if applicable(HH:MM):</label>
        <input type="time" id="returnArrivalTime" name="returnArrivalTime"><br>
        
        <label for="numStops">Number of Stops:</label>
        <input type="text" id="numStops" name="numStops"><br>
        
        <label for="basicPrice">Basic Price:</label>
        <input type="text" id="basicPrice" name="basicPrice"><br>
        
        <label for="premiumPrice">Premium Price:</label>
        <input type="text" id="premiumPrice" name="premiumPrice"><br>
        
        <label for="bookingFee">Booking Fee:</label>
        <input type="text" id="bookingFee" name="bookingFee"><br>

        <label for="fromAirport">From Airport:</label>
        <select id="fromAirport" name="fromAirport">
            <% 
            try {
                ApplicationDB db = new ApplicationDB();    
                Connection con = db.getConnection();
                
                Statement stmt = con.createStatement();
                String query = "SELECT airportID FROM Airport";
                ResultSet rs = stmt.executeQuery(query);

                while(rs.next()) {
                    String fromAirport = rs.getString("airportID");
                    out.println("<option value='" + fromAirport + "'>" + fromAirport + "</option>");
                }

                rs.close();
                stmt.close();
                con.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
            %>
        </select><br>

        <label for="toAirport">To Airport:</label>
        <select id="toAirport" name="toAirport">
            <% 
            try {
                ApplicationDB db = new ApplicationDB();    
                Connection con = db.getConnection();
                
                Statement stmt = con.createStatement();
                String query = "SELECT airportID FROM Airport";
                ResultSet rs = stmt.executeQuery(query);

                while(rs.next()) {
                    String toAirport = rs.getString("airportID");
                    out.println("<option value='" + toAirport + "'>" + toAirport + "</option>");
                }

                rs.close();
                stmt.close();
                con.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
            %>
        </select><br>

        <label for="airlineID">Airline ID:</label>
        <select id="airlineID" name="airlineID">
            <% 
            try {
                ApplicationDB db = new ApplicationDB();    
                Connection con = db.getConnection();
                
                Statement stmt = con.createStatement();
                String query = "SELECT airlineID FROM AirlineCompany";
                ResultSet rs = stmt.executeQuery(query);

                while(rs.next()) {
                    String airline = rs.getString("airlineID");
                    out.println("<option value='" + airline + "'>" + airline + "</option>");
                }

                rs.close();
                stmt.close();
                con.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
            %>
        </select><br>

        <label for="aircraftID">Aircraft ID:</label>
        <select id="aircraftID" name="aircraftID">
            <% 
            try {
                ApplicationDB db = new ApplicationDB();    
                Connection con = db.getConnection();
                
                Statement stmt = con.createStatement();
                String query = "SELECT aircraftID FROM Aircraft";
                ResultSet rs = stmt.executeQuery(query);

                while(rs.next()) {
                    String aircraft = rs.getString("aircraftID");
                    out.println("<option value='" + aircraft + "'>" + aircraft + "</option>");
                }

                rs.close();
                stmt.close();
                con.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
            %>
        </select><br>

        <input type="submit" value="Add Flight">
    </form>
    <%	
    	String addFlight = request.getParameter("addFlight");
        String fnumber = request.getParameter("fnumber");
        String departureDate = request.getParameter("departureDate");
        String arrivalDate = request.getParameter("arrivalDate");
        String departureTime = request.getParameter("departureTime");
        String arrivalTime = request.getParameter("arrivalTime");
        String returnDepartureDate = request.getParameter("returnDepartureDate");
        String returnArrivalDate = request.getParameter("returnArrivalDate");
        String returnDepartureTime = request.getParameter("returnDepartureTime");
        String returnArrivalTime = request.getParameter("returnArrivalTime");
        String fromAirport = request.getParameter("fromAirport");
        String toAirport = request.getParameter("toAirport");
        String addAirlineID = request.getParameter("airlineID");
        String addAircraftID = request.getParameter("aircraftID");
        String numStops = request.getParameter("numStops");
        String travelType = "";
        
        String basicPrice = request.getParameter("basicPrice");
        String premiumPrice = request.getParameter("premiumPrice");
        String bookingFee = request.getParameter("bookingFee");
        
        String departure = departureDate + " " + departureTime + ":00";
        String arrival = arrivalDate + " " + arrivalTime + ":00";
        
        String returnDeparture = null;
        String returnArrival = null;
        

		if(!(addFlight == null) && addFlight.equals("add")){
        if (fnumber != null && departure != null && arrival != null) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            try {
                ApplicationDB db = new ApplicationDB();    
                Connection con = db.getConnection();
                
                if(!returnDepartureDate.isEmpty() && !returnArrivalDate.isEmpty()){
                	returnDeparture = returnDepartureDate + " " + returnDepartureTime + ":00";
                	returnArrival = returnArrivalDate + " " + returnArrivalTime + ":00";
                }
                
                
                if(Integer.parseInt(numStops) > 1)
                	travelType = "r";
                else
                	travelType = "o";

                String sql = "INSERT INTO FlightAssignedTo (fnumber, departure, arrival, returnDeparture, returnArrival, fromAirport, toAirport, numStops, travelType, basicPrice, premiumPrice, bookingFee, airlineID, aircraftID, waitlist) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, '')";
                pstmt = con.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(fnumber));
                pstmt.setString(2, departure);
                pstmt.setString(3, arrival);
                pstmt.setString(4, returnDeparture);
                pstmt.setString(5, returnArrival);
                pstmt.setString(6, fromAirport);
                pstmt.setString(7, toAirport);
                pstmt.setInt(8, Integer.parseInt(numStops));
                pstmt.setString(9, travelType);
                pstmt.setFloat(10, Float.parseFloat(basicPrice));
                pstmt.setFloat(11, Float.parseFloat(premiumPrice));
                pstmt.setFloat(12, Float.parseFloat(bookingFee));
                pstmt.setString(13, addAirlineID);
                pstmt.setString(14, addAircraftID);

                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("<p>Flight added successfully!</p>");
                } else {
                    out.println("<p>Error adding flight.</p>");
                }
            } catch(Exception e) {
                e.printStackTrace();
                out.println("<p>Error adding flight: " + e.getMessage() + "</p>");
            } finally {
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            }
        }
		}
    %>


    <!-- Edit Flight Form -->
    <h3>Edit Flight</h3>
    <form method="post">
    	<input type="hidden" name="editFlight" value="edit">
        <label for="fnumberSelect">Select Flight Number:</label>
        <select id="fnumberSelect" name="fnumberSelect">
            <% 
                try {
                    ApplicationDB db = new ApplicationDB();
                    Connection con = db.getConnection();
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT fnumber FROM FlightAssignedTo");

                    while (rs.next()) {
                        int editfnumber = rs.getInt("fnumber");
                        out.println("<option value='" + editfnumber + "'>" + editfnumber + "</option>");
                    }
                    rs.close();
                    stmt.close();
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </select>
        <input type="submit" value="Edit Flight">
    </form>
    <%
        if ("post".equalsIgnoreCase(request.getMethod()) && !(request.getParameter("editFlight") == null) && request.getParameter("editFlight").equals("edit")) {
            String selectedFnumber = request.getParameter("fnumberSelect");
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();
                String query = "SELECT * FROM FlightAssignedTo WHERE fnumber = ?";
                PreparedStatement pstmt = con.prepareStatement(query);
                pstmt.setInt(1, Integer.parseInt(selectedFnumber));
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                	String editDeparture = rs.getTimestamp("departure").toLocalDateTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                	String editArrival = rs.getTimestamp("arrival").toLocalDateTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                	String editReturnArrival = null;
            		String editReturnDeparture = null;
                	
                	if(!(rs.getTimestamp("returnArrival") == null) && !(rs.getTimestamp("returnDeparture") == null)){
                		editReturnArrival = rs.getTimestamp("returnArrival").toLocalDateTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                		editReturnDeparture = rs.getTimestamp("returnDeparture").toLocalDateTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                	}
                	out.println("<form method='post'>");
                    out.println("<input type='hidden' name='fnumber' value='" + rs.getString("fnumber") + "'>");
                    out.println("<input type='hidden' name='editFlightForm' value='edit'>");
                    out.println("Departure: <input type='datetime-local' name='departure' value='" + editDeparture + "'><br>");
                    out.println("Arrival: <input type='datetime-local' name='arrival' value='" + editArrival + "'><br>");
                    out.println("Return Departure: <input type='datetime-local' name='returnDeparture' value='" + editReturnDeparture + "'><br>");
                    out.println("Return Arrival: <input type='datetime-local' name='returnArrival' value='" + editReturnArrival + "'><br>");
                    out.println("Number of Stops: <input type='number' name='numStops' value='" + rs.getInt("numStops") + "'><br>");
                    out.println("Travel Type: <input type='text' name='travelType' value='" + rs.getString("travelType") + "'><br>");
                    out.println("Basic Price: <input type='text' name='basicPrice' value='" + rs.getFloat("basicPrice") + "'><br>");
                    out.println("Premium Price: <input type='text' name='premiumPrice' value='" + rs.getFloat("premiumPrice") + "'><br>");
                    out.println("Booking Fee: <input type='text' name='bookingFee' value='" + rs.getFloat("bookingFee") + "'><br>");
                    
                    out.println("From Airport: <select name='fromAirport'>");
                    Statement stmt = con.createStatement();
                    ResultSet airports = stmt.executeQuery("SELECT airportID FROM Airport");
                    while (airports.next()) {
                        String editFromAirportID = airports.getString("airportID");
                        out.println("<option value='" + editFromAirportID + "'" + (editFromAirportID.equals(rs.getString("fromAirport")) ? " selected" : "") + ">" + editFromAirportID + "</option>");
                    }
                    out.println("</select><br>");

                    // Dropdown for toAirport
                    out.println("To Airport: <select name='toAirport'>");
                    airports.beforeFirst(); // Reset the ResultSet to reuse it
                    while (airports.next()) {
                        String editToAirport = airports.getString("airportID");
                        out.println("<option value='" + editToAirport + "'" + (editToAirport.equals(rs.getString("toAirport")) ? " selected" : "") + ">" + editToAirport + "</option>");
                    }
                    out.println("</select><br>");

                    // Dropdown for airlineID
                    out.println("Airline ID: <select name='airlineID'>");
                    ResultSet airlines = stmt.executeQuery("SELECT airlineID FROM AirlineCompany");
                    while (airlines.next()) {
                        String airlineID = airlines.getString("airlineID");
                        out.println("<option value='" + airlineID + "'" + (airlineID.equals(rs.getString("airlineID")) ? " selected" : "") + ">" + airlineID + "</option>");
                    }
                    out.println("</select><br>");

                    // Dropdown for aircraftID
                    out.println("Aircraft ID: <select name='aircraftID'>");
                    ResultSet aircrafts = stmt.executeQuery("SELECT aircraftID FROM Aircraft");
                    while (aircrafts.next()) {
                        String aircraftID = aircrafts.getString("aircraftID");
                        out.println("<option value='" + aircraftID + "'" + (aircraftID.equals(rs.getString("aircraftID")) ? " selected" : "") + ">" + aircraftID + "</option>");
                    }
                    out.println("</select><br>");
                    out.println("<input type='submit' value='Update Flight'>");
                    out.println("</form>");
                } else {
                    out.println("<p>Flight not found.</p>");
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
        String editfNumber = request.getParameter("fnumber");
        String editDeparture = request.getParameter("departure");
        String editArrival = request.getParameter("arrival");
        String editReturnDeparture = request.getParameter("returnDeparture");
        String editReturnArrival = request.getParameter("returnArrival");
        String editFromAirport = request.getParameter("fromAirport");
        String editToAirport = request.getParameter("toAirport");
        String editNumStops = request.getParameter("numStops");
        String editTravelType = request.getParameter("travelType");
        String editBasicPrice = request.getParameter("basicPrice");
        String editPremiumPrice = request.getParameter("premiumPrice");
        String editBookingFee = request.getParameter("bookingFee");
        String airlineID = request.getParameter("airlineID");
        String aircraftID = request.getParameter("aircraftID");
		
        String editFlightForm = request.getParameter("editFlightForm");
        if(!(editFlightForm == null) && editFlightForm.equals("edit")){
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            String updateQuery = "UPDATE FlightAssignedTo SET departure = ?, arrival = ?, returnDeparture = ?, returnArrival = ?, fromAirport = ?, toAirport = ?, numStops = ?, travelType = ?, basicPrice = ?, premiumPrice = ?, bookingFee = ?, airlineID = ?, aircraftID = ? WHERE fnumber = ?";
            PreparedStatement pstmt = con.prepareStatement(updateQuery);
            
            pstmt.setString(1, editDeparture);
            pstmt.setString(2, editArrival);
            pstmt.setString(3, editReturnDeparture.isEmpty() ? null : returnDeparture); // Handling empty values for optional fields
            pstmt.setString(4, editReturnArrival.isEmpty() ? null : returnArrival);
            pstmt.setString(5, editFromAirport);
            pstmt.setString(6, editToAirport);
            pstmt.setInt(7, Integer.parseInt(editNumStops));
            pstmt.setString(8, editTravelType);
            pstmt.setFloat(9, Float.parseFloat(editBasicPrice));
            pstmt.setFloat(10, Float.parseFloat(editPremiumPrice));
            pstmt.setFloat(11, Float.parseFloat(editBookingFee));
            pstmt.setString(12, airlineID);
            pstmt.setString(13, aircraftID);
            pstmt.setInt(14, Integer.parseInt(editfNumber));

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<p>Flight updated successfully.</p>");
            } else {
                out.println("<p>Error updating flight. Please check the details and try again.</p>");
            }

            pstmt.close();
            con.close();
        } catch (NumberFormatException e) {
            out.println("<p>Error: Invalid number format in input.</p>");
        } catch (SQLException e) {
            out.println("<p>Error: Unable to connect to the database or error in SQL syntax.</p>");
            e.printStackTrace();
        } catch (Exception e) {
            out.println("<p>Error: An unexpected error occurred.</p>");
            e.printStackTrace();
        }
        }
    %>

    <!-- Delete Flight Form -->
    <h3>Delete Flight</h3>
    <form method="post">
        <input type="hidden" name="deleteFlight" value="delete">
        <label for="deletefnumber">Select Flight Number:</label>
        <select id="deletefnumber" name="deletefnumber">
            <%
                try {
                    ApplicationDB db = new ApplicationDB(); 
                    Connection con = db.getConnection();
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT fnumber FROM FlightAssignedTo");

                    while (rs.next()) {
                        int deletefnumber = rs.getInt("fnumber");
                        out.println("<option value='" + deletefnumber + "'>" + deletefnumber + "</option>");
                    }
                    rs.close();
                    stmt.close();
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </select>
        <input type="submit" value="Delete Flight">
    </form>
    <%
    	String deleteFlight = request.getParameter("deleteFlight");
    	if(!(deleteFlight == null) && deleteFlight.equals("delete")){
        if ("post".equalsIgnoreCase(request.getMethod())) {
            String selectedFnumber = request.getParameter("deletefnumber");

            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();

                String deleteQuery = "DELETE FROM FlightAssignedTo WHERE fnumber = ?";
                PreparedStatement pstmt = con.prepareStatement(deleteQuery);
                pstmt.setInt(1, Integer.parseInt(selectedFnumber));

                int rowAffected = pstmt.executeUpdate();
                if (rowAffected > 0) {
                    out.println("<p>Flight with number " + selectedFnumber + " deleted successfully.</p>");
                } else {
                    out.println("<p>Error: Flight could not be deleted.</p>");
                }

                pstmt.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    	}
    %>
    </fieldset>
    
    <fieldset>
    <h2>Manage Aircrafts</h2>
    
    <h3>Add Aircraft</h3>
    <form method="post">
    	<input type="hidden" name="addAircraft" value="add">
        
        <label for="aircraftID">Aircraft ID:</label>
        <input type="text" id="aircraftID" name="aircraftID"><br>

        <label for="seats">Seats:</label>
        <input type="number" id="seats" name="seats"><br>

       <label>Operates On:</label><br>
        <input type="checkbox" id="monday" name="operates" value="M">
        <label for="monday">Monday</label><br>
        <input type="checkbox" id="tuesday" name="operates" value="T">
        <label for="tuesday">Tuesday</label><br>
        <input type="checkbox" id="wednesday" name="operates" value="W">
        <label for="wednesday">Wednesday</label><br>
        <input type="checkbox" id="thursday" name="operates" value="R">
        <label for="thursday">Thursday</label><br>
        <input type="checkbox" id="friday" name="operates" value="F">
        <label for="friday">Friday</label><br>
        <input type="checkbox" id="saturday" name="operates" value="S">
        <label for="saturday">Saturday</label><br>
        <input type="checkbox" id="sunday" name="operates" value="U">
        <label for="sunday">Sunday</label><br>

        <label for="airlineID">Airline ID:</label>
        <select id="airlineID" name="airlineID">
            <% 
            	try{
                	ApplicationDB db = new ApplicationDB();
                	Connection con = db.getConnection();
                	Statement stmt = con.createStatement();
                	ResultSet rs = stmt.executeQuery("SELECT airlineID FROM AirlineCompany");
                	while (rs.next()) {
                    	out.println("<option value='" + rs.getString("airlineID") + "'>" + rs.getString("airlineID") + "</option>");
                	}
                	rs.close();
                	stmt.close();
                	con.close();
            	}
            	catch(Exception e) {
                e.printStackTrace();
            	}
            %>
        </select><br>

        <input type="submit" value="Add Aircraft">
    </form>
    <%
    if ("post".equalsIgnoreCase(request.getMethod()) && "add".equals(request.getParameter("addAircraft"))) {
        String aircraftIDAdd = request.getParameter("aircraftID");
        int seats = Integer.parseInt(request.getParameter("seats"));
        String[] operatesArray = request.getParameterValues("operates");
        String airlineIDAdd = request.getParameter("airlineID");

        // Concatenate the operates days
        String operates = String.join("", operatesArray);

        try {
        	ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            
            String checkQuery = "SELECT COUNT(*) AS count FROM Aircraft WHERE aircraftID = ?";
            PreparedStatement pstmtCheck = con.prepareStatement(checkQuery);
            pstmtCheck.setString(1, aircraftIDAdd);
            ResultSet rsCheck = pstmtCheck.executeQuery();
            
            if (rsCheck.next() && rsCheck.getInt("count") == 0) {
            
            String insertQuery = "INSERT INTO Aircraft (aircraftID, operates, seats, airlineID) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = con.prepareStatement(insertQuery);

            pstmt.setString(1, aircraftIDAdd);
            pstmt.setString(2, operates);
            pstmt.setInt(3, seats);
            pstmt.setString(4, airlineIDAdd);

            int rowAffected = pstmt.executeUpdate();
            if (rowAffected > 0) {
                out.println("<p>Aircraft added successfully.</p>");
            } else {
                out.println("<p>Error adding aircraft.</p>");
            }
            pstmt.close();
            con.close();
        }
            else out.println("<p>Aircraft id already exists, enter another</p>");
            } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    %>

    <!-- Edit Flight Form -->
    <h3>Edit Aircraft</h3>
    <h2>Select an Aircraft to Update</h2>
    <form method="post">
        <select name="selectedAircraft">
            <%
            	try{
                ApplicationDB db = new ApplicationDB();    
                Connection con = db.getConnection();
                String query = "SELECT aircraftID FROM Aircraft";
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(query);

                while (rs.next()) {
                    String editAircraftID = rs.getString("aircraftID");
                    out.println("<option value='" + editAircraftID + "'>" + editAircraftID + "</option>");
                }
                rs.close();
                stmt.close();
            	}catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </select>
        <input type="submit" value="Select Aircraft">
    </form>
    <%
        String selectedAircraft = request.getParameter("selectedAircraft");
        if (selectedAircraft != null && !selectedAircraft.isEmpty()) {
            try {
            	ApplicationDB db = new ApplicationDB();    
                Connection con = db.getConnection();
                
                String query = "SELECT aircraftID FROM Aircraft";
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(query);
                
                PreparedStatement pstmt = con.prepareStatement("SELECT * FROM Aircraft WHERE aircraftID = ?");
                pstmt.setString(1, selectedAircraft);
                ResultSet rsPrint = pstmt.executeQuery();
                if (rsPrint.next()) {
                    String operates = rsPrint.getString("operates");
                    int seats = rsPrint.getInt("seats");
                    pstmt = con.prepareStatement("SELECT airlineID FROM AirlineCompany");
                    ResultSet rsAirline = pstmt.executeQuery();
    %>
                    <h3>Update Aircraft Details</h3>
                    <form method="post">
                    	<input type="hidden" name="editAircraft" value="edit">
                        <input type="hidden" name="aircraftID" value="<%= selectedAircraft %>">
                        Operates: <input type="text" name="operates" value="<%= operates %>"><br>
                        Seats: <input type="number" name="seats" value="<%= seats %>"><br>
                        Airline ID: <select name="airlineID">
                        <%
                            while (rsAirline.next()) {
                                String airlineIDPrint = rsAirline.getString("airlineID");
                                out.println("<option value='" + airlineIDPrint + "'>" + airlineIDPrint + "</option>");
                            }
                        %>
                    </select><br>
                    <input type="submit" value="Update Aircraft">
                    </form>
    <%
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
    String editAircraft = request.getParameter("editAircraft");
    String editAircraftID = request.getParameter("aircraftID");
    String operates = request.getParameter("operates");
    String seatsStr = request.getParameter("seats");
    String editAirlineID = request.getParameter("airlineID");
    if(!(editAircraft == null) && editAircraft.equals("edit")){
        try {
        	ApplicationDB db = new ApplicationDB();	
    		Connection con = db.getConnection();
    		
            int seats = Integer.parseInt(seatsStr);
    		String updateQuery = "UPDATE Aircraft SET operates = ?, seats = ?, airlineID = ? WHERE aircraftID = ?";
            PreparedStatement pstmt = con.prepareStatement(updateQuery);

            pstmt.setString(1, operates);
            pstmt.setInt(2, seats);
            pstmt.setString(3, editAirlineID);
            pstmt.setString(4, editAircraftID);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<p>Aircraft data updated successfully!</p>");
            } else {
                out.println("<p>Error updating aircraft data.</p>");
            }
            pstmt.close();
            con.close();
        } catch(Exception e) {
            e.printStackTrace();
            out.println("<p>Error updating aircraft data: " + e.getMessage() + "</p>");
        } 
    }
    
%>
    
    

    <!-- Delete Flight Form -->
    <h3>Delete Aircraft</h3>
    <form method="post">
    	<input type="hidden" name="deleteAircraft" value="delete">
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
    	String deleteAircraft = request.getParameter("deleteAircraft");
        String deleteAirlineID = request.getParameter("aircraftID");
        if(!(deleteAircraft == null) && deleteAircraft.equals("delete")){
        try {
        	ApplicationDB db = new ApplicationDB();	
    		Connection con = db.getConnection();
    		
            String sql = "DELETE FROM Aircraft WHERE aircraftID = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, (deleteAirlineID));
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
        }
    %>
    </fieldset>
    
</body>
</html>