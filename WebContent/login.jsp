<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>

<%! private String username = ""; %>
<%! private String email  = "";  //user's login email%>
<%! private String password = ""; //user's loginn password%>
<%! private String emailError = ""; //error on the user's email%>
<%! private String passwordError = ""; //error on the user's password %>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Cancer Forums</title>
</head>
<body>

<% 
	this.username = (String)session.getAttribute("username"); //get the user's username 
	this.password = (String)session.getAttribute("password");  //get the user's password
	
	//connecting to the database
	String mysqldb = "jdbc:mysql://cs336-3.cs.rutgers.edu:3306/cancerforum"; //connection string 
	Class.forName("com.mysql.jdbc.Driver"); //loading the driver 
	Connection conn = DriverManager.getConnection(mysqldb, "csuser", "csd64f12"); //connect to db
	Statement query = conn.createStatement(); //create the thing that will query the db
	
	ResultSet talkingBack = query.executeQuery("SELECT * FROM user WHERE user.username = '" + this.username + "';"); //query to the db
	
	if(!talkingBack.next()){ //could not find the user in the database
		String backwego = "index.jsp"; 
		session.setAttribute("emailError", "Invalid username"); 
		session.setAttribute("passwordError", null);
		response.sendRedirect("index.jsp"); 
		return; 
	}
	
	String testP = null;
	try{
		testP = talkingBack.getString("password"); //password to test against
	}
	catch(Exception e){
		session.setAttribute("emailError", "Invalid username"); 
		session.setAttribute("passwordError", "Invalid password");
		response.sendRedirect("index.jsp"); 
		return; 
	}
	
	if(this.password.equals(testP)){
		//userId compare simplicity
		int userId = talkingBack.getInt("userId"); 

		//user attributes to add to the session 
		session.setAttribute("userId", userId); 
		session.setAttribute("firstname", talkingBack.getString("firstName")); 
		session.setAttribute("lastname", talkingBack.getString("lastName")); 
		session.setAttribute("email", talkingBack.getString("email")); 
		session.setAttribute("votes", talkingBack.getInt("updownVote"));
		session.removeAttribute("password"); 
		
		//since users can be moderators and either a casual or a doctor gotta figure out the redirect on this
		ResultSet modTest = query.executeQuery("SELECT * FROM moderator WHERE moderator.userId = '" + userId + "';");
		if(modTest.next()){ //user is an moderator - assumes there is only one returned value
			session.setAttribute("usertype", "mod"); 
			response.sendRedirect("index.jsp"); 
			return; 
		}
		
		//find out if user is a doctor or casual 
		ResultSet casualTest = query.executeQuery("SELECT * FROM casual WHERE casual.userId = '" + userId + "';");
		if(casualTest.next()){ //user is a casual - assumes there is only one returned value
			session.setAttribute("isDoc", "no");
			session.setAttribute("usertype", "casual");
			response.sendRedirect("index.jsp"); 
			return; 
		}
		
		ResultSet doctorTest = query.executeQuery("SELECT * FROM doctor WHERE doctor.userId = '" + userId + "';");
		if(doctorTest.next()){ //user is a doctor - assumes there is only one returned value 
			session.setAttribute("usertype", "doc"); 
			session.setAttribute("isDoc", "yes"); 
			response.sendRedirect("index.jsp");
			return; 
		}


		
		ResultSet adminTest = query.executeQuery("SELECT * FROM admin WHERE admin.userId = '" + userId + "';"); 
		if(adminTest.next()){ //user is an admin - assumes there is only one returned value 	
			session.setAttribute("usertype", "admin");
			response.sendRedirect("index.jsp");  
			return; 
		}
		
		
		//if it makes it to here user is part of nothing mate!
		out.println("You are not registered as a type of user! Please contact an admin about your problem!");
			
		
	}
	else{ //return the user back to the login page
		String loginpage = new String("index.jsp");
		session.setAttribute("emailError", null);
		session.setAttribute("passwordError", "Invalid password"); 
		response.sendRedirect("index.jsp");  
		return;
		//response.setStatus(HttpServletResponse.SC_TEMPORARY_REDIRECT);
		//response.setHeader("Location", loginpage); 
	}

conn.close();
	
	
%> 
</body>
</html>