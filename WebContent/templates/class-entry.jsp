<html>
<head>
</head>
<%  
String failure = (String) session.getAttribute("failure");
if (failure != null) {
%>
    <p style="color:darkred"><%=failure%></p>
<%
    session.setAttribute("failure", null);
}
%>
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
	                    "INSERT INTO classes (course_name,title,quarter,year,scheduled_fac) VALUES (?,?,?,?,?)");
	
	            String courseName = request.getParameter("course_name");
				pstmt.setString(1,courseName);
	            pstmt.setString(2, request.getParameter("title"));
	            pstmt.setString(3, request.getParameter("quarter"));
	            
	            try{
	            	pstmt.setInt(4, Integer.parseInt(request.getParameter("year")));	
	            } catch(Exception e) {
	            	pstmt.setInt(4,-1);
	            }
	            
	            
	            String name = request.getParameter("fac");
	            String first = name.split(" ")[0];
	            String last = name.split(" ")[1];
	            
	            PreparedStatement st = conn.prepareStatement("Select id from faculty where first_name = ? and last_name = ?");
	            st.setString(1,first);
	            st.setString(2,last);
	            
	            ResultSet r = st.executeQuery();
	            
	            if(r.next()) {pstmt.setInt(5, r.getInt("id"));}
	            r.close(); 
	            st.close();
	            
	            int rowCount = pstmt.executeUpdate();
	            if (rowCount > 0) {
	            }
	            // Commit transaction
	            conn.commit();
	            conn.setAutoCommit(true);

             }
          %>
          <!-- Add an HTML table header row to format the results -->
         <table border="1">
             <tr>
                 <th>Course Name</th>
                 <th>Title</th>
                 <th>Quarter</th>
                 <th>Year</th>
                 <th>Faculty Scheduled </th>
                 <th>Sections</th>
             </tr>
             <tr>
                 <form action="class-entry.jsp" method="get">
                     <input type="hidden" value="insert" name="action">
                     
                     <th>
	                    <select value="" name="course_name">                       
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
	                                rss.close();
	                                statementCourse.close();
	                         %>
	                      </select>
	                  </th> 
	                   
	                  <th><input value="" name="title" required="true"></th>
	                  
	                  <th>
	                  <select value="" name="quarter">
	                  <option>FALL</option>
	                  <option>WINTER</option>
	                  <option>SPRING</option>
	                  </select>
	                  </th>
	                  
	                  <th><input required="true" type=number name="year" min="1960"/></th>
	          	      <th>
	                    <select value="" name="fac">              
	                        <% 
	                            // Create the statement
	                            Statement statementFac = conn.createStatement();
	                            ResultSet rsFac = statementFac.executeQuery("SELECT first_name,last_name FROM faculty");
	                            String fac_name = ""; 
	                            while(rsFac.next()){ 
	                            		fac_name = rsFac.getString("first_name") + " " + rsFac.getString("last_name");
	                            		
	                                    %>
	                                        <option value="<%=rsFac.getString("first_name") + " " + rsFac.getString("last_name")%>">
	                                        <%=fac_name%></option>
	                                    <% 
	                                }
	                                rsFac.close();
	                                statementFac.close();
	                         %>
	                    </select>
	                  </th>             
	                 <th><a href="sections.jsp">Insert Here </a></th>         
                     <th><input type="submit" value="Insert"></th>
                 </form>
             </tr>    
        <%
        
            
            // Create the statement
            Statement statement = conn.createStatement();

            // Use the created statement to SELECT
            // the student attributes FROM the Student table.
            rs = statement.executeQuery
                    ("SELECT * FROM classes");
            
            while ( rs.next() ) {
        %>
 		<tr>
                <form action="class-entry.jsp" method="get">
                    <input type="hidden" value="update" name="action">

                    <!-- Get the Course Name -->
                    <td>
                        <input value="<%= rs.getString("course_name") %>"
                               name="course_name">
                    </td>
                    
                    <!-- Get title option -->
                    <td>
                        <input value="<%= rs.getString("title") %>"
                               name="title">
                    </td>
                    
                    <td>         				
                		<input value="<%= rs.getString("quarter") %>"
                               name="quarter">
                	</td>
                	
                    <!-- Get the Department NAME -->
                	<td>         				
                		<input value="<%= rs.getString("year") %>"
                               name="year">
                	</td>
         	
                	<td>  
                	<%
                	// Create the statement
                    int facID = rs.getInt("scheduled_fac");
        			PreparedStatement ps = conn.prepareStatement("Select first_name,last_name from faculty where id = ?");
        			ps.setInt(1,facID);
        			String facName = "";
        			ResultSet s = ps.executeQuery();
        			if(s.next()){
        			 facName = s.getString("first_name") + " " + s.getString("last_name");}
                	 %>       				
                	 <input value="<%=facName%>" name="<%=facName%>">
                	</td>
                	
                	<td><a href="sections.jsp">Insert Here </a></td> 
                	
                    <!-- Update Button -->
                    <td>
                        <input type="submit" value="Update">
                    </td>
                 </form>
                 
                 <form action="class-entry.jsp" method="get">
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
                  session.setAttribute("failure", "Failed to insert ");
                  response.sendRedirect("class-entry.jsp");
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
             