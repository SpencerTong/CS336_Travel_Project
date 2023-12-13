<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
	boolean validLogin = false;
	String inputUsername = "";
    HttpSession ses = request.getSession();
    String cid = "";

	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		out.print("connection succesful");
		//Get parameters from the HTML form at the index.jsp
		inputUsername = request.getParameter("username");
		String inputPassword = request.getParameter("password");


		//Make an insert statement for the Sells table:
  		String query = "SELECT password, CID FROM AssociatedAccount WHERE username = ?";
        PreparedStatement pstmt = con.prepareStatement(query);
        pstmt.setString(1, inputUsername);

        ResultSet result = pstmt.executeQuery();
		
		if (result.next()) {
			if (inputPassword.equals(result.getString("password"))) {
				validLogin = true;
			}
			cid = result.getString("CID");
		}
        result.close();
        pstmt.close();
        con.close();
	} catch (Exception ex) {
		out.print(ex);
		out.print("query failed");
	}
	
	if (validLogin) {
		ses.setAttribute("username", inputUsername);
		ses.setAttribute("logInError", null);
		ses.setAttribute("CID", cid);
		response.sendRedirect("welcome.jsp");
	} else {
		ses.setAttribute("logInError", "invalid login");
		response.sendRedirect("logIn.jsp");
	}
%>
</body>
</html>