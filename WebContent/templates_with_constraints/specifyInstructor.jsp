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
	rs = statement.executeQuery("Select sec_id,class_id,lec_day,lec_time from sections where sec_id <> '11'"); 
	statement = conn.createStatement();
	rs2 = statement.executeQuery("SELECT id, fac_name FROM faculty");
%>
	<form action="specifyInstructor.jsp" method="post">
	<input type="hidden" value="update" name="action">
	
	<select id="secid" name="sec_id">
	<option value="">Course</option>
	<% 
	while(rs.next()){
	%>
	    <option value="<%=rs.getString("sec_id")%>"><%=rs.getString("sec_id")%></option>
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
    // Begin transaction
    conn.setAutoCommit(false);
    ps = conn.prepareStatement(
            "UPDATE sections SET taught_by = ? where sec_id = ?");
   
	ps.setString(1,request.getParameter("fac_name"));
    ps.setString(2, request.getParameter("sec_id"));
    
	int rowCount = ps.executeUpdate();
    if (rowCount > 0) {
      	 System.out.println("Successfully update");
     }
    // Commit transaction
    conn.commit();
    conn.setAutoCommit(true);
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