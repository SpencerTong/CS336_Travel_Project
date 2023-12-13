<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<!--Import necessary libraries -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
    <title>Answer Questions</title>
</head>
<body>
<form action="customerRepUI.jsp" method="get">
	<input type="submit" name="backToUI" value="Back To Customer Rep UI">
</form>
    <% 
        // Process form submission
        String qID = request.getParameter("qID");
        String userAnswer = request.getParameter("answer");
        if ("POST".equalsIgnoreCase(request.getMethod()) && qID != null && userAnswer != null) {
            try {
                ApplicationDB db = new ApplicationDB();    
                Connection con = db.getConnection();
                String sql = "UPDATE QuestionsAndAnswers SET qAnswer = ? WHERE qID = ?";
                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setString(1, userAnswer);
                pstmt.setInt(2, Integer.parseInt(qID));
                pstmt.executeUpdate();
                pstmt.close();
                con.close();  
                out.println("<p>Answer submitted successfully for question " + qID + ".</p>");
            } catch(Exception e) {
                e.printStackTrace();
                out.println("<p>Error submitting answer for question " + qID + ".</p>");
            }
        }
    %>
    <h2>Questions and Answers</h2>
    <table border="1">
        <tr>
            <th>Question ID</th>
            <th>Question</th>
            <th>Answer</th>
            <th>Provide Answer</th>
        </tr>
        <%
            try {
                ApplicationDB db = new ApplicationDB();    
                Connection con = db.getConnection();
                String sql = "SELECT * FROM QuestionsAndAnswers";
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(sql);
                while (rs.next()) {
                    int questionID = rs.getInt("qID");
                    String qContent = rs.getString("qContent");
                    String qAnswer = rs.getString("qAnswer");
                    out.println("<tr>");
                    out.println("<td>" + questionID + "</td>");
                    out.println("<td>" + qContent + "</td>");
                    out.println("<td>" + qAnswer + "</td>");
                    out.println("<td>");
                    out.println("<form method='post'>"); 
                    out.println("<input type='hidden' name='qID' value='" + questionID + "'>");
                    out.println("<input type='text' name='answer'>");
                    out.println("<input type='submit' value='Submit Answer'>");
                    out.println("</form>");
                    out.println("</td>");
                    out.println("</tr>");
                }
                rs.close();
                stmt.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </table>
</body>
</html>
