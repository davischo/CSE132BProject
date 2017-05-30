<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%Connection conn = null;
Statement statement = null;
Statement s = null;
ResultSet r  = null;
ResultSet rs = null;
ResultSet rrs = null;
PreparedStatement pps = null;
PreparedStatement ps = null;
ResultSet rss = null;

try{
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost/postgres?" +
                    "user=postgres&password=postgres");
	 
	String action = request.getParameter("action");
	statement = conn.createStatement();
	rs = statement.executeQuery("Select distinct s.id as sid, first,middle,last from students s,enrollment e where e.s_id = s.id"); 	
%>
<p>Pick a Student to Get Report </p>
<form action="Report1C.jsp" method="post">
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
<%if (request.getParameter("action").equals("pick") && action != null){
%> 	
<table cellspacing="5">
	<table border="1" cellspacing="5">
	<thead>
	<tr>
	<th>First Name </th>
	<th>Middle Name</th>
	<th>Last Name </th>
	<th> SSN </th>
	<th> Get Grade Report </th>
	</tr>
	</thead>
<%
statement = conn.createStatement();
String sid = request.getParameter("sid");
rs = statement.executeQuery("Select id,first,middle,last,ssn from students where id = " +sid);
if(rs.next()){
%>
<tbody>
<tr>
<form action="Report1C.jsp" method="post">
    <input type="hidden" value="report" name="action">
    <input type="hidden" value="<%=rs.getInt("ssn")%>" name ="ssn">
	<td><%=rs.getString("first")%></td>
	<td><%=rs.getString("middle")%></td>
	<td><%=rs.getString("last")%></td>
	<td><%=rs.getInt("ssn")%></td>
    <td> <input type="submit" value="Select Student"></td>
</form>
</tr>
</tbody>
</table>
</table>
<%}}
if(request.getParameter("action").equals("report")){
	int ssn = Integer.parseInt(request.getParameter("ssn"));
	String sql1 = "select id, first from students where ssn = " + ssn ;
	s = conn.createStatement();
	rrs = s.executeQuery(sql1);
	String name = null;
	String sql = "Select c.course_name as cn ,c.title as title, c.quarter as q,c.year as y, A.grade_opt as go, A.grade as g " +
		     " From (Select e.class_id,e.grade,e.grade_opt from enrollment e " + 
	            " where e.s_id = ? group by e.quarter,e.year, e.class_id, e.grade_opt, e.grade) AS A, classes c " +
	         "where A.class_id = c.class_id order by c.year,c.quarter ASC ";
	
	
	String gpa = "WITH B as " +
			" (Select c.course_name,c.title, c.quarter as qtr,c.year as yr, A.grade_opt, A.grade, g.NUMBER_GRADE as ng "
				 +	" From (Select e.class_id,e.grade,e.grade_opt from enrollment e"
					 +     " where e.s_id = ?  group by e.quarter,e.year, e.class_id, e.grade_opt, e.grade) AS A "
					   + "    join grade_conversion g on A.grade = g.letter_grade, classes c"
				 + "	where A.class_id = c.class_id"
					+ " order by c.year,c.quarter ASC)"
					+ " Select B.qtr,B.yr, AVG(B.ng) "
				+ "	From B "
				+ "	GROUP BY B.yr,B.qtr";

	if (rrs.next()){
		pps = conn.prepareStatement(sql);
		ps = conn.prepareStatement(gpa);
		pps.setInt(1,rrs.getInt("id"));
		ps.setInt(1,rrs.getInt("id"));
		name = rrs.getString("first");
	}
	r = pps.executeQuery();
	rss = ps.executeQuery();

	%>	
	<p> Grade Report Of Student <%=name%> <p>	
	<table cellspacing="5">
		<table border="1" cellspacing="5">
		<thead>
			<tr>
			<th> Course Name</th>
			<th> Course Title </th>
			<th> Quarter </th>
			<th> Year </th>
			<th> Grade Option </th>
			<th> Grade </th>
			</tr>
		</thead>
	<% 
	while(r.next()){%>
		<tbody>
		<tr>
			<td><%=r.getString("cn")%></td>
			<td><%=r.getString("title")%></td>
			<td><%=r.getString("q")%></td>
			<td><%=r.getInt("y")%></td>
			<td><%=r.getString("go")%></td>
			<td><%=r.getString("g")%></td>
		</tr>
		</tbody>
	<%}%>
		</table>
		</table>
		</br>
		<p> Quarterly GPA Report Of Student <%=name%> <p>
		<table cellspacing="5">
		<table border="1" cellspacing="5">
		<thead>
			<tr>
			<th> Quarter </th>
			<th> Year  </th>
			<th> GPA </th>
			</tr>
		</thead>
	<% 
	int q = 0;
	double total = 0;
	while(rss.next()){
		q++;
		total = total + (Double)(rss.getDouble("avg"));
	%>
	
		<tbody>
		<tr>
			<td><%=rss.getString("qtr")%></td>
			<td><%=rss.getString("yr")%></td>
			<td><%=rss.getDouble("avg")%></td>
		</tr>
		</tbody>
	<%}%>
		</table>
		</table>
		</br>
		<%if(q!= 0){
			DecimalFormat df = new DecimalFormat("#.###");
			%>
		<p> Cumulative GPA Of Student <%=name%> : <%=df.format(total/q)%><p>
		<%} %>
<%}}
catch(Exception e) {}
finally{	
	if (r!=null){ r.close();}
	if(rs != null) {rs.close();}
	if(rrs != null) {rrs.close();}
	if(rss !=null) {rss.close();}
	if(s!=null) {s.close();}
	if(ps!=null) {ps.close();}
	if(pps!=null) {pps.close();}
	if(conn!= null) {conn.close();}}%>
</body>
</html>