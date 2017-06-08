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
<a href="../index.jsp">Homepage </a>
</head>
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
             pstmt = conn.prepareStatement(
                     "INSERT INTO faculty(fac_name,title,department) VALUES (?,?, ?)");
             pstmt.setString(1, request.getParameter("fac_name"));
             pstmt.setString(2, request.getParameter("title"));
             String dep = request.getParameter("department");
             
			 PreparedStatement pstmt1 = conn.prepareStatement("Select dept_id from departments where dept_name = ?");
 			 pstmt1.setString(1,dep);
 			 ResultSet set = pstmt1.executeQuery();
 			 if(set.next()){pstmt.setInt(3,set.getInt("dept_id"));}
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
                     ("SELECT * FROM faculty");
            }%>
                     
           	
         <!-- Add an HTML table header row to format the results -->
         <table border="1">
             <tr>
                 <th>Faculty Name</th>
                 <th>Title</th>
                 <th>Department</th>
             </tr>
             <tr>
                 <form action="faculty-entry.jsp" method="get">
                     <input type="hidden" value="insert" name="action">
                     <th><input value="" name="fac_name" required="true"></th>
                     <!-- <th><input value="" name="last_name" required="true"></th> -->
                     
            		 <th>
                     <select id="title"required="required" name="title">
                     <option>Lecturer</option>
                     <option>Assistant Professor</option>
                     <option>Associate Professor</option>
                     <option>Professor</option>
                     </select>
                     </th>
                     
	                 <th>
	                    <select value="" name="department">    
	                        <% 
	                            // Create the statement
	                            Statement statementDept = conn.createStatement();
	                            ResultSet rss = statementDept.executeQuery("SELECT dept_name FROM departments");
	                                while(rss.next()){ 
	                                    %>
	                                        <option value=<%=rss.getString("dept_name")%>><%=rss.getString("dept_name")%> </option>
	                                    <% 
	                                }
	                                rss.close();
	                                statementDept.close();
	                         %>
	                    </select>
	                  </th>                      
                     <th><input type="submit" value="Insert"></th>
                 </form>
             </tr>    
        <%
        while ( rs.next() ) {
        %>
 		<tr>
                <form action="faculty-entry.jsp" method="get">
                    <input type="hidden" value="update" name="action">

<%--                <!-- Get the Course Name -->
                      <td>
                        <input value="<%= rs.getString("first_name") %>"
                               name="name">
                    </td> --%>
                    
                    <td>
                        <input value="<%= rs.getString("fac_name") %>"
                               name="fac_name">
                    </td>
                    
                    <!-- Get title option -->
                    <td>
                        <input value="<%= rs.getString("title") %>"
                               name="title">
                    </td>
                  
                    <!-- Get the Department NAME -->
                	<td>         				
                		<% 
		                    // Create the statement
		                    int deptID = rs.getInt("department");
                			PreparedStatement ps = conn.prepareStatement("Select dept_name from departments where dept_id = ?");
                			ps.setInt(1,deptID);
                			String deptName = "";
                			ResultSet s = ps.executeQuery();
                			if(s.next()){
                			 deptName = s.getString("dept_name");}
                		%>
                		<input value="<%=deptName%>" name="<%=deptName%>">
		                <% 			                		
		                	ps.close();
                		 %>
                	</td>


                    <!-- Update Button -->
                    <td>
                        <input type="submit" value="Update">
                    </td>
                 </form>
                 
                 <form action="course-entry.jsp" method="get">
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
                  response.sendRedirect("faculty-entry.jsp");
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
              
             
             
             