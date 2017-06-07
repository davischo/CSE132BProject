<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.sql.*"%>
<%@page import="java.sql.Connection"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Add A Section</title>
</head>

<%
String failure = (String) session.getAttribute("failure");
String success = (String) session.getAttribute("success");
if (success != null) {
%>
<p style="color:rosybrown;font-size:18px;"><bold><%=success%></bold></p>
<%
session.setAttribute("success", null);
}

if (failure != null) {
%>
    <p style="color:darkred"><%=failure%></p>
<%
    session.setAttribute("failure", null);
}

Connection conn = null;
Statement statement = null;

PreparedStatement pstmt = null;
Statement s = null;
ResultSet r  = null;
ResultSet rs = null;

try{
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost/postgres?" +
                    "user=postgres&password=postgres");
	 
	String action = request.getParameter("action");
	statement = conn.createStatement();
	s = conn.createStatement();
	rs = statement.executeQuery("Select c.course_name as cname, c.title as title, " +
			"sec.id as secid, sec.taught_by as fac "+
			"From classes c join sections sec on sec.class_id = c.class_id " +
	 		" Where c.quarter = 'SP' and c.year = 2017 order by sec.sec_id");
	r = s.executeQuery("Select s.id as sid, first,middle,last from students s");
	
%>

<form action="enroll-students.jsp" method="post">
<input type="hidden" value="insert" name="action">

<p> Pick A Section </p>
<select id="secid" required ="required" name="secid">
<% 
while(rs.next()){
	
%>
    <option value="<%=rs.getInt("secid")%>"><%="Section " + rs.getInt("secid") + " : "  + rs.getString("cname") + " - " 
			+ rs.getString("title")%></option> 
<%}%>
</select>

<p> Pick A Student To Enroll </p>
<select id="studentid" required ="required" name="studentid">
<% 
while(r.next()){
%>
    <option value="<%=r.getInt("sid")%>"><%=r.getString("first") + " " + r.getString("last")%></option>
<%}%>
</select>
</br>

<input value="" name="units" required="required">

<select id="grad_opt" required ="required" name="grad_opt">
<option value="letter">Letter</option>
<option value="pnp">PNP </option>
<option>
</select>

<input type="submit" value="Enroll The Student in The Section">
</form>
<% 

if(action!= null && action.equals("insert")){
	conn.setAutoCommit(false);
	pstmt = conn.prepareStatement("INSERT INTO enrollment(s_id,class_id,sec,quarter,year,units,grade_opt) " 
		+ "VALUES(?,?,?,'SP',2017,?,?)");
	
	int secid = Integer.parseInt(request.getParameter("secid"));
	int stuid = Integer.parseInt(request.getParameter("studentid"));

	pstmt.setInt(1,stuid);

	r = s.executeQuery("Select class_id from sections sec where sec.id = " + secid );
	if(r.next()){
		pstmt.setInt(2,r.getInt("class_id"));
	}
	pstmt.setInt(3,secid);
	pstmt.setInt(4,Integer.parseInt(request.getParameter("units")));
	pstmt.setString(5,request.getParameter("grad_opt"));
	
    int row = pstmt.executeUpdate();
    if(row==1) {
        session.setAttribute("success", "You have successfully enrolled the selected student. Enroll another one");
        response.sendRedirect("enroll-students.jsp");
    }
    // Commit transaction
    conn.commit();
    conn.setAutoCommit(true);
}

}
catch(SQLException e) {
    if (request.getParameter("action").equals("insert")) {
        //session.setAttribute("failure", "The section is full. Enrollment is incomplete");
        session.setAttribute("failure","Failure to enroll student because of " + e.getMessage());
        response.sendRedirect("enroll-students.jsp");
    }
}
finally{	
	if (r!=null){ r.close();}
	if(rs != null) {rs.close();}
	if(s!=null) {s.close();}
	if(statement!=null) {statement.close();}
	if(conn!= null) {conn.close();}}%>
</body>
</html>
