<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
    <!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Sales Report</title>
</head>
<body>

<form method="GET">
	<input type="submit" name="backToHome" value="Back To Admin Home">
</form><br><br>

<form method="GET">
	<label for="month">Enter an integer representing a month (i.e, 1 = January, 12 = December):</label><br>
	<input type="text" id="month" name="month"><br>
	<input type="submit" name="obtainReport"value="Obtain sales report for the given month">
</form><br>

<%
	try {
	HttpSession ses = request.getSession();
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	if(request.getParameter("backToHome") != null){
		response.sendRedirect("adminUI.jsp");
	} 
	
	
	String month = (String) request.getParameter("month");
	Statement stmt = con.createStatement();
	String query = "SELECT" +
			  "'Basic' AS ticketType, " +
			  "COUNT(*) AS totalTickets, " +
			  "SUM(totalFare) AS totalFare, " +
			  "MIN(totalFare) AS leastExpensive, " +
			  "MAX(totalFare) AS mostExpensive " +
			"FROM ticketreserves " +
			"WHERE MONTH(dateAndTimePurchased) = " + month + " AND cancellationFee = 0 " +
			" " +	
			"UNION " +
			"" +
			"SELECT " +
			  "'Premium' AS ticketType, " +
			  "COUNT(*) AS totalTickets, " +
			  "SUM(totalFare) AS totalFare, " +
			  "MIN(totalFare) AS leastExpensive, " +
			  "MAX(totalFare) AS mostExpensive " +
			"FROM ticketreserves " +
			"WHERE MONTH(dateAndTimePurchased) = " + month + " AND cancellationFee > 0 " +
			" " +
			"UNION " +
			" " +
			"SELECT " +
			  "'Total' AS ticketType, " +
			  "COUNT(*) AS totalTickets, " +
			  "SUM(totalFare) AS totalFare, " +
			  "MIN(totalFare) AS leastExpensive, " +
			  "MAX(totalFare) AS mostExpensive " +
			"FROM ticketreserves " +
			"WHERE MONTH(dateAndTimePurchased) = " + month + " "; 
	
    ResultSet rs = stmt.executeQuery(query);
    
    out.println("<h2>Here is the sales report.</h2>");
    out.println("<table border='1'>");
    out.println("<tr><th>Ticket Type</th><th>Tickets Sold</th><th>Earnings From Sales</th><th>Least Expensive Ticket Sold</th><th>Most Expensive Ticket Sold</th>	</tr>");

    while (rs.next()) {
        out.println("<tr>");
        out.println("<td>" + rs.getString("ticketType") + "</td>");
        out.println("<td>" + rs.getString("totalTickets") + "</td>");
        out.println("<td>" + "$" + rs.getString("totalFare") + "</td>");
        out.println("<td>" + "$" + rs.getString("leastExpensive") + "</td>");
        out.println("<td>" + "$" + rs.getString("mostExpensive") + "</td>");
        out.println("<td>");
        out.println("</tr>");
    }

    out.println("</table>");
    
    rs.close();
    stmt.close();
    con.close();

	} catch (Exception e) {
        e.printStackTrace();
	}

%>

</body>
</html>