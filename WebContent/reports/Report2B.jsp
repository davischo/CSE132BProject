<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Review Session Planner</title>
</head>
<body>
<%@page import="java.util.*, java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%
Connection conn = null;
Statement statement = null;
PreparedStatement ps = null;
ResultSet rs = null;
try{
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost/postgres?" +
                    "user=postgres&password=postgres");
	String action = request.getParameter("action");
	statement = conn.createStatement();
	rs = statement.executeQuery("SELECT sec.sec_id, c.course_name FROM sections sec, classes c " +
			"WHERE sec.class_id=c.class_id AND c.quarter='SP' AND c.year=2017 ORDER BY sec.sec_id"); 
	%>
	<form action="Report2B.jsp" method="post">
	<input type="hidden" value="pick" name="action">
	<select id="sec_id" required ="required" name="sec_id">
	<% 
	while(rs.next()){
	%>
	    <option value="<%=rs.getString("sec_id")%>"><%=rs.getString("course_name")%> Section <%=rs.getString("sec_id")%></option>
	<% 
	}
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
			<th>SID</th>
			<th>Course</th>
			<th>Start Date</th>
			<th>End Date</th>
			</tr>
			</thead>
		<%
		ps = conn.prepareStatement("SELECT sec.sec_id, c.course_name FROM sections sec, classes c " +
				"WHERE sec.class_id=c.class_id AND c.quarter='SP' AND c.year=2017 AND sec.sec_id=?");
		String sec_id = request.getParameter("sec_id");
		System.out.println(sec_id);
		ps.setString(1,sec_id);
		rs = ps.executeQuery();
		while(rs.next()){
		%>
		<tr>
		<form action="Report2B.jsp" method="post">
		    <input type="hidden" value="report" name="action">
		    <input type="hidden" name="sec_id" value="<%=request.getParameter("sec_id") %>">
			<td><%=rs.getString("sec_id")%></td>
			<td><%=rs.getString("course_name")%></td>
			<td><input name="start" value="" placeholder="S/M/T/W/Th/F/Sa">
			<td><input name="end" value="" placeholder="S/M/T/W/Th/F/Sa">
		    <td><input type="submit" value="Select Section"></td>
		</form>
		</tr>
		</table>
		</table>
	 <%	}
	}
	if (request.getParameter("action")!= null && request.getParameter("action").equals("report")){
		System.out.println(request.getParameter("action"));
		if( request.getParameter("start")!= null && request.getParameter("end")!= null ){
			String sql = "WITH enrolled AS (" +
					  "SELECT s.SSN FROM students s, enrollment e, sections sec, classes c " +
					  "WHERE s.id=e.s_id AND e.sec=sec.id AND sec.class_id=c.class_id AND c.quarter='SP' AND c.year=2017 AND sec.sec_id=?) " +
					  "SELECT m.day_time FROM students s, enrollment e, sections sec, meetings m, classes c, enrolled " +
					  "WHERE s.id=e.s_id AND e.sec=sec.id AND m.sec_id=sec.id AND sec.class_id=c.class_id AND c.quarter='SP' AND c.year=2017 AND s.SSN=enrolled.SSN;";
			ps = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ps.setString(1,(String)request.getParameter("sec_id"));
			rs = ps.executeQuery();
			String currDay = request.getParameter("start");
			int i,j;
			String time;
			String curr;
			boolean show = true;
			%>
			<h3>Available Times(1hr)</h3>
			<table>
			<tr>
			<td>
			<table border="1" style="color:blue">
			<tr>
			<td>Day
			(Symbol)</td>
			<td>Time
			(00:00)</td>
			</tr>
			<%
			while(true){
				for(i=1;i<13;i++){
					if(i<10)
						time = "0" + i + "00";
					else
						time = i + "00";
					//System.out.println("TIME IS: " + time);
					while(rs.next()){
						curr = rs.getString("day_time");
							if(curr.contains(currDay + " ") 
									&& curr.contains(time)){ //curr[j] has day
								//curr[curr.length-1] has time
								//A conflict, same time and day is found	
								System.out.println("CONFLICT at:" + time);
								show=false;
							}
					}
					if(show){
					%>
					<tr>
					<td><%=currDay%></td>
					<td><%=time%></td>
					</tr>
					<%
					}
					show=true;
					rs.beforeFirst();
				}
				if(currDay.equals(request.getParameter("end"))){
					break;
				}
				//Set next day
				if(currDay.equals("S")){
					currDay="M";
				}
				else if(currDay.equals("M")){
					currDay="T";
				}
				else if(currDay.equals("T")){
					currDay="W";
				}
				else if(currDay.equals("W")){
					currDay="Th";
				}
				else if(currDay.equals("Th")){
					currDay="F";
				}
				else if(currDay.equals("F")){
					currDay="Sa";
				}
				else if(currDay.equals("Sa")){
					currDay="S";
				}
				else
					break;
			}
			%>
			</table>
			</td>
			<td>Legend:
			<table border="1">
			<tr><td>Day:</td><td>Symbol:</td></tr>
			<tr><td>Sunday</td><td>S</td></tr>
			<tr><td>Monday</td><td>M</td></tr>
			<tr><td>Tuesday</td><td>T</td></tr>
			<tr><td>Wednesday</td><td>W</td></tr>
			<tr><td>Thursday</td><td>Th</td></tr>
			<tr><td>Friday</td><td>F</td></tr>
			<tr><td>Saturday</td><td>Sa</td></tr>
			</table></td></table>
			<%	
		}
	}
} 
catch (SQLException e){
	System.out.println(e.getSQLState());
}
finally{

}%>
</body>
</html>