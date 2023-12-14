<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Representative Dashboard</title>
</head>
<body>
    <h2>Customer Representative Dashboard</h2>
    
    <form action="customerRepAddFlight.jsp" method="get">
        <input type="submit" value="Add Flight for Customer">
    </form>

    <form action="flights.jsp" method="get">
        <input type="submit" value="View Flights Given Airport">
    </form>

    <form action="flightListForWaitlist.jsp" method="get">
        <input type="submit" value="Waitlist for Flights">
    </form>

    <form action="manageFlightsAirportsAirlines.jsp" method="get">
        <input type="submit" value="Manage Flights, Airports, and Airlines">
    </form>

    <form action="manageUserFlights.jsp" method="get">
        <input type="submit" value="Manage User Flights">
    </form>

    <form action="questions.jsp" method="get">
        <input type="submit" value="Questions">
    </form>

</body>
</html>
