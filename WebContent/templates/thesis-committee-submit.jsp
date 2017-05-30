<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Thesis Committee Submission</title>
</head>
<body>
<a href="../index.jsp">Homepage </a>
<h1 style="color:blue">Thesis Committee Entry Form</h1>
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
  Please Enter the Committee Information Below
</tr>
<tr>
  <td>Student Id</td>
  <td>Faculty Name</td>
</tr>
<tr>
<form action="thesis-committee-submit.jsp" method="POST">
  <td>
  <input name="s_id" placeholder="Enter Student Id" size="15"/>
  </td>
  <td>
  <input name="fac_name" placeholder="Enter Faculty Name" size="15"/>
  </td>
  <td>
  <input type="hidden" name="add-tc" value="true"/>
  <input type="submit" value="Submit"/>
  </td>
  </form>
</tr>
</table>

<%@ page import="java.sql.*" %>
        <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        Statement st = null;
        ResultSet rs = null;
        //Statement s3 = conn.createStatement();

        try {
        	//Registering Postgresql JDBC driver with teh DriverManager
        	Class.forName("org.postgresql.Driver");
        	//Open a connection to the database using DriverManager
        	conn = DriverManager.getConnection(
        			"jdbc:postgresql://localhost:5432/postgres?" +
        			"user=postgres&password=postgres");
        	//s3.executeQuery("SELECT * FROM students WHERE level ='' ");
        	if(request.getParameter("add-tc")!=null && request.getParameter("add-tc").equals("true")){
        		conn.setAutoCommit(false);
        		st = conn.createStatement();
        		int id = Integer.parseInt(request.getParameter("s_id"));
        		rs = st.executeQuery("SELECT level FROM students WHERE id=" + id);
        		if(rs.next()){
        			if(!rs.getString("level").equals("Undergraduate") ){
                		pstmt = conn.prepareStatement("INSERT INTO thesis_committee(s_id,fac_name) VALUES(?,?)");
                		pstmt.setInt(1, id);
                		pstmt.setString(2,request.getParameter("fac_name"));
                		pstmt.execute();
                		pstmt.close();
        			}
        			else{
        				session.setAttribute("error", "Student is an undergrad");
        				response.sendRedirect("thesis-committee-submit.jsp");
        				return;
        			}
        		}
        		conn.commit();
        		conn.setAutoCommit(true);
            	conn.close();
        	}
        	
        }
        catch(SQLException e){
        	System.out.println( e.getSQLState() );
        	session.setAttribute("error","One or more input was invalid. Please try again");
        	response.sendRedirect("thesis-committee-submit.jsp");
        }
        catch(NumberFormatException e){
        	session.setAttribute("error","Please make sure inputs are correct.");
        	response.sendRedirect("thesis-committee-submit.jsp");
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