<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>  

<%
//connecting to the database
String mysqldb = "jdbc:mysql://cs336-3.cs.rutgers.edu:3306/cancerforum"; //connection string 
Class.forName("com.mysql.jdbc.Driver"); //loading the driver 
Connection conn = DriverManager.getConnection(mysqldb, "csuser", "csd64f12"); //connect to db
Statement query = conn.createStatement(); //create the thing that will query the db
%>

<%
String[] oldModIds = request.getParameterValues("oldMods");
for(int x=0; x<oldModIds.length; x++){ 
	String removeMod = "DELETE FROM moderator WHERE moderator.userId = " + oldModIds[x] + ";"; 
	try{ 
		query.executeUpdate(removeMod); 
	}
	catch(Exception e){ 
		out.println(removeMod); 
		out.println(e.getMessage());
		return; 
	}
}

conn.close();

response.sendRedirect("admin.jsp");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>