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
        <td valign="top"></td>
        <td>
            
<%@ page language="java" import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.PrintWriter" %>
<% 
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
ResultSet rsss = null;
try{
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost/postgres?" +
                    "user=postgres&password=postgres");
    	
    	String action = request.getParameter("action");
    	
    	if(action!= null && action.equals("insert")){
 
  	      conn.setAutoCommit(false); 
          pstmt = conn.prepareStatement("Insert into sections(sec_id,enr_limit,class_id,taught_by)" 
       		   +"values(?,?,?,?)");
          
          pstmt.setString(1, request.getParameter("sec_id"));
          try{
        	  pstmt.setInt(2,Integer.parseInt(request.getParameter("enr_limit")));
          }
         catch(Exception e){
        	 pstmt.setInt(2,-1);
         }
          
          PreparedStatement pstmt1 = conn.prepareStatement("Select class_id from classes where course_name = ?");
          
		  pstmt1.setString(1,request.getParameter("course_name"));
		  rs = pstmt1.executeQuery();
		  
		  if(rs.next()){pstmt.setInt(3,rs.getInt("class_id"));}
		  pstmt.setString(4,request.getParameter("fac_name"));
		   
		  int rowCount = pstmt.executeUpdate();
		   
			if (rowCount > 0) {
				System.out.println("Successfully inserted");
           }
           // Commit transaction
           conn.commit();
           conn.setAutoCommit(true);
  		}%>
          <!-- Add an HTML table header row to format the results -->
         <table border="1">
             <tr>
                 <th>Course Name</th>
                 <th>Section ID</th>
                 <th>Quarter</th>
                 <th>Year</th>
                 <th>Enrollment Limit</th>
                 <th>Faculty Assigned</th>
             </tr>
             <tr>
  		
			<form action="sections-form.jsp" method="get">
			
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
  
  					<th><input value="" name="sec_id" required="true"></th>
  
				  <th>
				    <select value="" name="quarter">                       
				        <% 
				            // Create the statement    
				            statementCourse = conn.createStatement();
				            rss = statementCourse.executeQuery("SELECT quarter FROM classes");  
				            while(rss.next()){ 
				                    %>
				                        <option value="<%=rss.getString("quarter")%>">
				                        <%=rss.getString("quarter")%> </option> 
				                    <% 
				            }
				              rss.close();
				              statementCourse.close();
				         %>
				      </select>
				  </th> 
  
				  	<th>
				    <select value="" name="year">                       
				        <% 
				            // Create the statement    
				            statementCourse = conn.createStatement();
				            rss = statementCourse.executeQuery("SELECT year FROM classes");  
				            while(rss.next()){ 
				                    %>
				                        <option value="<%=rss.getString("year")%>">
				                        <%=rss.getString("year")%> </option> 
				                    <% 
				            }
				              rss.close();
				              statementCourse.close();
				         %>
				      </select>
				  </th>
				  <th><input type="number" value="" name="enr_limit" required="true"></th>
 				<th>
    			<select value="" name="fac_name">              
        		<% 
            	// Create the statement
            	Statement statementFac = conn.createStatement();
            	ResultSet rsFac = statementFac.executeQuery("SELECT fac_name FROM faculty");
        
            	while(rsFac.next()){                          		
         		%>
                        <option value="<%=rsFac.getString("fac_name")%>">
                        <%=rsFac.getString("fac_name")%></option>
         		<%
            	}
   
             rsFac.close();
             statementFac.close();
         %>
    		</select>
  			</th> 
			<th><input type="submit" value="Insert"></th>
		</form>
<%
        
            // Create the statement
            Statement statement = conn.createStatement();

            // Use the created statement to SELECT
            // the student attributes FROM the Student table.
        rs = statement.executeQuery ("SELECT * FROM sections");

        while (rs.next()) {
   		%>
 		<tr>
        <form action="sections-form.jsp" method="get">
            <input type="hidden" value="update" name="action">
                   
		<%
		  int cID = rs.getInt("class_id");
       	  Statement statement1 = conn.createStatement();
        // Use the created statement to SELECT
        // the student attributes FROM the Student table.
           rsss = statement1.executeQuery ("SELECT * from classes where class_id = " + cID);
           if(rsss.next()) {
		%>
                    <!-- Get the Course Name -->
                     <td>
                        <input value="<%= rsss.getString("course_name") %>"
                               name="course_name">
                    </td>       
                    
                    <!-- Get title option -->
                    <td>
                        <input value="<%= rs.getString("sec_id") %>"
                               name="sec_id">
                    </td>      
                    
                    <td>         				
                		<input value="<%= rsss.getString("quarter") %>"
                               name="quarter">
                	</td>      
                    
                   <!-- Get the Department NAME -->
                	<td>         				
                		<input value="<%= rsss.getString("year") %>"
                               name="year">
                	</td>
         	
                    <td>
                        <input value="<%= rs.getInt("enr_limit") %>"
                               name="enr_limit">
                    </td>
                    
                	<td>  
                		<input value="<%=rs.getString("taught_by")%>" 
                		name="<%=rs.getString("taught_by")%>">
                	</td>
                	
                    <!-- Update Button -->
                    <td>
                        <input type="submit" value="Update">
                    </td>
                 </form>
                 
                 <form action="sections-form.jsp" method="get">
                    <input type="hidden" value="delete" name="action">
                    
                    <!-- Delete Button -->
                    <td>
                        <input type="submit" value="Delete">
                    </td>  
                </form>	
                
         </tr>
       	<%  }
      
       		}
     		  rsss.close();
       		  statement.close();
              rs.close();	  
              // Close the Statement
              pstmt.close();
              // Close the Connection
              conn.close();
       }
       catch (SQLException sqle) { 
	        if (request.getParameter("action").equals("insert")) {
                  session.setAttribute("failure", "Failed to insert ");
                  response.sendRedirect("sections-form.jsp"); 
             }   
       } 
       catch (Exception e) {
       }
  %>
         </table>
        </td>
    </tr>
</table>
</body>
</htm>       