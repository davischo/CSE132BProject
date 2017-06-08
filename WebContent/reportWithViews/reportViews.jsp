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
try{
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost/postgres?" +
                    "user=postgres&password=postgres");
	String action = request.getParameter("action");
	statement = conn.createStatement();
	rs = statement.executeQuery("SELECT id, course_name FROM courses"); 
	statement = conn.createStatement();
	rs2 = statement.executeQuery("SELECT id, fac_name FROM faculty");
%>
	<form action="reportViews.jsp" method="post">
	<input type="hidden" value="pick" name="action">
	<select id="c_id" name="c_id">
	<option value="">Course</option>
	<% 
	while(rs.next()){
	%>
	    <option value="<%=rs.getString("course_name")%>"><%=rs.getString("id")%> <%=rs.getString("course_name")%></option>
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
	<% 
	}
	%>
	</select>
	<select id="quarter" name="quarter">
	  <option value="">Quarter</option>
	  <option value="SP">SP</option>
	  <option value="FA">FA</option>
	  <option value="WI">WI</option>
	</select>
	<input type="text" name="year" placeholder="Year" value=""/>
	<input type="submit" value="Submit">
	</form>	
<% 
if (request.getParameter("action")!= null && request.getParameter("action").equals("pick")){
	
	if(request.getParameter("c_id")!="" && request.getParameter("fac_name")!="" 
			&& request.getParameter("quarter")!="" && request.getParameter("year")!=""){
	
		String cid = request.getParameter("c_id");
		String fac = request.getParameter("fac_name");
		String quarter = request.getParameter("quarter");
		int year = Integer.parseInt(request.getParameter("year"));
		
		ps = conn.prepareStatement("Select acount, bcount, ccount, dcount,othercount from CPQG where " +
				 				  " course_name =? and fac=? and quarter =? and year =?");
		ps.setString(1,cid);
		ps.setString(2,fac);
		ps.setString(3,quarter);
		ps.setInt(4,year);
		rs = ps.executeQuery();
%>
			<h3>Grade Count For : </h3>
		 	<p><%= cid + "  taught by  " + fac + "  in  " + quarter+year%></p>
			<table border="1">
			<tr>
			<td>A</td>
			<td>B</td>
			<td>C</td>
			<td>D</td>
			<td>Others</td>
			</tr>
<% 		if (rs.next()){ %>
			<tr>
			<td><%=rs.getInt("Acount") %></td>
			<td><%=rs.getInt("Bcount") %></td>
			<td><%=rs.getInt("Ccount") %></td>
			<td><%=rs.getInt("Dcount") %></td>
			<td><%=rs.getInt("OtherCount") %></td>
			</tr>
			</table>		
<% 		}
		
	}
	
	if(request.getParameter("c_id")!="" && request.getParameter("fac_name")!="" && request.getParameter("quarter")=="" && 
			request.getParameter("year")=="" ){
		
		String cid = request.getParameter("c_id");
		String fac = request.getParameter("fac_name");
		
		ps = conn.prepareStatement("Select acount, bcount, ccount, dcount,othercount from CPG where " +
				 				  " course_name =? and fac=?");
		ps.setString(1,cid);
		ps.setString(2,fac);
		rs = ps.executeQuery();
%>
			<h3>Grade Count For : </h3>
		 	<p><%= cid + "  taught by  " + fac + "   over the year is: " %></p>
			<table border="1">
			<tr>
			<td>A</td>
			<td>B</td>
			<td>C</td>
			<td>D</td>
			<td>Others</td>
			</tr>
<% 		if (rs.next()){ %>
			<tr>
			<td><%=rs.getInt("Acount") %></td>
			<td><%=rs.getInt("Bcount") %></td>
			<td><%=rs.getInt("Ccount") %></td>
			<td><%=rs.getInt("Dcount") %></td>
			<td><%=rs.getInt("OtherCount") %></td>
			</tr>
			</table>		
<% 		}
	}
}

} catch (SQLException e){
	System.out.println(e.getSQLState());
}
finally{

	if(rs != null) {rs.close();}
	if(ps!=null) {ps.close();}
	if(statement!=null) {statement.close();}
	if(conn!= null) {conn.close();}}%>
</body>
</html>