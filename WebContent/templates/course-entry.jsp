<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<body>
<a href="../index.jsp">Homepage </a>
 <%  
String failure = (String) session.getAttribute("failure");
if (failure != null) {
%>
    <p style="color:darkred"><%=failure%></p>
<%
    session.setAttribute("failure", null);
}
%>
<table border="1">
    <tr>
        <td valign="top"> </td>
        <td>
           
<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" import="java.lang.*" %>

<% 
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		// Registering Postgresql JDBC driver with the DriverManager
        Class.forName("org.postgresql.Driver");
		
		conn = DriverManager.getConnection("jdbc:postgresql://localhost/postgres?" + 
				"user=postgres&password=postgres");
		
		String action = request.getParameter("action");
	
		//Check if an insert is requested
		if(action != null && action.equals("insert")) {
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement("Insert into courses(course_name,department,lab,min_unit,max_unit,grad_opt,instr_cons)"
					+ "values(?,?,?,?,?,?,?)");
			String dep = request.getParameter("department");
			
			PreparedStatement pstmt1 = conn.prepareStatement("Select dept_id from departments where dept_name = ?");
			pstmt1.setString(1,dep);
			ResultSet set = pstmt1.executeQuery();
			if(set.next()){pstmt.setInt(2,set.getInt("dept_id"));}
			
			boolean labReq, csReq;
			String required = request.getParameter("lab");
			if(required.equals("Yes")) { labReq=true;}
			else {labReq=false;}
			
			required = request.getParameter("instr_cons");
			if(required.equals("Yes")) { csReq = true;}
			else {csReq = false;}
	
            pstmt.setString(1, request.getParameter("courseName"));
            pstmt.setBoolean(3, labReq);
            try {
           	 	pstmt.setInt(4, Integer.parseInt(request.getParameter("min_unit")));
            	pstmt.setInt(5, Integer.parseInt(request.getParameter("max_unit")));
            } 
            catch(Exception e) {
            	pstmt.setInt(4,-1);
            	pstmt.setInt(5,-1);
            } 
           
            pstmt.setString(6, request.getParameter("grad_opt"));
            pstmt.setBoolean(7, csReq);
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
                    <th>Department</th>
                    <th>Require Lab</th>
                    <th>Min Unit</th>
                    <th>Max Unit </th>
                    <th>Grade Option</th>
                    <th>Consent</th>
                    <th>Prerequisite</th>
        
                </tr>	
                
                <tr>
                    <form action="course-entry.jsp" method="get">
                    <input type="hidden" value="insert" name="action">
                        <th><input value="" name="courseName" required="required" size="10"></th>
 
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
	                        					
                        <th>
                        <select id="lab" name="lab" required="required" size="1">
                        	<option>Yes</option>
                        	<option>No</option>
                        </select>
						</th>
						
                        <th><input value="" name="min_unit" required="required" size="5"></th>
                        <th><input value="" name="max_unit" required="required" size="5"></th>
                        
                        <th>
                        <select id="grad_opt" name="grad_opt" required="required">
                        	<option>Letter</option>
                        	<option>PNP</option>
                        	<option>Both</option>
                        </select>
                        </th>
                     					
						<th>
                        <select id="inst_cons" name="instr_cons" required="required" size="1">
                        	<option>Yes</option>
                        	<option>No</option>
                        </select>
						</th>
						<th>
						<a href="prerequisites.jsp">Insert</a>
						</th>
                        <th><input type="submit" value="Insert"></th>
                    </form>
                </tr>    
                
            <%	
        	Statement statement = conn.createStatement();
        	rs = statement.executeQuery("select * from courses");
           // Iterate over the ResultSet
            while (rs.next()) {
            %>  
			<tr>
                <form action="course-entry.jsp" method="get">
                    <input type="hidden" value="update" name="action">

                    <!-- Get the Course Name -->
                    <td>
                        <input value="<%= rs.getString("course_name") %>"
                               name="name" size="10">
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

                    <!-- Get lab option -->
                    <td>
                    	<%
                    	String yes = "Yes";
                    	if(rs.getBoolean("lab") == false) { 
                    		yes = "No";
                    	}%>
                        <input value="<%=yes%>" name="lab" size="5">
                    </td>
                    
                    <!-- Get min unit -->
                    <td>
                        <input value="<%= rs.getInt("min_unit") %>"
                               name="min_unit" size="5">
                    </td>
                    
                    <!-- Get max unit -->
                    <td>
                        <input value="<%= rs.getInt("max_unit") %>"
                               name="max_unit" size="5">
                    </td>
                    
                    <!--   Get the grade option -->
                    <td>
                        <input value="<%= rs.getString("grad_opt") %>"
                               name="grade">
                    </td>
                    
               			<%
                    	yes = "Yes";
                    	if(rs.getBoolean("instr_cons") == false) { 
                    		yes = "No";
                    	}%>
                     <!-- Get instructor-consent option -->
                    <td>
                        <input value="<%=yes %>" name="consent" size="5">
                    </td>
                    
                   <td>
					&nbsp;
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
      		  rss.close();

      		  statement.close();
              // Close the Statement
              pstmt.close();
              // Close the Connection
              conn.close();
          }
          catch (SQLException sqle) {
              if (request.getParameter("action").equals("insert")) {
                  session.setAttribute("failure", "Failed to insert");
                  response.sendRedirect("course-entry.jsp");
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
	