<html>
<head>
<a href="../index.jsp">Homepage </a>
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
        	 session.setAttribute("failure","Please insert an integer for enrollment limit.");
        	 response.sendRedirect("sections-form.jsp");
        			 return;
        			
        	 //pstmt.setInt(2,-1);
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
                 <th>Class Title</th>
                 <th>Quarter</th>
                 <th>Year</th>
                 <th>Section ID</th>
                 <th>Enrollment Limit</th>
                 <th>Instructor</th>
             </tr>
             <tr><th>Add a New Section</th></tr>
             <tr>
	         <% 
	           // Create the statement
	           
	           Statement statementCourse = conn.createStatement();
	           ResultSet rss = statementCourse.executeQuery("SELECT * FROM classes");  
	           Statement statementFac = null;
	             
	           while(rss.next()){ 
	        	    statementFac = conn.createStatement();
		            rsss = statementFac.executeQuery("SELECT * FROM faculty");
	           %>
  					
  					<tr>
					<form action="sections-form.jsp" method="POST">			
                    <input type="hidden" value="insert" name="action">
                    <td><input name="course_name" value="<%=rss.getString("course_name")%>" readonly/></td>
                    <td><input name="title" value="<%=rss.getString("title")%>" readonly/></td>
                    <td><input name="quarter" value="<%=rss.getString("quarter")%>" readonly/></td>
                    <td><input name="year" value="<%=rss.getInt("year")%>" readonly/></td>
                    <td><input name="sec_id" placeholder="Enter a SectionID"/></td>
                    <td><input name="enr_limit" min="1" placeholder="Enrollment Limit"/></td>
                    <td><select name="taught_by">
                    <%
                    while(rsss.next()){
                    	%>
                    	<option><%=rsss.getString("fac_name")%></option>
                    	<% 
                    }
                    %>
                    </select></td>
                    <td><input type="submit" value="Submit"/></td>
                    </form>
					</tr>

<%			}
	        %>
	        <tr><th>Existing Sections</th></tr>   
	        <%
        
            // Create the statement
            Statement statement = conn.createStatement();

            // Use the created statement to SELECT
            // the student attributes FROM the Student table.
	        rs = statement.executeQuery ("SELECT * FROM sections s, classes c WHERE s.class_id=c.class_id");
	
	        while (rs.next()) {
        	    statementFac = conn.createStatement();
	            rsss = statementFac.executeQuery("SELECT * FROM faculty");
	   		%>
	 		<tr>
	        <form action="sections-form.jsp" method="POST">
	            <input type="hidden" value="update" name="action">
	           
	            <!-- Get the Course Name -->
	            <td>
	                <input value="<%= rs.getString("course_name") %>"
	                       name="course_name" readonly/>
	            </td>       
	            
	            <!-- Get title option -->
	            <td>
	                <input value="<%= rs.getString("title") %>"
	                       name="title" readonly/>
	            </td>      
	            
	            <td>         				
	        		<input value="<%= rs.getString("quarter") %>"
	                       name="quarter" readonly/>
	        	</td>      
	            
	           <!-- Get the Department NAME -->
	        	<td>         				
	        		<input value="<%= rs.getString("year") %>"
	                       name="year" readonly/>
	        	</td>
	 			
	 			<td>
	 				<input value="<%=rs.getString("sec_id")%>"
	 					   name="sec_id">
	 			</td>
	 			
	            <td>
	                <input value="<%= rs.getInt("enr_limit") %>"
	                       name="enr_limit">
	            </td>
	            
	        	<td>  
	        	<select name="taught_by">
	        	<%
	        	while(rsss.next()){
	        		%>
	        		<option><%=rsss.getString("fac_name")%></option>
	        		<%
	        	}
	        	%>
	        	
	        	</select>
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
       	<%  
      
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