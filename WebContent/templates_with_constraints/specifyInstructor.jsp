<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Decision Support</title>
</head>
<body>
<%@page import="java.util.*, java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%
Connection conn = null;
Statement statement = null;
PreparedStatement ps = null;
ResultSet rs = null;
ResultSet rs2 = null;
boolean lastFailed = false;
%>
<h2>Assign an Instructor to a Section</h2>
<% 
if(session.getAttribute("failure")!=null){
	%>
	<p style="color:red"><%=session.getAttribute("failure") %></p>
	<%
	session.removeAttribute("failure");
	lastFailed = true;
}
try{
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost/postgres?" +
                    "user=postgres&password=postgres");
    if(lastFailed){
    %>
    <p>It Failed</p>
    <%
    	
    }
    else if(session.getAttribute("taught")!=null){
    %>
    	<p style="color:red"><%=session.getAttribute("taught") %></p>
	    <form action="specifyInstructor.jsp" method="post">
	    <input type="hidden" name="sec_id" value="<%=session.getAttribute("sec_id")%>"/>
	    <input type="hidden" name="fac_name" value="<%=session.getAttribute("fac_name")%>"/>
	    <input type="hidden" value="update" name="action"/>
	    <input type="hidden" name="override" value="true"/>
	    <input type="submit" value="Yes"/>
	    </form>
    <%  
    session.removeAttribute("taught");
    }
    
	String action = request.getParameter("action");
	statement = conn.createStatement();
	rs = statement.executeQuery( "Select s.id, s.sec_id, cl.class_id, s.lec_day, s.lec_time, c.course_name" 
			+ " from sections s, classes cl, courses c"
			+ " where s.sec_id <> '11' AND s.class_id=cl.class_id AND cl.course_name=c.course_name"); 
	statement = conn.createStatement();
	rs2 = statement.executeQuery("SELECT id, fac_name FROM faculty");
%>

	<form action="specifyInstructor.jsp" method="post">
	<input type="hidden" value="update" name="action">
	
	<select id="secid" name="sec_id">
	<option value="">Section/Course</option>
	<% 
	while(rs.next()){
	%>
	    <option value="<%=rs.getString("id")%>">Section <%=rs.getString("sec_id")%> <%=rs.getString("course_name") %></option>
	<% 
	}
	%>
	</select>
	<select id="fac" name="fac_name">
	<option value="">Faculty</option>
	<%
	while(rs2.next()){
	%>
	    <option value="<%=rs2.getString("fac_name")%>"><%=rs2.getString("fac_name")%></option>
	<% }%>
	</select>	
	<input type="submit" value="Assign">
	</form>
	
<%
if (action != null && action.equals("update")) {
	System.out.println("Entering update");
    if(request.getParameter("override")!=null){//do nothing
    	}
    else{ //Check if section is taught already
	    Statement s = conn.createStatement();
	    ResultSet checkSec = s.executeQuery("SELECT * FROM sections WHERE id=" + request.getParameter("sec_id"));
	    while(checkSec.next()){
	    	if(checkSec.getString("taught_by")!=null){
	    		//Someone is teaching this section already
	    		session.setAttribute("taught",checkSec.getString("taught_by") + " is already teaching this section. Override?");
	       		session.setAttribute("sec_id",request.getParameter("sec_id"));
	       		session.setAttribute("fac_name",request.getParameter("fac_name"));
	    		response.sendRedirect("specifyInstructor.jsp");
	    		return;
	    	}
	    }
    }
    System.out.println("Before update");
    System.out.println(request.getParameter("fac_name"));
    System.out.println(request.getParameter("sec_id"));
    
    ps = conn.prepareStatement("UPDATE sections SET taught_by = ? where id = ?");
   
	ps.setString(1,request.getParameter("fac_name"));
    ps.setInt(2,Integer.parseInt(request.getParameter("sec_id")));
    
	int rowCount = ps.executeUpdate();
    if (rowCount > 0) {
      	 System.out.println("Successfully update");
     }
    System.out.println("Afteeer update");
}
} catch (SQLException e){
	System.out.println(e.getSQLState());
	if(e.getSQLState().equals("P0001")){
   		session.setAttribute("failure","Failure to create because " + e.getMessage());
   		session.setAttribute("sec_id",request.getParameter("sec_id"));
   		session.setAttribute("fac_name",request.getParameter("fac_name"));
    	response.sendRedirect("specifyInstructor.jsp");
	}
}
finally{

	if(rs != null) {rs.close();}
	if(ps!=null) {ps.close();}
	if(statement!=null) {statement.close();}
	if(conn!= null) {conn.close();}}%>
</body>
</html>