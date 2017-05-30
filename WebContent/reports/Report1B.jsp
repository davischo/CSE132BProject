<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@page import="java.util.*, java.sql.*"%>
<%@page import="java.sql.Connection"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Report 1B</title>
</head>
<body>
<%
Connection conn = null;
Statement statement = null;
Statement s = null;
PreparedStatement ps = null;
PreparedStatement pps = null;
ResultSet r  = null;
ResultSet rs = null;
ResultSet rss = null;
ResultSet rrs = null;
try{
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost/postgres?" +
                    "user=postgres&password=postgres");	 
	String action = request.getParameter("action");
	statement = conn.createStatement();
	rs = statement.executeQuery("Select class_id, course_name from classes where quarter = 'SP' and year = 2017"); 	
%>
<form action="Report1B.jsp" method="post">
<input type="hidden" value="pick" name="action">
<select id="cid" required ="required" name="cid">
<% 
while(rs.next()){
%>
    <option value="<%=rs.getInt("class_id")%>"><%=rs.getString("course_name")%></option>
<%}%>
</select>
<input type="submit" value="Submit">
</form>

<%if(action != null && action.equals("pick")){
%> 	
<table cellspacing="5">
<table border="1" cellspacing="5">
	<thead>
	<tr>
	<th>Course Name </th>
	<th>Course Title</th>
	<th>Quarter </th>
	<th>Year</th>
	<th>Class Roster Report</th>
	</tr>
	</thead>
<%
s = conn.createStatement();
int cid = Integer.parseInt(request.getParameter("cid"));
System.out.println(cid);
r = s.executeQuery("Select course_name, title, quarter, year from classes where class_id = " + cid);
if(r.next()) {
	
%>
<tbody>
<tr>
	<form action="Report1B.jsp" method="post">
    <input type="hidden" value="report" name="action">
    <input type="hidden" value="<%=r.getString("title")%>" name ="title">
	<td><%=r.getString("course_name")%></td>
	<td><%=r.getString("title")%></td>
	<td><%=r.getString("quarter")%></td>
	<td><%=r.getInt("year")%></td>
    <td> <input type="submit" value="Get Roster Report"></td>
	</form>
</tr>
</tbody>
</table>
</table>
<%}}
if(action !=null && action.equals("report")){
	String title = request.getParameter("title");
	String sql = "select class_id from classes where title like ?  and year = 2017 and quarter = 'SP'";
	pps = conn.prepareStatement(sql);
	pps.setString(1,title);
	rrs = pps.executeQuery();
	
	if(rrs.next()){	
		ps = conn.prepareStatement("Select s.*, e.units as unit, e.grade_opt as gO from enrollment e, students s " +
				"where e.class_id = ? and e.quarter= 'SP' and e.year = '2017' and e.s_id = s.id");
		ps.setInt(1,rrs.getInt("class_id"));
		rss = ps.executeQuery();
	}
%>	
<p> Roster of <%=title%> In SP17<p>	
<table cellspacing="5">
	<table border="1" cellspacing="5">
	<thead>
		<tr>
		<th> First </th>
		<th> Middle </th>
		<th> Last	</th>
		<th> PID </th>
		<th> SSN </th>
		<th> Level </th>
		<th> Residency </th>
		<th> College </th>
		<th> Units Taking </th>
		<th> Grade Option </th>
		</tr>
	</thead>
<% 
while(rss.next()){%>
	<tbody>
	<tr>
		<td><%=rss.getString("first")%></td>
		<td><%=rss.getString("middle")%></td>
		<td><%=rss.getString("last")%></td>
		<td><%=rss.getString("s_id")%></td>
		<td><%=rss.getInt("ssn")%></td>
		<td><%=rss.getString("level")%></td>
		<td><%=rss.getString("residency")%></td>
		<td><%=rss.getString("college")%></td>
		<td><%=rss.getInt("unit")%></td>
		<td><%=rss.getString("gO")%></td>
	</tr>
	</tbody>
<%}%>
	</table>
	</table>
<%}}
catch(Exception e){}
finally{
	if (r!=null){ r.close();}
	if(rs != null) {rs.close();}
	if(rrs != null) {rrs.close();}
	if(rss !=null) {rss.close();}
	if(s!=null) {s.close();}
	if(ps!=null) {ps.close();}
	if(pps!=null) {pps.close();}
	if(conn!= null) {conn.close();}
}%>
</body>
</html>