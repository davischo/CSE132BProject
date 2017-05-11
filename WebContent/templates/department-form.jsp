<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Department Entry Form</title>
<%  
String failure = (String) session.getAttribute("failure");

if (failure != null) {
%>
    <p style="color:darkred"><%=failure%></p>
<%
    session.setAttribute("failure", null);
}
%>
<a href="../index.jsp">Homepage </a>
</head>

<body>

<table border="1">
    <tr>
        <td valign="top"> </td>
        <td>
            
<%@ page language="java" import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<% 
       Connection conn = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;
       try{
           // Registering Postgresql JDBC driver with the DriverManager
           Class.forName("org.postgresql.Driver");

           // Open a connection to the database using DriverManager
           conn = DriverManager.getConnection(
                   "jdbc:postgresql://localhost/postgres?" +
                           "user=postgres&password=postgres");
		 
    		String action = request.getParameter("action");
    		//Check if an insertion is requested
    	   if (action != null && action.equals("insert")) {

             // Begin transaction
             conn.setAutoCommit(false);
             pstmt = conn.prepareStatement(
                     "INSERT INTO departments(dept_name) VALUES (?)");
             pstmt.setString(1, request.getParameter("dept_name"));
             int rowCount = pstmt.executeUpdate();
             if (rowCount > 0) {
               	 System.out.println("Successfully insert");
              }
             // Commit transaction
             conn.commit();
             conn.setAutoCommit(true);
             
             // Create the statement
             Statement statement = conn.createStatement();

             // Use the created statement to SELECT
             // the student attributes FROM the Student table.
             rs = statement.executeQuery
                     ("SELECT * FROM departments");
            }%>
                     
           	
         <!-- Add an HTML table header row to format the results -->
         <table border="1">
             <tr>
                 <th>Department Name</th>
             </tr>
             <tr>
                 <form action="department-form.jsp" method="get">
                     <input type="hidden" value="insert" name="action">
                     <th><input value="" name="dept_name" required="true"></th>      
                     <th><input type="submit" value="Insert"></th>
                </form>
             </tr>    
        <%
        while ( rs.next() ) {
        %>
 		<tr>
                <form action="department-form.jsp" method="get">
                    <input type="hidden" value="update" name="action">

                    <td>
                        <input value="<%= rs.getString("dept_name") %>"
                               name="dept_name">
                    </td>
                 
                    <!-- Update Button -->
                    <td>
                        <input type="submit" value="Update">
                    </td>
                 </form>
                 
                 <form action="deparment-form.jsp" method="get">
                    <input type="hidden" value="delete" name="action">
                    <!-- Delete Button -->
                    <td>
                        <input type="submit" value="Delete">
                    </td>
                </form>
                
            </tr>                
	      <%
	       }
	      %> 
	      <!-- -------- Close Connection Code -------- -->
      	  <%
              // Close the ResultSet
              rs.close();
      		  
              // Close the Statement
              pstmt.close();
              // Close the Connection
              conn.close();
          } catch (SQLException sqle) {
        	  
              if (request.getParameter("action").equals("insert")) {
                  session.setAttribute("failure", "Failed to insert");
                  response.sendRedirect("department-form.jsp");
              }    
          } catch (Exception e) {

          }
      %> 
         </table>
        </td>
    </tr>
</table>
</body>
</htm>       