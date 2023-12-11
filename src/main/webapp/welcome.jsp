<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.time.LocalDateTime,java.time.format.DateTimeFormatter"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Home</title>
</head>
<body>
	<% HttpSession ses = request.getSession();
		String username = (String) ses.getAttribute("username");
		String cid = (String) ses.getAttribute("CID");
       if (username != null) { %>
        <h2 >Welcome, <%= username %></h2>
    <% } %>
    
    <form method="get" action="logIn.jsp">
    	<input type="submit" value="Log Out">
    </form>
    
    <form method="get" action="myFlights.jsp">
    	<input type="submit" value="My Flights">
    </form>
    
  
    
    <h3>Search Flights</h3>
    
     <%
    try {
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		Statement stmt = con.createStatement();
		ResultSet rs = stmt.executeQuery("SELECT notifications FROM Customer WHERE cid='" + cid + "'"); 
		
		
		if (rs.next()) {
			String notification = rs.getString("notifications");
			if (!notification.isEmpty()) {
				%>
					<h4><%= notification %></h4>
				<%
			}
		}
		

		String allFlightsQuery = "SELECT fnumber, waitlist FROM FlightAssignedTo";
		ResultSet flightsRs = stmt.executeQuery(allFlightsQuery);
		
		while (flightsRs.next()) {
			String waitlist = flightsRs.getString("waitlist");
			int fnumber = flightsRs.getInt("fnumber");
			waitlist = waitlist.replace(cid, "");
			waitlist = waitlist.replace("::", ":");
			if (waitlist.equals(":")) {
				waitlist = "";
			}
			
			Statement updateStatement = con.createStatement();
			String updateFlightWaitList = "UPDATE FlightAssignedTo SET waitlist='" + waitlist + "' WHERE fnumber=" + fnumber;
			updateStatement.executeUpdate(updateFlightWaitList);
			updateStatement.close();
		}
		
		String clearCustomerNotifications = "UPDATE Customer SET notifications='' WHERE cid='" + cid + "'";
		stmt.executeUpdate(clearCustomerNotifications);
		
		flightsRs.close();
		rs.close();
		stmt.close();
		con.close();
		
	} catch (Exception e) {
		e.printStackTrace();
	}
	%>
    
    <form method="get">
    	<fieldset style="border: none;">
    		<label for="departureAirport">Departure Airport:</label>
	    	<select id="departureAirport" name="departureAirport">
	    		<option value="Any" selected>Any</option>
	    		<%
	    		try {
	    			ApplicationDB db = new ApplicationDB();
	    			Connection con = db.getConnection();
	    			
	    			Statement stmt = con.createStatement();
	    			ResultSet rs = stmt.executeQuery("SELECT airportID FROM Airport");
	    			
	    			while (rs.next()) {
	    				String optionValue = rs.getString("airportID");
	    			
	    		%>
	    			<option value="<%= optionValue %>"><%= optionValue %></option>
	    		<%
	    			}
	    			
	    			rs.close();
	    			stmt.close();
	    			con.close();
	    			
	    		} catch (Exception e) {
	    			e.printStackTrace();
	    		}
	    		%>
	    	</select>
	    	<label for="arrivalAirport">Arrival Airport:</label>
	    	<select id="arrivalAirport" name="arrivalAirport">
	    		<option value="Any" selected>Any</option>
	    		<%
	    		try {
	    			ApplicationDB db = new ApplicationDB();
	    			Connection con = db.getConnection();
	    			
	    			Statement stmt = con.createStatement();
	    			ResultSet rs = stmt.executeQuery("SELECT airportID FROM Airport");
	    			
	    			while (rs.next()) {
	    				String optionValue = rs.getString("airportID");
	    			
	    		%>
	    			<option value="<%= optionValue %>"><%= optionValue %></option>
	    		<%
	    			}
	    			
	    			rs.close();
	    			stmt.close();
	    			con.close();
	    			
	    		} catch (Exception e) {
	    			e.printStackTrace();
	    		}
	    		%>
	    	</select>
    	</fieldset>
    	<fieldset style="border:none;">
    		<label for="oneWay">
    			<input type="checkbox" id="oneWay" name="oneWay" >
    			One-way
    		</label>
    		<label for="roundTrip">
    			<input type="checkbox" id="roundTrip" name="roundTrip">
    			Round trip
    		</label>
    	</fieldset>
    	<fieldset style="border:none;">
    		<label for="originatingFlightDate">Date: </label>
    		<input type="date" id="originatingFlightDate" name="originatingFlightDate">
 			
 			<label for="originatingFlightDateFlexibility">Flexibility: </label>
 			<select id="originatingFlightDateFlexibility" name="originatingFlightDateFlexibility" style="margin-right:15px;">
 				<option value="0">0</option>
 				<option value="1">1</option>
 				<option value="2">2</option>
 				<option value="3">3</option>
 			</select>
    		
    		<label for="returnFlightDate">Return Flight Date: </label>
    		<input type="date" id="returnFlightDate" name="returnFlightDate">
    		
    		<label for="returnFlightDateFlexibility">Flexibility: </label>
    		<select id="returnFlightDateFlexibility" name="returnFlightDateFlexibility"">
    			<option value="0">0</option>
 				<option value="1">1</option>
 				<option value="2">2</option>
 				<option value="3">3</option>
 			</select>
    		
    	</fieldset>
    	<fieldset style="border: none;">
    	    Take-off Time: Between (inclusive)<br>
    		<select id="takeOffTimeLowerBound" name="takeOffTimeLowerBound">
    			<option value="00:00:00" selected>00:00</option>
    			<option value="02:00:00">02:00</option>
    			<option value="03:00:00">03:00</option>
    			<option value="04:00:00">04:00</option>
    			<option value="05:00:00">05:00</option>
    			<option value="06:00:00">06:00</option>
    			<option value="07:00:00">07:00</option>
    			<option value="08:00:00">08:00</option>
    			<option value="09:00:00">09:00</option>
    			<option value="10:00:00">10:00</option>
    			<option value="11:00:00">11:00</option>
    			<option value="12:00:00">12:00</option>
    			<option value="13:00:00">13:00</option>
    			<option value="14:00:00">14:00</option>
    			<option value="15:00:00">15:00</option>
    			<option value="16:00:00">16:00</option>
    			<option value="17:00:00">17:00</option>
    			<option value="18:00:00">18:00</option>
    			<option value="19:00:00">19:00</option>
    			<option value="20:00:00">20:00</option>
    			<option value="21:00:00">21:00</option>
    			<option value="22:00:00">22:00</option>
    			<option value="23:00:00">23:00</option>
    		</select>
    		<select id="takeOffTimeUpperBound" name="takeOffTimeUpperBound">
    			<option value="00:00:00">00:00</option>
    			<option value="02:00:00">02:00</option>
    			<option value="03:00:00">03:00</option>
    			<option value="04:00:00">04:00</option>
    			<option value="05:00:00">05:00</option>
    			<option value="06:00:00">06:00</option>
    			<option value="07:00:00">07:00</option>
    			<option value="08:00:00">08:00</option>
    			<option value="09:00:00">09:00</option>
    			<option value="10:00:00">10:00</option>
    			<option value="11:00:00">11:00</option>
    			<option value="12:00:00">12:00</option>
    			<option value="13:00:00">13:00</option>
    			<option value="14:00:00">14:00</option>
    			<option value="15:00:00">15:00</option>
    			<option value="16:00:00">16:00</option>
    			<option value="17:00:00">17:00</option>
    			<option value="18:00:00">18:00</option>
    			<option value="19:00:00">19:00</option>
    			<option value="20:00:00">20:00</option>
    			<option value="21:00:00">21:00</option>
    			<option value="22:00:00">22:00</option>
    			<option value="23:00:00">23:00</option>
    			<option value="23:59:00" selected>23:59</option>
    		</select>
    	</fieldset>
    	<fieldset style="border: none;">
    	    Landing Time: Between (inclusive)<br>
    		<select id="landingTimeLowerBound" name="landingTimeLowerBound">
    			<option value="00:00:00" selected>00:00</option>
    			<option value="02:00:00">02:00</option>
    			<option value="03:00:00">03:00</option>
    			<option value="04:00:00">04:00</option>
    			<option value="05:00:00">05:00</option>
    			<option value="06:00:00">06:00</option>
    			<option value="07:00:00">07:00</option>
    			<option value="08:00:00">08:00</option>
    			<option value="09:00:00">09:00</option>
    			<option value="10:00:00">10:00</option>
    			<option value="11:00:00">11:00</option>
    			<option value="12:00:00">12:00</option>
    			<option value="13:00:00">13:00</option>
    			<option value="14:00:00">14:00</option>
    			<option value="15:00:00">15:00</option>
    			<option value="16:00:00">16:00</option>
    			<option value="17:00:00">17:00</option>
    			<option value="18:00:00">18:00</option>
    			<option value="19:00:00">19:00</option>
    			<option value="20:00:00">20:00</option>
    			<option value="21:00:00">21:00</option>
    			<option value="22:00:00">22:00</option>
    			<option value="23:00:00">23:00</option>
    		</select>
    		<select id="landingTimeUpperBound" name="landingTimeUpperBound">
    			<option value="02:00:00">02:00</option>
    			<option value="03:00:00">03:00</option>
    			<option value="04:00:00">04:00</option>
    			<option value="05:00:00">05:00</option>
    			<option value="06:00:00">06:00</option>
    			<option value="07:00:00">07:00</option>
    			<option value="08:00:00">08:00</option>
    			<option value="09:00:00">09:00</option>
    			<option value="10:00:00">10:00</option>
    			<option value="11:00:00">11:00</option>
    			<option value="12:00:00">12:00</option>
    			<option value="13:00:00">13:00</option>
    			<option value="14:00:00">14:00</option>
    			<option value="15:00:00">15:00</option>
    			<option value="16:00:00">16:00</option>
    			<option value="17:00:00">17:00</option>
    			<option value="18:00:00">18:00</option>
    			<option value="19:00:00">19:00</option>
    			<option value="20:00:00">20:00</option>
    			<option value="21:00:00">21:00</option>
    			<option value="22:00:00">22:00</option>
    			<option value="23:00:00">23:00</option>
    			<option value="23:59:00" selected>23:59</option>
    		</select>
    	</fieldset>
    	<fieldset style="border: none;">
    	    Return Flight Take-off Time: Between (inclusive)<br>
    		<select id="returnTakeOffTimeLowerBound" name="returnTakeOffTimeLowerBound">
    			<option value="00:00:00" selected>00:00</option>
    			<option value="02:00:00">02:00</option>
    			<option value="03:00:00">03:00</option>
    			<option value="04:00:00">04:00</option>
    			<option value="05:00:00">05:00</option>
    			<option value="06:00:00">06:00</option>
    			<option value="07:00:00">07:00</option>
    			<option value="08:00:00">08:00</option>
    			<option value="09:00:00">09:00</option>
    			<option value="10:00:00">10:00</option>
    			<option value="11:00:00">11:00</option>
    			<option value="12:00:00">12:00</option>
    			<option value="13:00:00">13:00</option>
    			<option value="14:00:00">14:00</option>
    			<option value="15:00:00">15:00</option>
    			<option value="16:00:00">16:00</option>
    			<option value="17:00:00">17:00</option>
    			<option value="18:00:00">18:00</option>
    			<option value="19:00:00">19:00</option>
    			<option value="20:00:00">20:00</option>
    			<option value="21:00:00">21:00</option>
    			<option value="22:00:00">22:00</option>
    			<option value="23:00:00">23:00</option>
    		</select>
    		<select id="returnTakeOffTimeUpperBound" name="returnTakeOffTimeUpperBound">
    			<option value="00:00:00">00:00</option>
    			<option value="02:00:00">02:00</option>
    			<option value="03:00:00">03:00</option>
    			<option value="04:00:00">04:00</option>
    			<option value="05:00:00">05:00</option>
    			<option value="06:00:00">06:00</option>
    			<option value="07:00:00">07:00</option>
    			<option value="08:00:00">08:00</option>
    			<option value="09:00:00">09:00</option>
    			<option value="10:00:00">10:00</option>
    			<option value="11:00:00">11:00</option>
    			<option value="12:00:00">12:00</option>
    			<option value="13:00:00">13:00</option>
    			<option value="14:00:00">14:00</option>
    			<option value="15:00:00">15:00</option>
    			<option value="16:00:00">16:00</option>
    			<option value="17:00:00">17:00</option>
    			<option value="18:00:00">18:00</option>
    			<option value="19:00:00">19:00</option>
    			<option value="20:00:00">20:00</option>
    			<option value="21:00:00">21:00</option>
    			<option value="22:00:00">22:00</option>
    			<option value="23:00:00">23:00</option>
    			<option value="23:59:00" selected>23:59</option>
    		</select>
    	</fieldset>
    	<fieldset style="border: none;">
    	    Return Flight Landing Time: Between (inclusive)<br>
    		<select id="returnLandingTimeLowerBound" name="returnLandingTimeLowerBound">
    			<option value="00:00:00" selected>00:00</option>
    			<option value="02:00:00">02:00</option>
    			<option value="03:00:00">03:00</option>
    			<option value="04:00:00">04:00</option>
    			<option value="05:00:00">05:00</option>
    			<option value="06:00:00">06:00</option>
    			<option value="07:00:00">07:00</option>
    			<option value="08:00:00">08:00</option>
    			<option value="09:00:00">09:00</option>
    			<option value="10:00:00">10:00</option>
    			<option value="11:00:00">11:00</option>
    			<option value="12:00:00">12:00</option>
    			<option value="13:00:00">13:00</option>
    			<option value="14:00:00">14:00</option>
    			<option value="15:00:00">15:00</option>
    			<option value="16:00:00">16:00</option>
    			<option value="17:00:00">17:00</option>
    			<option value="18:00:00">18:00</option>
    			<option value="19:00:00">19:00</option>
    			<option value="20:00:00">20:00</option>
    			<option value="21:00:00">21:00</option>
    			<option value="22:00:00">22:00</option>
    			<option value="23:00:00">23:00</option>
    		</select>
    		<select id="returnLandingTimeUpperBound" name="returnLandingTimeUpperBound">
    			<option value="02:00:00">02:00</option>
    			<option value="03:00:00">03:00</option>
    			<option value="04:00:00">04:00</option>
    			<option value="05:00:00">05:00</option>
    			<option value="06:00:00">06:00</option>
    			<option value="07:00:00">07:00</option>
    			<option value="08:00:00">08:00</option>
    			<option value="09:00:00">09:00</option>
    			<option value="10:00:00">10:00</option>
    			<option value="11:00:00">11:00</option>
    			<option value="12:00:00">12:00</option>
    			<option value="13:00:00">13:00</option>
    			<option value="14:00:00">14:00</option>
    			<option value="15:00:00">15:00</option>
    			<option value="16:00:00">16:00</option>
    			<option value="17:00:00">17:00</option>
    			<option value="18:00:00">18:00</option>
    			<option value="19:00:00">19:00</option>
    			<option value="20:00:00">20:00</option>
    			<option value="21:00:00">21:00</option>
    			<option value="22:00:00">22:00</option>
    			<option value="23:00:00">23:00</option>
    			<option value="23:59:00" selected>23:59</option>
    		</select>
    	</fieldset>
    	<fieldset style="border: none;">
    	    Premium and Basic Price With Booking Fee Under (inclusive):<br>
    		<select id="priceLimit" name="priceLimit">
    			<option value="500">$500</option>
    			<option value="1000">$1000</option>
    			<option value="1500">$1500</option>
    			<option value="2000">$2000</option>
    			<option value="Any" selected>Any</option>
    		</select>
    	</fieldset>
    	<fieldset style="border: none;">
    	    Number of Stops Under (inclusive):<br>
    		<select id="stopsLimit" name="stopsLimit">
    			<option value="0">0</option>
    			<option value="2">0</option>
    			<option value="3">0</option>
    			<option value="Any" selected>Any</option>
    		</select>
    	</fieldset>
    	<fieldset style="border:none;">
    		<label for="airline">Airline</label>
	    	<select id="airline" name="airline">
	    	<option value="Any">Any</option>
	    		<%
	    		try {
	    			ApplicationDB db = new ApplicationDB();
	    			Connection con = db.getConnection();
	    			
	    			Statement stmt = con.createStatement();
	    			ResultSet rs = stmt.executeQuery("SELECT airlineID FROM AirlineCompany");
	    			
	    			while (rs.next()) {
	    				String optionValue = rs.getString("airlineID");
	    			
	    		%>
	    			<option value="<%= optionValue %>"><%= optionValue %></option>
	    		<%
	    			}
	    			
	    			rs.close();
	    			stmt.close();
	    			con.close();
	    			
	    		} catch (Exception e) {
	    			e.printStackTrace();
	    		}
	    		%>
	    	</select>
    	</fieldset>
    	<fieldset style="border: none;">
    	    Sort by: <br>
    		<label>
		        <input type="radio" name="sortCriteria" value="basicPrice ASC">
		        Basic Price&darr;
		    </label>
		    <label>
		        <input type="radio" name="sortCriteria" value="basicPrice DESC">
		        Basic Price&uarr;
		    </label>
		    <label>
		        <input type="radio" name="sortCriteria" value="departure ASC">
		        Take-off time&darr;
		    </label>
		     <label>
		        <input type="radio" name="sortCriteria" value="departure DESC">
		        Take-off time&uarr;
		    </label>
		    <label>
		        <input type="radio" name="sortCriteria" value="arrival ASC">
		        Arrival time&darr;
		    </label>
		    <label>
		        <input type="radio" name="sortCriteria" value="arrival DESC">
		        Arrival time&uarr;
		    </label>
		    <label>
		        <input type="radio" name="sortCriteria" value="duration ASC">
		        Flight Duration&darr;
		    </label>
		    <label>
		        <input type="radio" name="sortCriteria" value="duration DESC">
		        Flight Duration&uarr;
		    </label>

    	</fieldset>
    	<input type="submit" value="Search Flights">
    </form>
    
    <table border="1" width="100%">
    	<tr>
    		<th>Fnumber</th>
    		<th>From</th>
    		<th>To</th>
    		<th>Airline</th>
    		<th>Departure</th>
    		<th>Arrival</th>
    		<th>ReturnDep.</th>
    		<th>ReturnArr.</th>
    		<th>Total Duration</th>
    		<th>Type</th>
    		<th># Stops</th>
    		<th>Booking Fee</th>
    		<th>Basic Ticket</th>
    		<th>Premium Ticket</th>
    	</tr>
    	<%
    		String departureAirport = request.getParameter("departureAirport");
    		String arrivalAirport = request.getParameter("arrivalAirport");
    		
    		String oneWay = request.getParameter("oneWay");
    		String roundTrip = request.getParameter("roundTrip");
    		
    		String originatingFlightDate = request.getParameter("originatingFlightDate");
    		String originatingFlightDateFlexibility = request.getParameter("originatingFlightDateFlexibility");
    		String returnFlightDate = request.getParameter("returnFlightDate");
    		String returnFlightDateFlexibility = request.getParameter("returnFlightDateFlexibility"); 
    		
    		String takeOffTimeLower = request.getParameter("takeOffTimeLowerBound");
    		String takeOffTimeUpper = request.getParameter("takeOffTimeUpperBound");
    		
    		String landingTimeLower = request.getParameter("landingTimeLowerBound");
    		String landingTimeUpper = request.getParameter("landingTimeUpperBound");
    		
    		String returnTakeOffTimeLower = request.getParameter("returnTakeOffTimeLowerBound");
    		String returnTakeOffTimeUpper = request.getParameter("returnTakeOffTimeUpperBound");
    		
    		String returnLandingTimeLower = request.getParameter("returnLandingTimeLowerBound");
    		String returnLandingTimeUpper = request.getParameter("returnLandingTimeUpperBound");
    		
			String priceLimit = request.getParameter("priceLimit");
			
			String stopsLimit = request.getParameter("stopsLimit");
    		
			String airline = request.getParameter("airline");
			String sortCriteria = request.getParameter("sortCriteria");
			
			String basicTicket = request.getParameter("basicTicket");
			String premiumTicket = request.getParameter("premiumTicket");
			String bookedFlightNum = request.getParameter("fnumber");
			
			
			try {
				ApplicationDB db = new ApplicationDB();
    			Connection con = db.getConnection();
    			
    			Statement stmt = con.createStatement();
    			
    			if (basicTicket != null) {
    				LocalDateTime currentDateTime = LocalDateTime.now();
    				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    				String formattedDateTime = currentDateTime.format(formatter);
    				
    				String flightQuery = "SELECT bookingFee, basicPrice, aircraftID, airlineID FROM FlightAssignedTo WHERE fnumber='" + bookedFlightNum +"'";
    				ResultSet result = stmt.executeQuery(flightQuery);
    				if (result.next()) {
    			        Float bookingFee = result.getFloat("bookingFee");
    			        Float basicPrice = result.getFloat("basicPrice");
    			        String aircraftID = result.getString("aircraftID");
    			        String airlineID = result.getString("airlineID");

    			        String aircraftQuery = "SELECT seats FROM Aircraft WHERE aircraftID='" + aircraftID + "'";
    			        ResultSet aircraftRes = stmt.executeQuery(aircraftQuery);

    			        if (aircraftRes.next()) {
    			            int seats = aircraftRes.getInt("seats");

    			            // Use parentheses to ensure correct order of operations
    			            int seatNum = (int) (Math.random() * seats) + 1;

    			            String ticketReservesInsert = "INSERT INTO TicketReserves(seat_number, bookingFee, totalFare, dateAndTimePurchased, CID, cancellationFee) VALUES (" + seatNum + ", " + bookingFee + ", " + basicPrice + ", '" + formattedDateTime + "', '" + cid + "', 20)";
    			            stmt.executeUpdate(ticketReservesInsert);
    			            
    			            String ticketReservesQuery = "SELECT MAX(ticketNumber) FROM (SELECT ticketNumber FROM TicketReserves) AS ticketNums";
    			            ResultSet ticketReservesResult = stmt.executeQuery(ticketReservesQuery);
    			            
    			            if (ticketReservesResult.next()) {
    			            	String ticketNum = ticketReservesResult.getString("MAX(ticketNumber)");
        			            String TicketHasFlightInsert = "INSERT INTO TicketHasFlight VALUES (" + ticketNum + ", " + bookedFlightNum + ", '" + airlineID + "')";
        			            stmt.executeUpdate(TicketHasFlightInsert);
        			            out.println("<h4 style='color: green';>Ticket purchased!</h4>");
    			            } else {
    			            	out.println("TicketNum not found");
    			            }    			            
    			        } else {
    			            out.println("Aircraft information not found.");
    			        }
    			    } else {
    			        out.println("Flight information not found.");
    			    }
    			}
    			
    			if (premiumTicket != null) {
    				LocalDateTime currentDateTime = LocalDateTime.now();
    				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    				String formattedDateTime = currentDateTime.format(formatter);
    				
    				String flightQuery = "SELECT bookingFee, premiumPrice, aircraftID, airlineID FROM FlightAssignedTo WHERE fnumber='" + bookedFlightNum +"'";
    				ResultSet result = stmt.executeQuery(flightQuery);
    				if (result.next()) {
    			        Float bookingFee = result.getFloat("bookingFee");
    			        Float basicPrice = result.getFloat("premiumPrice");
    			        String aircraftID = result.getString("aircraftID");
    			        String airlineID = result.getString("airlineID");

    			        String aircraftQuery = "SELECT seats FROM Aircraft WHERE aircraftID='" + aircraftID + "'";
    			        ResultSet aircraftRes = stmt.executeQuery(aircraftQuery);

    			        if (aircraftRes.next()) {
    			            int seats = aircraftRes.getInt("seats");

    			            // Use parentheses to ensure correct order of operations
    			            int seatNum = (int) (Math.random() * seats) + 1;

    			            String ticketReservesInsert = "INSERT INTO TicketReserves(seat_number, bookingFee, totalFare, dateAndTimePurchased, CID, cancellationFee) VALUES (" + seatNum + ", " + bookingFee + ", " + basicPrice + ", '" + formattedDateTime + "', '" + cid + "', 0)";
    			            stmt.executeUpdate(ticketReservesInsert);
    			            
    			            String ticketReservesQuery = "SELECT MAX(ticketNumber) FROM (SELECT ticketNumber FROM TicketReserves) AS ticketNums";
    			            ResultSet ticketReservesResult = stmt.executeQuery(ticketReservesQuery);
    			            
    			            if (ticketReservesResult.next()) {
    			            	String ticketNum = ticketReservesResult.getString("MAX(ticketNumber)");
        			            String TicketHasFlightInsert = "INSERT INTO TicketHasFlight VALUES (" + ticketNum + ", " + bookedFlightNum + ", '" + airlineID + "')";
        			            stmt.executeUpdate(TicketHasFlightInsert);
        			            out.println("<h4 style='color: green';>Ticket purchased!</h4>");
    			            } else {
    			            	out.println("TicketNum not found");
    			            }    			            
    			        } else {
    			            out.println("Aircraft information not found.");
    			        }
    			    } else {
    			        out.println("Flight information not found.");
    			    }
    			}
    			
    			String query= "SELECT fnumber, fromAirport, toAirport, airlineID, departure, arrival, returnDeparture, returnArrival, travelType, numStops, basicPrice, premiumPrice, bookingFee, TIMESTAMPDIFF(HOUR, departure, arrival)+COALESCE(TIMESTAMPDIFF(hour, returnDeparture, returnArrival), 0) as duration FROM FlightAssignedTo WHERE 1=1";
    			// airport filter
    			if (departureAirport != null && !departureAirport.equals("Any")) {
    				query += " AND fromAirport='" + departureAirport + "'";
    			}
    			if (arrivalAirport != null && !arrivalAirport.equals("Any")){
    				query+= " AND toAirport='" + arrivalAirport + "'";
    			}
    			//One way/Round trip filter
    			 if (oneWay != null && roundTrip == null) {
    				query+= " AND travelType='o'";
    			} else if (oneWay == null && roundTrip != null) {
    				query+= " AND travelType='r'";
    			} 
    			
    			 //date time filter for originating flight
    			 if (originatingFlightDate != null && !originatingFlightDate.isEmpty()) {
    				query += " AND (departure BETWEEN '" + originatingFlightDate + " 00:00:00' - INTERVAL " + originatingFlightDateFlexibility + " DAY AND '" + originatingFlightDate + " 23:59:59'+ INTERVAL " + originatingFlightDateFlexibility + " DAY)"; 
    			}
    			 
    			 if (takeOffTimeLower != null) { 
    				 query += " AND TIME(departure) >= '" + takeOffTimeLower + "'";
    			 }
    			 if (takeOffTimeUpper != null) {
    				 query += " AND TIME(departure) <= '" + takeOffTimeUpper + "'";
    			 }
    			 
    			 if (landingTimeLower != null) {
    				 query += " AND TIME(arrival) >= '" + landingTimeLower + "'";
    			 }
    			 if (landingTimeUpper != null) {
    				 query += " AND TIME(arrival) <= '" + landingTimeUpper + "'";
    			 } 
    			 
    			 //date time filter for return flight
    			 if (returnFlightDate != null && !returnFlightDate.isEmpty()) {
    				query += " AND (returnDeparture BETWEEN '" + returnFlightDate + " 00:00:00' - INTERVAL " + returnFlightDateFlexibility + " DAY AND '" + returnFlightDate + " 23:59:59' + INTERVAL " + returnFlightDateFlexibility + " DAY)"; 
    			}
    			 
    			 if (returnTakeOffTimeLower != null && returnFlightDate != null && !returnFlightDate.isEmpty()) {
    				 query += " AND TIME(returnDeparture) >= '" + returnTakeOffTimeLower + "'";
    			 }
    			 if (returnTakeOffTimeUpper != null && returnFlightDate != null && !returnFlightDate.isEmpty()) {
    				 query += " AND TIME(returnDeparture) <= '" + returnTakeOffTimeUpper + "'";
    			 }
    			 
    			 if (returnLandingTimeLower != null && returnFlightDate != null && !returnFlightDate.isEmpty()) {
    				 query += " AND TIME(returnArrival) >= '" + returnLandingTimeLower + "'";
    			 }
    			 if (returnLandingTimeUpper != null && returnFlightDate != null && !returnFlightDate.isEmpty()) {
    				 query += " AND TIME(returnArrival) <= '" + returnLandingTimeUpper + "'";
    			 }
    			 
    			 // price filter
    			 if (priceLimit != null && !priceLimit.equals("Any")) {
    				 query += " AND basicPrice+bookingFee <= " + priceLimit + " AND premiumPrice+bookingFee <= " + priceLimit;
    			 }
    			 
    			 //stops filter
    			 if (stopsLimit != null && !stopsLimit.equals("Any")) {
    				 query += " AND numStops <= " + stopsLimit;
    			 }
    			 
    			 //airline filter
    			 if (airline != null && !airline.equals("Any")) {
    				 query += " AND airlineID=" +airline;
    			 }
    			 
    			 query += " GROUP BY fnumber, fromAirport, toAirport, airlineID, departure, arrival, returnDeparture, returnArrival, travelType, numStops, basicPrice, premiumPrice, bookingFee";
    			 //sorting criteria
    			 if (sortCriteria != null) {
    				 query += " ORDER BY " + sortCriteria;
    			 }
    			 
    			ResultSet rs = stmt.executeQuery(query);
    			
    			 while (rs.next()) {
    	                int fnumber = rs.getInt("fnumber");
    	                String fromAirport = rs.getString("fromAirport");
    	                String toAirport = rs.getString("toAirport");
    	                String departure = rs.getString("departure");
    	                String airlineID = rs.getString("airlineID");
    	                String arrival = rs.getString("arrival");
    	                String returnDeparture = rs.getString("returnDeparture");
    	                String returnArrival = rs.getString("returnArrival");
    	                int duration = rs.getInt("duration");
    	                String travelType = rs.getString("travelType");
    	                int numStops = rs.getInt("numStops");
    	                Float basicPrice = rs.getFloat("basicPrice");
    	                Float premiumPrice = rs.getFloat("premiumPrice");
    	                Float bookingFee = rs.getFloat("bookingFee");
    	    %>
    	                <tr>
    	                    <td><%= fnumber %></td>
    	                    <td><%= fromAirport %></td>
    	                    <td><%= toAirport %></td>
    	                    <td><%= airlineID %></td>
    	                    <td><%= departure %></td>
    	                    <td><%= arrival %></td>
    	                    <td><%= returnDeparture %></td>
    	                    <td><%= returnArrival %></td>
    	                    <td><%= duration %></td>
    	                    <td><%= travelType %></td>
    	                    <td><%= numStops %></td>
    	                    <td><%= bookingFee %></td>
    	                    <td><%= basicPrice %>
    	                    	<form method="POST">
    	                    		<input type="hidden" name="fnumber" value="<%= fnumber%>">
    	                    		<input type="submit" name="basicTicket" value="Purchase">
    	                    	</form>
    	                    </td>
    	                    <td><%= premiumPrice %>
    	                    <form method="POST">
    	                    		<input type="hidden" name="fnumber" value="<%= fnumber%>">
    	                    		<input type="submit" name="premiumTicket" value="Purchase">
    	                    	</form>
    	                    </td>
    	                </tr>
    	    <%
    	            }
    	            rs.close();
    	            stmt.close();
    	            con.close();
    			
			} catch(Exception e) {
				e.printStackTrace();
			}
			
    	
    	%>
    </table>
    
</body>
</html>