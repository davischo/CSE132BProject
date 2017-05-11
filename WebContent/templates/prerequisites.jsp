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
    		   conn.setAutoCommit(false);
               pstmt = conn.prepareStatement(
                       "INSERT INTO prerequisites(course,pre) VALUES (?,?)");
               pstmt.setString(1, request.getParameter("course"));
               pstmt.setString(2, request.getParameter("pre"));
               int rowCount = pstmt.executeUpdate();
               if (rowCount > 0) {
                 	 System.out.println("Successfully insert");
                }      
               // Commit transaction
               conn.commit();
               conn.setAutoCommit(true);
    	   }
   
            %>
    		
    	   <!-- Add an HTML table header row to format the results -->
           <table border="1">
               <tr>
                   <th>Course Name </th>
                   <th>Prerequisites</th>
               </tr>
               
               <tr>
                   <form action="prerequisites.jsp" method="get">
                       <input type="hidden" value="insert" name="action">
                       <th>
	                    <select value="" name="course">                       
	                        <% 
	                            // Create the statement
	                          
	                        Statement statementCourse = conn.createStatement();
	                        ResultSet rss = statementCourse.executeQuery("SELECT course_name FROM courses");
	                            
	                                while(rss.next()){ 
	                                    %>
	                                        <option value="<%=rss.getString("course_name")%>">
	                                        <%=rss.getString("course_name")%> </option>
	                                    <% 
	                                }

	                         %>
	                      </select>
	                  </th> 
	                  
	                  <th>
	                    <select value="" name="pre">                       
	                        <% 
	                            // Create the statement
	                            rss = statementCourse.executeQuery("SELECT course_name FROM courses");
	                            
	                                while(rss.next()){ 
	 						%>
	                                        <option value="<%=rss.getString("course_name")%>">
	                                        <%=rss.getString("course_name")%></option>
	                                    <% 
	                                }
	                                rss.close();
	                                statementCourse.close();  
	                         %>
	                      </select>
	                  </th>           
                      <th><input type="submit" value="Insert"></th>
                   </form>
               </tr>
		<% 
        // Create the statement
        Statement statement = conn.createStatement();
        // Use the created statement to SELECT
        // the student attributes FROM the Student table.
        rs = statement.executeQuery
                ("SELECT * FROM prerequisites Order By course");
        while ( rs.next() ) {
        %>
 		<tr> 
 		      <form action="prerequisites.jsp" method="get">
                    <input type="hidden" value="update" name="action">
                    
                    <!-- Get the Course Name -->
                    <td>
                        <input value="<%= rs.getString("course") %>"
                               name="course">
                    </td>
                    
                    <!-- Get the Course Name -->
                    <td>
                        <input value="<%= rs.getString("pre") %>"
                               name="pre">
                    </td>
                    
                  <!-- Update Button -->
                    <td>
                        <input type="submit" value="Update">
                    </td>
                 </form>
                 
                 <form action="prerequisites.jsp" method="get">
                    <input type="hidden" value="delete" name="action">
                    <!-- Delete Button -->
                    <td>
                        <input type="submit" value="Delete">
                    </td>
                </form>
      
            </tr>                
          
        <%}
        // Close the ResultSet
        rs.close();
		  
        // Close the Statement
        pstmt.close();
        // Close the Connection
        conn.close(); 
       }catch(SQLException e){ 
           if (request.getParameter("action").equals("insert")) {
               session.setAttribute("failure", "Failed to insert");
               response.sendRedirect("prerequisites.jsp");
           }    
       }catch (Exception e) {

       }
       %>
         </table>
        </td>
    </tr>
</table>
</body>
</htm> 
