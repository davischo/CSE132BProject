<html>
<head>
<%  
String failure = (String) session.getAttribute("failure");

if (failure != null) {
%>
    <p style="color:darkred"><%=failure%></p>
<%
    session.setAttribute("failure", null);
}
%>
</head>
</br>
<a href="../index.jsp">Homepage </a>
<body>

<table border="1">
    <tr>
        <td valign="top"> </td>
        <td>
            
<%@ page language="java" import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

             // Create the prepared statement and use it to
             //INSERT the student attributes INTO the Student table.
             pstmt = conn.prepareStatement(
                     "INSERT INTO students(first,middle,last,s_id,ssn,level,residency,college)" +
                             " VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
             
             pstmt.setString(1, request.getParameter("first"));
             pstmt.setString(2, request.getParameter("middle"));
             pstmt.setString(3, request.getParameter("last"));
             pstmt.setString(4, request.getParameter("s_id"));
             try {
            	 pstmt.setInt(5, Integer.parseInt(request.getParameter("ssn")));
             }
             catch (Exception e){
            	 pstmt.setInt(5,-1);
             }

             pstmt.setString(6, request.getParameter("level"));
             
             pstmt.setString(7, request.getParameter("residency"));
             pstmt.setString(8, request.getParameter("college"));
             int rowCount = pstmt.executeUpdate();
             if (rowCount > 0) {
            	 System.out.println("Successfully insert");
            	 
             }
             // Commit transaction
             conn.commit();
             conn.setAutoCommit(true);
            }
         %>

           <%
                // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                rs = statement.executeQuery
                        ("SELECT * FROM students"); %>
                        
              	
                    	<!-- Add an HTML table header row to format the results -->
            <table border="1">
                <tr>
                    <th>First Name</th>
                    <th>Middle Name</th>
                    <th>Last Name</th>
                    <th>Student ID</th>
                    <th>SSN </th>
                    <th>Level</th>
                    <th>Residency</th>
                    <th>College</th>
                    <th>Action</th>
                </tr>
                <tr>
                    <form action="student-entry.jsp" method="get">
                        <input type="hidden" value="insert" name="action">
                        <th><input value="" name="first" required="required" size="10"></th>
                        <th><input value="" name="middle" size="10"></th>
                        <th><input value="" name="last" required="required" size="10"></th>
                        <th><input value="" name="s_id" required="required" size="10"></th>
                        <th><input value="" name="ssn" size="10"></th>
                        <th>
                        <select id="level"required="required" name="level">
                        <option>Undergraduate</option>
                        <option>Graduate</option>
                        <option>BS/MS Program</option>
                        </select>
                        </th>
                        <th>
                        <select id="residency" name="residency" required="required" name="state">
                        <option>California Resident</option>
                        <option>Non-California Resident</option>
                        <option>International</option>
                        </select>
                        </th>
                      	<th>
                      	<select id="college" name="college">
                      	<option>N/A</option>
                        <option>Revelle</option>
                        <option>Muir</option>
                        <option>Marshall</option>
                        <option>Warren</option>
                        <option>ERC</option>
                        <option>Sixth</option>
                        </select>
                      	</th>
                        <th><input type="submit" value="Insert"></th>
                    </form>
                </tr>    
           <% 
           // Iterate over the ResultSet
            while ( rs.next() ) {
            %>  
            	<tr>
                <form action="student-entry.jsp" method="get">
                    <input type="hidden" value="update" name="action">

                    <!-- Get the FIRSTNAME -->
                    <td>
                        <input value="<%= rs.getString("first") %>"
                               name="FIRSTNAME" size="15">
                    </td>

                    <!-- Get the middle NAME -->
                    <td>
                        <input value="<%= rs.getString("middle") %>"
                               name="MIDDLENAME" size="15">
                    </td>

                    <!-- Get the LAST NAME -->
                    <td>
                        <input value="<%= rs.getString("last") %>"
                               name="LASTNAME" size="15">
                    </td>
                    
                    <!-- Get the student ID -->
                    <td>
                        <input value="<%= rs.getString("s_id") %>"
                               name="s_id" size="10">
                    </td>
                    
                    <!--   Get the SSN, which is a number -->
                    <td>
                        <input value="<%= rs.getInt("SSN") %>"
                               name="SSN" size="10">
                    </td>
                    
                   <!--  Get the level-->
                    <td>
                        <input value="<%= rs.getString("level") %>"
                               name="Level" size="15">
                    </td>
                    
                   <!--  Get the residency -->
                    <td>
                        <input value="<%= rs.getString("residency") %>"
                               name="RESIDENCY" size="15">
                    </td>
                    
                   <td>
                   <input value="<%= rs.getString("college") %>"
                               name="college" size="10">
                    </td>
                    <!-- Update Button -->
                    <td>
                        <input type="submit" value="Update">
                    </td>
                    
                 </form>
                 <form action="student-entry.jsp" method="get">
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
      		  statement.close();
              // Close the Statement
              pstmt.close();
              // Close the Connection
              conn.close();
          }
          catch (SQLException sqle) {
              if (request.getParameter("action").equals("insert")) {
                  session.setAttribute("failure", "Failed to insert");
                  response.sendRedirect("student-entry.jsp");
              }  
          } catch (Exception e) {
              //out.println(e.getMessage());
          }
      %> 
         </table>
        </td>
    </tr>
</table>
</body>
</htm>

 
           


 