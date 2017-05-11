<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Classes Taken Form</title>
</head>
<body>
<a href="../index.jsp">Homepage </a>
<h1 style="color:blue">Classes Taken Entry Form</h1>
<%
if(session.getAttribute("error")!=null){
	%>
	<h3 style="color:red"><%=session.getAttribute("error")%></h3>
	<%
	session.removeAttribute("error");
}
%>
<table border="1">
<tr>
  Please Enter the Information Below
</tr>
<tr>
  <td>Student Id</td>
  <td>Class Id</td>
  <td>Section Id</td>
  <td>Quarter</td>
  <td>Year</td>
  <td>Units</td>
  <td>Grade</td>
</tr>
<tr>
<form action="classes-taken.jsp" method="POST">
  <td>
  <input name="s_id" placeholder="Enter Student Id" size="15"/>
  </td>
  <td>
  <input name="class_id" placeholder="Enter Class Id" size="15"/>
  </td>
  <td>
  <input name="sec_id" placeholder="Enter Section Id" size="15"/>
  </td>
  <td>
  <select name="quarter">
  	<option value="FA">Fall</option>
  	<option value="WI">Winter</option>
  	<option value="SP">Spring</option>
  	<option value="SS1">Summer1</option>
  	<option value="SS2">Summer2</option>
  </select>
  </td>
  <td>
  <input name="year" placeholder="Enter Year" size="15"/>
  </td>
  <td>
  <input name="units" placeholder="Enter Units" size="15"/>
  </td>
  <td>
  <input name="grade" placeholder="Enter A-F,P,NP" size="15"/>
  </td>
  <td>
  <input type="hidden" name="add-taken" value="true"/>
  <input type="submit" style="width:10em" value="Submit"/>
  </td>
  </form>
</tr>
</table>

<%@ page import="java.sql.*" %>
        <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
        	//Registering Postgresql JDBC driver with teh DriverManager
        	Class.forName("org.postgresql.Driver");
        	//Open a connection to the database using DriverManager
        	conn = DriverManager.getConnection(
        			"jdbc:postgresql://localhost:5432/postgres?" +
        			"user=postgres&password=postgres");
        	
        	
        	if( request.getParameter("grade")!=null && !request.getParameter("grade").matches(".*[A-D,F,P,NP]*.")){
        		session.setAttribute("error","Please enter the correct grade option.");
        		response.sendRedirect("classes-taken.jsp");
        		return;
        	}
        	
        	if(request.getParameter("add-taken")!=null && request.getParameter("add-taken").equals("true")){
	        	conn.setAutoCommit(false);
	        	pstmt = conn.prepareStatement("INSERT INTO enrollment(s_id, class_id, sec, quarter, year, units, grade) " 
	        			+ "VALUES(?,?,?,?,?,?,?)");
	        	pstmt.setString(1, request.getParameter("s_id"));
	        	pstmt.setInt(2, Integer.parseInt(request.getParameter("class_id")));
	        	pstmt.setInt(3, Integer.parseInt(request.getParameter("sec_id")));
	        	pstmt.setString(4, request.getParameter("quarter"));
	        	pstmt.setInt(5, Integer.parseInt(request.getParameter("year")));
	        	pstmt.setInt(6, Integer.parseInt(request.getParameter("units")));
	        	pstmt.setString(7, request.getParameter("grade"));
	        	pstmt.execute();
	        	conn.commit();
	        	conn.setAutoCommit(true);
	        	
	        	pstmt.close();
	        	conn.close();
        	}
        	
        }
        catch(SQLException e){
        	System.out.println( e.getSQLState() );
        	session.setAttribute("error","One or more input was invalid. Please try again");
        	response.sendRedirect("classes-taken.jsp");
        }
        catch(NumberFormatException e){
        	session.setAttribute("error","Please make sure inputs are valid.");
        	response.sendRedirect("classes-taken.jsp");
        }
        finally {
            // Release resources in a finally block in reverse-order of
            // their creation

            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) { } // Ignore
                rs = null;
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) { } // Ignore
                pstmt = null;
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) { } // Ignore
                conn = null;
            }
        }
        %>


</body>
</html>