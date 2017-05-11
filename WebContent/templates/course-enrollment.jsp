<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Course Enrollment</title>
</head>
<body>
<body>
<h1 style="color:blue">Course Enrollment</h1>

<%
//Display error messages
if(session.getAttribute("error")!=null){
	%>
	<h3 style="color:red"><%=session.getAttribute("error")%></h3>
	<%
	session.removeAttribute("error");
}
//Display search message
if(request.getParameter("nameSort")!=null && request.getParameter("nameSort")!="" ){
	%>
	<h3 style="color:red">Searching for: <%=request.getParameter("nameSort")%></h3>
	<%
}

%>
<table>
<tr>
<td>
  <label>Search by Class:</label>
  <form action="course-enrollment.jsp" method="POST">
<% if( request.getParameter("nameSort")!= null && request.getParameter("nameSort")!="" ){
%>
    <input placeholder="Item Name" name="nameSort" value="<%=request.getParameter("nameSort")%>"></input>
<% }
   else{
%> 
	<input placeholder="Item Name" name="nameSort"></input>
<%  }%>
  <input type="submit" value="Search"></input>
</form>
</td>
<td>

<table border="1">
<tr>
  Please Choose Your Class to Enroll In
</tr>
<tr>
  <td>Course</td>
  <td>Class</td>
  <td>Section</td>
  <td>Quarter</td>
  <td>Year</td>
  <td>Start Time</td>
  <td>End Time</td>
  <td>Units</td>
  <td>Grading Option</td>
  <td>Student ID</td>
</tr>
<%@ page import="java.sql.*" %>
        <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs0,rs1,rs2 = null;
        Statement st0,st1,st2 = null;

        try {
        	//Registering Postgresql JDBC driver with teh DriverManager
        	Class.forName("org.postgresql.Driver");
        	//Open a connection to the database using DriverManager
        	conn = DriverManager.getConnection(
        			"jdbc:postgresql://localhost:5432/postgres?" +
        			"user=postgres&password=postgres");
        	
        	st0 = conn.createStatement();
        	//SORTING CRITERIA
        	if( request.getParameter("nameSort")!=null && request.getParameter("nameSort")!="" ){
            	rs0 = st0.executeQuery("SELECT * FROM sections sec, classes class, courses crs, meetings mt WHERE " + 
            		"sec.class_id=class.class_id AND class.course_name=crs.course_name AND mt.sec_id=sec.id " + 
            		"AND mt.type='lecture' AND title LIKE '%" + request.getParameter("nameSort") + "%'");
        	}
        	else{
        		rs0 = st0.executeQuery("SELECT * FROM sections sec, classes class, courses crs, meetings mt WHERE " + 
        			"sec.class_id=class.class_id AND class.course_name=crs.course_name AND mt.sec_id=sec.id " + 
        			"AND mt.type='lecture'");
        	}

        	while(rs0.next()){
        		%>
        		<tr>
        		<form action=course-enrollment.jsp method="POST">
        		<input type="hidden" name="enroll" value="true"/>
        		<input type="hidden" name="class_id" value="<%=rs0.getInt("class_id")%>"/>
        		<input type="hidden" name="sec_id" value="<%=rs0.getInt("id")%>"/>
        		<td><%=rs0.getString("course_name")%></td>
        		<td><%=rs0.getString("title")%></td>
        		<td><%=rs0.getString("sec_id")%></td>
        		<td><input name="quarter" value="<%=rs0.getString("quarter")%>" readonly/></td>
        		<td><input name="year" value="<%=rs0.getString("year")%>" readonly/></td>
        		<td><%=rs0.getString("start_time")%></td>
        		<td><%=rs0.getString("end_time")%></td>
        		<td><select name="units">
        		<%
        		int i = Integer.parseInt(rs0.getString("min_unit"));
        		int k = Integer.parseInt(rs0.getString("max_unit")); 
        		while(i<=k){
        			%>
        			<option><%=i%></option>
        			<%
        			i++;
        		}
        		%>
        		</select>
        		</td>
        		<%
        		if(rs0.getString("grad_opt").equals("both")){
        		%>	
        			<td><select name="grad_opt">
        			  <option value="grade">Grade</option>
        			  <option value="PNP">PNP</option>
        			</select>
        			</td>
        		<% 
        		}
        		else{ 
        		%>
        			<td><input name="grad_opt" value="<%=rs0.getString("grad_opt")%>"readonly/></td>
        	 <% } %>
        		<td><input name="s_id" placeholder="Please Enter SID"/></td>
        		<td><input type="submit" value="Enroll"/></td>
        		</form>
        		</tr>
        		<% 
        	}//end while
        		
        	if(request.getParameter("enroll")!=null && request.getParameter("enroll").equals("true")){
        		conn.setAutoCommit(false);
        		pstmt = conn.prepareStatement("INSERT INTO enrollment(s_id,class_id,sec,quarter,year,units,grade_opt) " 
        			+ "VALUES(?,?,?,?,?,?,?)");
        		pstmt.setString(1,request.getParameter("s_id"));
        		System.out.println(request.getParameter("sec_id"));

        		pstmt.setInt(2,Integer.parseInt(request.getParameter("class_id")));
        		pstmt.setInt(3,Integer.parseInt(request.getParameter("sec_id")));
        		pstmt.setString(4,request.getParameter("quarter"));
        		pstmt.setInt(5,Integer.parseInt(request.getParameter("year")));
        		pstmt.setInt(6,Integer.parseInt(request.getParameter("units")));
        		pstmt.setString(7,request.getParameter("grad_opt"));
        		
        		pstmt.execute();
        		conn.commit();
        		conn.setAutoCommit(true);
        		
        	}
        	
        	
        }
        catch(SQLException e){
        	System.out.println(e.getSQLState());
        	session.setAttribute("error","One or more input was invalid. Please try again");
        	response.sendRedirect("http://localhost:8888/CSE132BFolder/templates/course-enrollment.jsp");
        	
        }
        finally{
        	
        }
        %>

</td>
</tr>
</table>
</body>
</html>