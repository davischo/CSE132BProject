<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.sql.*"%>
<%@page import="java.sql.Connection"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Report 1A</title>
</head>
<body>
<%
Connection conn = null;
Statement statement = null;
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
	rs = statement.executeQuery("Select s.id as sid, first,middle,last from students s, " +
			"enrollment e where e.quarter = 'SP' and e.year = 2017 and e.s_id = s.id"); 	
%>
<form action="Report1A.jsp" method="post">
<input type="hidden" value="pick" name="action">
<select id="sid" required ="required" name="sid">
<% 
while(rs.next()){
%>
    <option value="<%=rs.getInt("sid")%>"><%=rs.getString("first") + " " + rs.getString("last")%> </option>
<%}%>
</select>
<input type="submit" value="Submit">
</form>
<%
 	
if (request.getParameter("action").equals("pick") && action != null){
%> 	
<table cellspacing="5">
	<table border="1" cellspacing="5">
	<thead>
	<tr>
	<th>First Name </th>
	<th>Middle Name</th>
	<th>Last Name </th>
	<th> SSN </th>
	<th> SP17 Classes Report</th>
	</tr>
	</thead>
<%
statement = conn.createStatement();
String sid = request.getParameter("sid");
rs = statement.executeQuery("Select id,first,middle,last,ssn from students where id = " +sid);
if(rs.next()){
%>
<tbody>
<form action="Report1A.jsp" method="post">
    <input type="hidden" value="report" name="action">
    <input type="hidden" value="<%=rs.getInt("ssn")%>" name ="ssn">
	<td><%=rs.getString("first")%></td>
	<td><%=rs.getString("middle")%></td>
	<td><%=rs.getString("last")%></td>
	<td><%=rs.getInt("ssn")%></td>
    <td> <input type="submit" value="Select Student"></td>
</form>
</tbody>
</table>
</table>
<%}}
if(request.getParameter("action").equals("report")){
	int ssn = Integer.parseInt(request.getParameter("ssn"));
	String sql = "Select course_name,title, e.units as unit, se.sec_id as sec " +
			"from enrollment e left join students s on e.s_id = s.id " + 
			"left outer join classes c on e.class_id = c.class_id " +
			"left outer join sections se on e.sec = se.id " +
			"where s.ssn = " + ssn + " and e.quarter='SP' and e.year = 2017";
	s = conn.createStatement();
	r = s.executeQuery(sql);%>	
<p> All Classes The Selected Student Takes In SP17<p>	
<table cellspacing="5">
	<table border="1" cellspacing="5">
	<thead>
		<tr>
		<th> Class Name </th>
		<th> Class Title </th>
		<th> Units	</th>
		<th> Section Number </th>
		</tr>
	</thead>
<% 
while(r.next()){%>
	<tbody>
	<tr>
		<td><%=r.getString("course_name")%></td>
		<td><%=r.getString("title")%></td>
		<td><%=r.getInt("unit")%></td>
		<td><%=r.getInt("sec")%></td>
	</tr>
	</tbody>
	
<%}%>
	</table>
	</table>
<%}} 
catch (Exception e){}
finally{
	if(rs != null) {rs.close();}
	if(statement!=null) {statement.close();}
	if(s!=null) {s.close();}
	if (r!=null) {r.close();}
	if(conn!= null) {conn.close();	}
}%>
</body>
</html>