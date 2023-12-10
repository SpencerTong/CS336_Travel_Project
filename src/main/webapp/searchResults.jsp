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
    <form method="get" action="logIn.jsp">
    	<input type="submit" value="Log Out">
    </form>
    
    <h3>Results</h3>
 
    
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
    			} else if (oneWay == null && roundTrip == null) {
    				//will return nothing
    				query+= "AND travelType='o' AND travelType='r'";
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