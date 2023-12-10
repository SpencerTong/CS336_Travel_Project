<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
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
       if (username != null) { %>
        <h2 >Welcome, <%= username %></h2>
    <% } %>
    
    <form method="get" action="logIn.jsp">
    	<input type="submit" value="Log Out">
    </form>
    
    <h3>Search Flights</h3>
    
    <form method="get">
    	<fieldset style="border: none;">
    		<label for="departureAirport">Departure Airport:</label>
	    	<select id="departureAirport" name="departureAirport">
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
 				<option value="1">1</option>
 				<option value="2">2</option>
 				<option value="3">3</option>
 			</select>
    		
    		<label for="returnFlightDate">Return Flight Date: </label>
    		<input type="date" id="returnFlightDate" name="returnFlightDate">
    		
    		<label for="returnFlightDateFlexibility">Flexibility: </label>
    		<select id="returnFlightDateFlexibility" name="returnFlightDateFlexibility"">
 				<option value="1">1</option>
 				<option value="2">2</option>
 				<option value="3">3</option>
 			</select>
    		
    	</fieldset>
    	<fieldset style="border: none;">
    	    Take-off Time: (if round trip, applies to both flights)<br>
    		<label for="morningTakeOff" style="margin-right: 5px;">
    			<input type="checkbox" id="morningTakeOff" name="morningTakeOff" >
    			12am-8am
    		</label>
    		<label for="dayTakeOff" style="margin-right: 5px;" >
    			<input type="checkbox" id="dayTakeOff" name="dayTakeOff" >
    			8:01am-4pm
    		</label>
    		<label for="nightTakeOff" style="margin-right: 5px;" >
    			<input type="checkbox" id="nightTakeOff" name="nightTakeOff" >
    			4:01pm-11:59pm;
    		</label>
    	</fieldset>
    	<fieldset style="border: none;">
    	    Landing Time: (if round trip, applies to both flights)<br>
    		<label for="morningLanding" style="margin-right: 5px;">
    			<input type="checkbox" id="morningLanding" name="morningLanding" >
    			12am-8am
    		</label>
    		<label for="dayLanding" style="margin-right: 5px;">
    			<input type="checkbox" id="dayLanding" name="dayLanding" >
    			8:01am-4pm
    		</label>
    		<label for="nightLanding" style="margin-right: 5px;">
    			<input type="checkbox" id="nightLanding" name="nightLanding" >
    			4:01pm-11:59pm;
    		</label>
    	</fieldset>
    	<fieldset style="border: none;">
    	    Price:<br>
    		<label for="zeroToFiveHundred" style="margin-right: 5px;">
    			<input type="checkbox" id="zeroToFiveHundred" name="zeroToFiveHundred" >
    			$0-500
    		</label>
    		<label for="fiveHundredToOneThousand" style="margin-right: 5px;">
    			<input type="checkbox" id="fiveHundredToOneThousand" name="fiveHundredToOneThousand" >
    			$501-1000
    		</label>
    		<label for="oneThousandToFifteenHundred" style="margin-right: 5px;">
    			<input type="checkbox" id="oneThousandToFifteenHundred" name="oneThousandToFifteenHundred" >
    			$1001-1500
    		</label>
    		<label for="fifteenHundredToTwoThousand" style="margin-right: 5px;">
    			<input type="checkbox" id="fifteenHundredToTwoThousand" name="fifteenHundredToTwoThousand" >
    			$1501-2000
    		</label>
    		<label for="twoThousandPlus">
    			<input type="checkbox" id="twoThousandPlus" name="twoThousandPlus" >
    			$2000+
    		</label>
    	</fieldset>
    	<fieldset style="border: none;">
    	    Number of Stops:<br>
    		<label for="zeroStops" style="margin-right: 5px;">
    			<input type="checkbox" id="zeroStops" name="zeroStops" >
    			0
    		</label>
    		<label for="oneStop" style="margin-right: 5px;">
    			<input type="checkbox" id="oneStop" name="oneStop" >
    			1
    		</label>
    		<label for="twoStops" style="margin-right: 5px;">
    			<input type="checkbox" id="twoStops" name="twoStops" >
    			2
    		</label>
    		<label for="threePlusStops" style="margin-right: 5px;">
    			<input type="checkbox" id="threePlusStops" name="threePlusStops" >
    			3+
    		</label>
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
		        <input type="radio" name="sortCriteria" value="priceAsc">
		        Price&darr;
		    </label>
		    <label>
		        <input type="radio" name="sortCriteria" value="priceDesc">
		        Price&uarr;
		    </label>
		    <label>
		        <input type="radio" name="sortCriteria" value="takeOffAsc">
		        Take-off time&darr;
		    </label>
		     <label>
		        <input type="radio" name="sortCriteria" value="takeOffDesc">
		        Take-off time&uarr;
		    </label>
		    <label>
		        <input type="radio" name="sortCriteria" value="arrivalAsc">
		        Arrival time&darr;
		    </label>
		    <label>
		        <input type="radio" name="sortCriteria" value="arrivalDesc">
		        Arrival time&uarr;
		    </label>
		    <label>
		        <input type="radio" name="sortCriteria" value="flightDurationAsc">
		        Flight Duration&darr;
		    </label>
		    <label>
		        <input type="radio" name="sortCriteria" value="flightDurationDesc">
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
    		<th>Departure</th>
    		<th>Arrival</th>
    		<th>ReturnDep.</th>
    		<th>ReturnArr.</th>
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
    		String morningTakeOff = request.getParameter("morningTakeOff");
    		String dayTakeOff = request.getParameter("dayTakeOff");
    		String nightTakeOff = request.getParameter("nightTakeOff");
    		String morningLanding = request.getParameter("morningLanding");
    		String dayLanding = request.getParameter("dayLanding");
			String nightLanding = request.getParameter("nightLanding");
			String zeroToFiveHundred = request.getParameter("zeroToFiveHundred");
			String oneThousandToFifteenHundred = request.getParameter("oneTHousandToFifteenHundred");
			String fifteenHundredToTwoThousand = request.getParameter("fifteenHundredToTwoThousand");
			String twoThousandPlus = request.getParameter("twoThousandPlus");
			String zeroStops = request.getParameter("zeroStops");
			String oneStop = request.getParameter("oneStop");
			String twoStops = request.getParameter("twoStops");
			String threePlusStops = request.getParameter("threePlusStops");
			String airline = request.getParameter("airline");
			String sortCriteria = request.getParameter("sortCriteria");
			
			String basicTicket = request.getParameter("basicTicket");
			String premiumTicket = request.getParameter("premiumTicket");
			
			try {
				ApplicationDB db = new ApplicationDB();
    			Connection con = db.getConnection();
    			
    			Statement stmt = con.createStatement();
    			String query= "SELECT fnumber, fromAirport, toAirport, departure, arrival, returnDeparture, returnArrival, travelType, numStops, basicPrice, premiumPrice, bookingFee FROM FlightAssignedTo";
    			// airport filter
    			query += " WHERE fromAirport='" + departureAirport + "' AND toAirport='" +arrivalAirport +"'";
     			out.println(query);
    			//One way/Round trip filter
    			 if (oneWay != null && roundTrip == null) {
    				query+= "AND travelType='o'";
    			} else if (oneWay == null && roundTrip != null) {
    				query+= "AND travelType='r'";
    			} 
    			ResultSet rs = stmt.executeQuery(query);
    			
    			 while (rs.next()) {
    	                int fnumber = rs.getInt("fnumber");
    	                String fromAirport = rs.getString("fromAirport");
    	                String toAirport = rs.getString("toAirport");
    	                String departure = rs.getString("departure");
    	                String arrival = rs.getString("arrival");
    	                String returnDeparture = rs.getString("returnDeparture");
    	                String returnArrival = rs.getString("returnArrival");
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
    	                    <td><%= departure %></td>
    	                    <td><%= arrival %></td>
    	                    <td><%= returnDeparture %></td>
    	                    <td><%= returnArrival %></td>
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