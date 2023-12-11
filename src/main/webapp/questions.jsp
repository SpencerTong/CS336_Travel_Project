<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Answer Questions</title>
</head>
<body>
    <h2>Answer Questions</h2>

        <%
            try {
            	ApplicationDB db = new ApplicationDB();	
        		Connection con = db.getConnection();
        		
                Statement stmt = con.createStatement();
                String sql = "SELECT qID, qContent, qAnswer FROM QuestionsAndAnswers";
                ResultSet rs = stmt.executeQuery(sql);

                while(rs.next()) {
                    int qID = rs.getInt("qID");
                    String qContent = rs.getString("qContent");
                    String qAnswer = rs.getString("qAnswer");
					
                    
                    out.println("<form method='post'>");
                    out.println("<h3>Question " + qID + "</h3>");
                    out.println("<p>" + qContent + "</p>");
                    out.println("<p>" + qAnswer + "</p>");
                    out.println("<input type='hidden' name='qID' value='" + qID + "' />");
                    out.println("<input type='text' name='answer' />");
                    out.println("<input type='submit' value='Submit Answer' />");
                    out.println("</form>");
                }
                rs.close();
                stmt.close();
                con.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
        %>
	
    <%
    	String qID = request.getParameter("qID");
    	String userAnswer = request.getParameter("answer");
        PreparedStatement pstmt = null;
        try {
        	ApplicationDB db = new ApplicationDB();	
    		Connection con = db.getConnection();
    		
                    String sql = "UPDATE QuestionsAndAnswers SET qAnswer = ? WHERE qID = ?";
                    pstmt = con.prepareStatement(sql);
                    pstmt.setInt(2, Integer.parseInt(qID));
                    pstmt.setString(1, userAnswer);
                    int rowsAffected = pstmt.executeUpdate();
                    	
                    if (rowsAffected > 0) {
                        out.println("<p>Answer submitted successfully!</p>");
                    }
            pstmt.close();
            con.close();  
        }
            catch(Exception e) {
            e.printStackTrace();
            out.println("<p>Error submitting answers.</p>");
           
        }
        finally{}
        %>
</body>
</html>