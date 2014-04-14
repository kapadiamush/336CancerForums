<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>  
    
    
<%! private String cdtom = ""; //casual/doctor to make into a mod %>
<%! private String mtocd = ""; //mod to make into a casual/doctor %>

<% 
if(request.getParameter("submit") != null && request.getParameter("submit").equals("Add Selected Casuals to Moderators")){ //adding casuals to moderators 
	//response.sendRedirect("index.jsp");
	String[] casuals = request.getParameterValues("currentCasuals");
	int x; //counting how many casuals we have to upgrade
	for(x=0; x<casuals.length; x++){
		session.setAttribute("tomod"+x, casuals[x]); 
	}
	session.setAttribute("numUp", Integer.toString(x)); 
	response.sendRedirect("makeMods.jsp"); 

}
if(request.getParameter("submit") != null && request.getParameter("submit").equals("Add Selected Doctors to Moderators")){ //adding doctors to moderators 
	String[] doctors = request.getParameterValues("currentDoctors"); 
	int x; //counting how many doctors we have to upgrade
	for(x=0; x<doctors.length; x++){
		session.setAttribute("tomod"+x, doctors[x]); 
	}
	session.setAttribute("numUp", Integer.toString(x)); 
	response.sendRedirect("makeMods.jsp");
}

if(request.getParameter("submit") != null && request.getParameter("submit").equals("Remove Selected from Moderatoring Staff")){ //removed selected moderators
	String[] mods = request.getParameterValues("currentModerators"); 
	int x; //counting how many mods to remove
	for(x=0; x<mods.length; x++){
		session.setAttribute("mod"+x, mods[x]); 
	}
	session.setAttribute("numdown", Integer.toString(x)); 
	response.sendRedirect("downMods.jsp"); 
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CS336:Cancer Forum | Admin Console</title>
</head>
<body>
<%
//connecting to the database
String mysqldb = "jdbc:mysql://cs336-3.cs.rutgers.edu:3306/cancerforum"; //connection string 
Class.forName("com.mysql.jdbc.Driver"); //loading the driver 
Connection conn = DriverManager.getConnection(mysqldb, "csuser", "csd64f12"); //connect to db
Statement query = conn.createStatement(); //create the thing that will query the db
%>
<h1>Admin Console</h1>

<section id = "casuals"> 
<form name = "casualtomod" action="admin.jsp" method="post">
<select id="current_casuals" name="currentCasuals" size="25" multiple>
<%
//get all casuals
String queryString = "SELECT * FROM user, casual WHERE user.userId = casual.userId;";
ResultSet casuals = query.executeQuery(queryString); 

while(casuals.next()){ //<option value="name"> name </option>
	out.println("<option value=\"" + casuals.getString("userName") + "\">" + casuals.getString("userName")  + "</option>" );
}
%>
</select>
<br/>
<input type="submit" value="Add Selected Casuals to Moderators">
</form>
</section>

<section id = "doctors">
<form name = "doctortomod" action="admin.jsp">
<select id="current_doctors" name="currentDoctors" size="25" multiple>
<%
//get all doctors
queryString = "SELECT * FROM user, doctor WHERE user.userId = doctor.userId;";
ResultSet doctors = query.executeQuery(queryString); 

while(doctors.next()){ //<option value="name"> name </option>
	out.println("<option value=\"" + doctors.getString("userName") + "\">" + doctors.getString("userName")  + "</option>" );
}
%>
</select>
<br/>
<input type="submit" value="Add Selected Doctors to Moderators">
</form>
</section>

<section id = "mods">
<form name="currentMods" action="admin.jsp">
<select id="current_mods" size="25" multiple>
<%
//get all moderators
queryString = "SELECT * FROM user, moderator WHERE user.userId = moderator.userId;";
ResultSet moderators = query.executeQuery(queryString);

while(moderators.next()){ 
	out.println("<option value=\"" + moderators.getString("userName") + "\">" + moderators.getString("userName") + "</option>" ); 
}
%>
</select>
<br />
<input type="submit" value="Remove Selected from Moderatoring Staff">
</form>
</section>
</body>
</html>