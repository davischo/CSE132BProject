<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Conflicting Classes</title>
</head>
<body>
<%@page import="java.util.*, java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%
Connection conn = null;
Statement statement = null;
PreparedStatement ps = null;
PreparedStatement ps2 = null;
PreparedStatement ps3 = null;
ResultSet r  = null;
ResultSet rs = null;
ResultSet rs2 = null;
ResultSet rs3 = null;
try{
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost/postgres?" +
                    "user=postgres&password=postgres");
	String action = request.getParameter("action");
	statement = conn.createStatement();
	rs = statement.executeQuery("Select s.id as sid, first,middle,last from students s, " +
			"enrollment e where e.quarter = 'SP' and e.year = 2017 and e.s_id = s.id"); 
	%>
	<form action="Report2A.jsp" method="post">
	<input type="hidden" value="pick" name="action">
	<select id="sid" required ="required" name="sid">
	<% 
	while(rs.next()){
	%>
	    <option value="<%=rs.getInt("sid")%>"><%=rs.getString("first") + " " + rs.getString("last")%> </option>
	<%}
	%>
	</select>
	<input type="submit" value="Submit">
	</form>
	<%
	if (request.getParameter("action")!= null && request.getParameter("action").equals("pick")){
		%> 	
		<table cellspacing="5">
			<table border="1" cellspacing="5">
			<thead>
			<tr>
			<th>First Name </th>
			<th>Middle Name</th>
			<th>Last Name </th>
			<th> SSN </th>
			<th>SP17 Classes Report</th>
			</tr>
			</thead>
		<%
		statement = conn.createStatement();
		String sid = request.getParameter("sid");
		System.out.print(sid);
		rs = statement.executeQuery("Select id,first,middle,last,ssn from students where id = " +sid);
		if(rs.next()){
			String middle = null;
			if( rs.getString("middle") != null )
				middle = rs.getString("middle");
			else
				middle = "None";
		%>
		<tbody>
		<form action="Report2A.jsp" method="post">
		    <input type="hidden" value="report" name="action">
		    <input type="hidden" value="<%=rs.getInt("ssn")%>" name ="ssn">
			<td><%=rs.getString("first")%></td>
			<td><%=middle%></td>
			<td><%=rs.getString("last")%></td>
			<td><%=rs.getInt("ssn")%></td>
		    <td> <input type="submit" value="Select Student"></td>
		</form>
		</tbody>
		</table>
		</table>
	  <%}
} 
if(request.getParameter("action")!= null && request.getParameter("action").equals("report")){
	System.out.println(request.getParameter("action"));
	int ssn = Integer.parseInt(request.getParameter("ssn"));
	//Get all currently enrolled sections and times for specified student
	String sql = 
			"SELECT c.class_id, c.course_name, sec.sec_id, m.type, m.day_time FROM students s, enrollment e, sections sec, meetings m, classes c " +
				"WHERE s.id=e.s_id AND e.sec=sec.id AND m.sec_id=sec.id AND sec.class_id=c.class_id " +
				"AND c.quarter='SP' AND c.year=2017 AND s.SSN=?";
	ps = conn.prepareStatement(sql,ResultSet.TYPE_SCROLL_INSENSITIVE,
		    ResultSet.CONCUR_READ_ONLY);
	ps.setInt(1,ssn);
	rs = ps.executeQuery();
	//Get all current sections student is not enrolled in
	String sql2 = "SELECT c.class_id, sec.sec_id, m.type, m.day_time, c.title, c.course_name " +
					"FROM classes c, sections sec, meetings m " + 
		    	  	"WHERE c.class_id = sec.class_id AND m.sec_id = sec.id AND " + 
		          	"c.quarter = 'SP' AND c.year = 2017 AND c.course_name NOT IN " +
		          	"(SELECT c.course_name FROM students s, enrollment e, sections sec, meetings m, classes c " +
		          	"WHERE s.id = e.s_id AND e.sec = sec.id AND m.sec_id = sec.id AND sec.class_id = c.class_id " +
		          	"AND c.quarter = 'SP' AND c.year = 2017 AND s.SSN = ?) ORDER BY c.class_id";
	ps2 = conn.prepareStatement(sql2,ResultSet.TYPE_SCROLL_INSENSITIVE,
		    ResultSet.CONCUR_READ_ONLY);
	ps2.setInt(1,ssn);
	rs2 = ps2.executeQuery();
	%>
	<h3>Classes Student Cannot Take Due to Overlap of Section Times</h3>
	<table border="1" style="color:blue">
	<tr>
	<td>Class Title</td>
	<td>Course Name</td>
	</tr>
	<%
	String[] curr = null;
	int currClass = 0;
	int lastClass = 0;
	boolean last_cant = false;
	boolean this_cant = false;
	String a="",b="",c="";
	int i,j;
	while(rs2.next()){
		currClass = rs2.getInt("class_id");
		System.out.println("CURRCLASS IS: " + currClass);
		if(currClass!=lastClass && last_cant==true){
			System.out.println("ADDING TO TABLE");
			%>
			<tr>
			<td><%=a%></td>
			<td><%=b%></td> 
			<!--  <td><%=c%></td> -->
			</tr>
			<%
		}
		if(currClass==lastClass && !last_cant){
			this_cant=false;
		}
		else{
		curr = rs2.getString("day_time").split("\\s+");
			while(rs.next()){
				for(i=0;i<curr.length-1;i++){ //Iterate over the day portion of each day_time
					if(rs.getString("day_time").contains(curr[i]) 
							&& rs.getString("day_time").contains(curr[curr.length-1])){ //curr[i] has day
						//curr[curr.length-1] has time
						//A conflict, same time and day is found	
						System.out.println("FOUND");
						this_cant = true;
					}
				}
			}
		}
		rs.beforeFirst();
		a=rs2.getString("title");
		b=rs2.getString("course_name");
		//c=rs2.getString("sec_id");
		if(this_cant)
			last_cant=true;
		else
			last_cant=false;
		this_cant=false;
		lastClass=currClass;
	}
	if(last_cant==true){
		%>
		<tr>
		<td><%=a%></td>
		<td><%=b%></td> 
		<td><%=c%></td>
		</tr>
		<%
	}
	%>	
	</table>
<%}  
} 
catch (SQLException e){
	System.out.println(e.getSQLState());
}
finally{

}%>
</body>
</html>