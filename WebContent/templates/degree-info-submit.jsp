<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Degree Information Submission</title>
</head>
<body>
<a href="../index.jsp">Homepage </a>
<h1 style="color:blue">Degree Information Submission</h1>
<%
if(session.getAttribute("error")!=null){
	%>
	<h3 style="color:red"><%=session.getAttribute("error")%></h3>
	<%
	session.removeAttribute("error");
}
%>

<%@ page import="java.sql.*" %>
        <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs0,rs1 = null;
        Statement s0, s1 = null;

        try {
        	//Registering Postgresql JDBC driver with teh DriverManager
        	Class.forName("org.postgresql.Driver");
        	//Open a connection to the database using DriverManager
        	conn = DriverManager.getConnection(
        			"jdbc:postgresql://localhost:5432/postgres?" +
        			"user=postgres&password=postgres");
        	
        	s0 = conn.createStatement();
        	rs0 = s0.executeQuery("SELECT * FROM degrees, departments WHERE degrees.department=departments.dept_id");
        	%>
        	<table border="1">
        	<tr><td>Create a New Degree</td></tr>
        	<tr>
        	  <tr>
        	    <form action="degree-info-submit.jsp" method="POST">
        	      <td><input name="name" placeholder="Enter a Degree Name"/></td>
        	      <td><input name="department" placeholder="Enter Department ID"/></td>
        	      <td><input type="submit" value="Submit"/></td>
        	    </form>
        	  </tr>
        	<tr><th>Add Requirements</th></tr>
        	<tr>
        	  <td>Degree</td>
        	  <td>Department</td>
        	  <td>Category</td>
        	  <td>Units</td>
        	</tr>
        	<%
        	while(rs0.next()){
           		s1 = conn.createStatement();
            	rs1 = s1.executeQuery("SELECT * FROM categories");
        	%>
        	<tr>    	
        	  <form action="degree-info-submit.jsp" method="POST">
        	  <td><input name="name" value="<%=rs0.getString("name")%>" readonly/>
        	  <td><input name="dept_name" value="<%=rs0.getString("dept_name")%>" readonly/>
        	  <td> 
        	  <select name="cat_id">
        	  <%   
        	  while(rs1.next()){ %> 
        	      <option value="<%=rs1.getInt("id") %>"><%=rs1.getString("name") %></option>
        	   <% 
        	  } %>
        	  </select>
        	  <td><input name="units" placeholder="Units Required"/></td>
        	  </td>
        	  <input type="hidden" name="dept_id" value="<%=rs0.getInt("dept_id")%>"/>
			  <input type="hidden" name="deg_id" value="<%=rs0.getInt("id")%>"/>
			  <input type="hidden" name="add-req" value="true"/>
        	  <td><input type="submit" value="Add Requirements"/></td>
        	  </form>
        	</tr>
        	<%
        	}
        	if(request.getParameter("add-req")!=null && request.getParameter("add-req").equals("true")){
        		conn.setAutoCommit(false);
        		pstmt = conn.prepareStatement("INSERT INTO requirements(deg_id,cat_id,units) VALUES(?,?,?)");
        		pstmt.setInt(1,Integer.parseInt(request.getParameter("deg_id")));
        		pstmt.setInt(2,Integer.parseInt(request.getParameter("cat_id")));
        		pstmt.setInt(3,Integer.parseInt(request.getParameter("units")));
        		pstmt.execute();
        		conn.commit();
        		conn.setAutoCommit(true);
        	}
        }
        catch(SQLException e){
        	System.out.println(e.getSQLState());
        	session.setAttribute("error", "One or more input was invalid. Please try again.");
        	response.sendRedirect("degree-info-submit.jsp");
        }
        finally{
        	
        } 
        %>
</table>
</body>
</html>