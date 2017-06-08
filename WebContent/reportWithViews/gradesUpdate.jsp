<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Decision Support</title>
</head>
<body>
<%@page import="java.util.*, java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%
Connection conn = null;
Statement statement = null;
Statement st = null;
PreparedStatement ps = null;
ResultSet rs = null;
ResultSet rs2 = null;
try{
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost/postgres?" +
                    "user=postgres&password=postgres");
	String action = request.getParameter("action");
	statement = conn.createStatement();
	
	if (action != null && action.equals("insert")) {
        // Begin transaction
        conn.setAutoCommit(false);
        ps = conn.prepareStatement(
                "INSERT INTO enrollment(s_id,class_id,quarter,year,units,grade) VALUES (?,?, ?,?,4,?)");
        
        String course = request.getParameter("cid");
        String q = request.getParameter("quarter");
        int y = Integer.parseInt(request.getParameter("year"));
        
        ps.setInt(1, Integer.parseInt(request.getParameter("sid")));
        
        Statement stae = conn.createStatement();
        ResultSet sett = stae.executeQuery("select class_id from classes where course_name = '" + course + "' and quarter = '" + q + "' and year = " +y );
        if(sett.next()){
        	ps.setInt(2, sett.getInt("class_id"));
        }
        ps.setString(3,request.getParameter("quarter"));
        ps.setInt(4,Integer.parseInt(request.getParameter("year")));
        ps.setString(5,request.getParameter("grade"));
		int rowCount = ps.executeUpdate();
        if (rowCount > 0) {
          	 System.out.println("Successfully insert");
         }
        // Commit transaction
        conn.commit();
        conn.setAutoCommit(true);
    }
	
	else if (action != null && action.equals("update")) {
        // Begin transaction
        conn.setAutoCommit(false);
        ps = conn.prepareStatement(
                "UPDATE enrollment SET grade = ? where s_id = ? and class_id = ? and quarter=? and year = ?");
       
    	ps.setString(1,request.getParameter("grade"));
        ps.setInt(2, Integer.parseInt(request.getParameter("sid")));
        ps.setInt(3, Integer.parseInt(request.getParameter("cid")));
        ps.setString(4,request.getParameter("quarter"));
        ps.setInt(5,Integer.parseInt(request.getParameter("year")));
        
		int rowCount = ps.executeUpdate();
        if (rowCount > 0) {
          	 System.out.println("Successfully update");
         }
        // Commit transaction
        conn.commit();
        conn.setAutoCommit(true);
    }
        
        // Create the statement
        statement = conn.createStatement();

        // Use the created statement to SELECT
        // the student attributes FROM the Student table.
        rs = statement.executeQuery
                ("Select s.id as sid, first,middle,last from students s");
        
        st = conn.createStatement();
        rs2 = st.executeQuery("SELECT distinct course_name FROM classes order by course_name"); 

     %>               
      	
    <!-- Add an HTML table header row to format the results -->
    <table border="1">
        <tr>
            <form action="gradesUpdate.jsp" method="get">
                <input type="hidden" value="insert" name="action">
                <select id="sid" required ="required" name="sid">
				<% 
				while(rs.next()){
				%>
				    <option value="<%=rs.getInt("sid")%>"><%=rs.getString("first") + " " + rs.getString("last")%> </option>
				<%}%>
				</select>
				
				<select id="cid" required ="required" name="cid">
				<% 
				while(rs2.next()){
				%>
				    <option><%=rs2.getString("course_name")%></option>
				<%}%>
				</select>
				</select>
				<select id="quarter" name="quarter">
				  <option value="">Quarter</option>
				  <option value="SP">SP</option>
				  <option value="FA">FA</option>
				  <option value="WI">WI</option>
				</select>
				<input type="text" name="year" placeholder="Year" value=""/>
				<input type="text" name="grade" placeholder="Enter Grade" value=""/>
				<input type="submit" value="Insert">
			</form>
			</tr> 
            </table> 
            
           <table border="1">
            <tr>
            <th>Student Name</th>
            <th>Classes</th>
            <th>Quarter</th>
            <th>Year</th>
            <th>Grade</th>
            </tr>
 			<tr>
<%
        
// Create the statement
Statement stt = conn.createStatement();

// Use the created statement to SELECT
// the student attributes FROM the Student table.
ResultSet rrrs = stt.executeQuery ("SELECT s_id, class_id, quarter, year, grade FROM enrollment where grade is not null order by year,quarter DESC");
  
while (rrrs.next()) {
  int cid = rrrs.getInt("class_id");
  int sid = rrrs.getInt("s_id");

  
  Statement ss = conn.createStatement();
  Statement s = conn.createStatement();
  ResultSet r =  s.executeQuery("select course_name from classes where class_id = " + cid);
  ResultSet rr = ss.executeQuery("select first, last from students where id = " +  sid);
  
  if(r.next() && rr.next()){
   	%>
   				<tr>
                <form action="gradesUpdate.jsp" method="get">
                    <input type="hidden" value="update" name="action">
                    <input type="hidden" value=<%=cid%> name="cid">
                    <input type="hidden" value=<%=sid%> name="sid">

	                <!-- Get Student option -->
                    <td><%=rr.getString("first") + "  " + rr.getString("last")%></td>
                    
                    <!-- Get the Course Name -->
                    <td><%=r.getString("course_name") %></td>
            
                    <td>         				
                		<input value="<%= rrrs.getString("quarter") %>"
                               name="quarter">
                	</td>
                	
                    <!-- Get the Department NAME -->
                	<td>         				
                		<input value="<%= rrrs.getString("year") %>"
                               name="year">
                	</td>
                	
                	<td>         				
                		<input value="<%= rrrs.getString("grade") %>"
                               name="grade">
                	</td>
         	    	
                    <!-- Update Button -->
                    <td>
                        <input type="submit" value="Update">
                    </td>
                 </form>
				</tr>
                 
<%}}} catch (SQLException e){
	e.printStackTrace();
}
finally{

	if(rs != null) {rs.close();}
	if(ps!=null) {ps.close();}
	if(statement!=null) {statement.close();}
	if(conn!= null) {conn.close();}}%>
 </tr>
</table>
</body>
</html>