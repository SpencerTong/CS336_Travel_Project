<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Questions Page</title>
</head>
<body>
<h1>Question and Answer Filter</h1>
    
    <form method="GET">
        <label>Filter by Question Content:</label>
        <input type="text" name="questionContent" maxlength="255">
        <input type="submit" value="Filter/Show all if blank">
    </form>
    
    <form method="GET">
        <label>Filter by Question Answer:</label>
        <input type="text" name="questionAnswer" maxlength="255">
        <input type="submit" value="Filter">
    </form>
    
    <form method="POST">
        <label>Add a new question:</label>
        <input type="text" name="newQuestion" maxlength="255" required>
        <input type="submit" value="Add Question">
    </form>
    
    <hr>
    
    <table border="1">
        <tr>
            <th>Question ID</th>
            <th>Question Content</th>
            <th>Question Answer</th>
        </tr>
    
    
    <%
            String questionContentFilter = request.getParameter("questionContent");
            String questionAnswerFilter = request.getParameter("questionAnswer");
            String newQuestion = request.getParameter("newQuestion");


            
            try {
            	ApplicationDB db = new ApplicationDB();	
        		Connection con = db.getConnection();
        		
        
                Statement stmt = con.createStatement();
                
                String query = "SELECT * FROM QuestionsAndAnswers WHERE 1=1";
		
                if (questionContentFilter != null && !questionContentFilter.isEmpty()) {
                	query += " AND qContent LIKE '%" + questionContentFilter + "%'";
                }
                
                if (questionAnswerFilter != null && !questionAnswerFilter.isEmpty()) {
                	query += " AND qAnswer LIKE '%" + questionAnswerFilter + "%'";
                }

        		if (newQuestion != null && !newQuestion.isEmpty()){
       			 	PreparedStatement pstmt = con.prepareStatement("INSERT INTO QuestionsAndAnswers (qContent) VALUES (?)");
                    pstmt.setString(1, newQuestion);
                    pstmt.executeUpdate();
                    ResultSet rs = stmt.executeQuery(query);
       			}
        		
                ResultSet rs = stmt.executeQuery(query);
                
                while (rs.next()) {
                    String questionID = rs.getInt("qID")+"";
                    String questionContent = rs.getString("qContent");
                    String questionAnswer = rs.getString("qAnswer");
                    if (questionAnswer == null) questionAnswer = "(No answer yet)";
        %>
        
                    <tr>
                        <td><%= questionID %></td>
                        <td><%= questionContent %></td>
                        <td><%= questionAnswer %></td>
                    </tr>
                    
        <%
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