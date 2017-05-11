<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Review Session Submit</title>
</head>
<body>
<a href="../index.jsp">Homepage </a>
<h1 style="color:blue">Review Session Entry Form</h1>
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
  Please Enter the Review Session Information
<tr>
  <td>Room</td>
  <td>Start Time</td>
  <td>End Time</td>
  <td>Day</td>
  <td>Section ID</td>
</tr>
<tr>
<form action="review-session-submit.jsp" method="POST">
  <td>
  <input name="room" placeholder="Room Number" size="15"/>
  </td>
  <td>
  <input name="start_time" placeholder="00:00am" size="15"/>
  </td>
  <td>
  <input name="end_time" placeholder="00:00pm" size="15"/>
  </td>
  <td>
  <input name="day" placeholder="mm/dd/yy" size="15"/>
  </td>
  <td>
  <input name="sec_id" placeholder="Section ID" size="15"/>
  </td>
  <td>
  <input type="hidden" name="add-rs" value="true"/>
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
        	if(request.getParameter("add-rs")!=null && request.getParameter("add-rs").equals("true")){
        		conn.setAutoCommit(false);
        		pstmt = conn.prepareStatement("INSERT INTO meetings(type,weekly,mandatory,room,start_time,end_time,day,sec_id) " 
        			+ "VALUES('review',false,false,?,?,?,?,?)");
        		pstmt.setString(1,request.getParameter("room"));
        		pstmt.setString(2,request.getParameter("start_time"));
        		pstmt.setString(3,request.getParameter("end_time"));
        		pstmt.setString(4,request.getParameter("day"));
        		pstmt.setInt(5,Integer.parseInt(request.getParameter("sec_id")));
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
        	response.sendRedirect("review-session-submit.jsp");
        }
        catch(NumberFormatException e){
        	session.setAttribute("error","Please make sure inputs are correct.");
        	response.sendRedirect("review-session-submit.jsp");
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