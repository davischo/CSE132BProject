<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Probation Submit</title>
</head>
<body>
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
  Please Enter the Probation Information Below
</tr>
<tr>
  <td>Student Id</td>
  <td>Year</td>
  <td>Quarter</td>
  <td>Reason</td>
</tr>
<tr>
<form action="probation-submit.jsp" method="POST">
  <td>
  <input name="s_id" placeholder="Enter Student Id" size="15"/>
  </td>
  <td>
  <input name="year" placeholder="Enter Year" size="15"/>
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
  <input name="reason" placeholder="Enter Reason" size="15"/>
  </td>
  <td>
  <input type="hidden" name="add-prob" value="true"/>
  <input type="submit" value="Submit"/>
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
        	if(request.getParameter("add-prob")!=null && request.getParameter("add-prob").equals("true")){
        		conn.setAutoCommit(false);
        		pstmt = conn.prepareStatement("INSERT INTO probations(s_id,year,quarter,reason) VALUES(?,?,?,?)");
        		pstmt.setInt(1,Integer.parseInt(request.getParameter("s_id")));
        		pstmt.setInt(2,Integer.parseInt(request.getParameter("year")));
        		pstmt.setString(3,request.getParameter("quarter"));
        		pstmt.setString(4,request.getParameter("reason"));
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
        	response.sendRedirect("http://localhost:8888/CSE132BFolder/templates/probation-submit.jsp");
        }
        catch(NumberFormatException e){
        	session.setAttribute("error","Please make sure inputs are correct.");
        	response.sendRedirect("http://localhost:8888/CSE132BFolder/templates/probation-submit.jsp");
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