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
	rs = statement.executeQuery("SELECT id, course_name FROM courses"); 
	statement = conn.createStatement();
	rs2 = statement.executeQuery("SELECT id, fac_name FROM faculty");
	String q;
	%>
	<form action="Report3.jsp" method="post">
	<input type="hidden" value="pick" name="action">
	<select id="c_id" name="c_id">
	<option value="">Course</option>
	<% 
	while(rs.next()){
	%>
	    <option value="<%=rs.getString("course_name")%>"><%=rs.getString("id")%> <%=rs.getString("course_name")%></option>
	<% 
	}
	%>
	</select>
	<select id="fac" name="fac_name">
	<option value="">Faculty</option>
	<%
	while(rs2.next()){
	%>
	    <option value="<%=rs2.getString("fac_name")%>"><%=rs2.getString("fac_name")%></option>
	<% 
	}
	%>
	</select>
	<select id="quarter" name="quarter">
	  <option value="">Quarter</option>
	  <option value="SP">SP</option>
	  <option value="FA">FA</option>
	  <option value="WI">WI</option>
	</select>
	<input type="text" name="year" placeholder="Year" value=""/>
	<input type="submit" value="Submit">
	</form>
	<% //Course faculty and quarter
	if (request.getParameter("action")!= null && request.getParameter("action").equals("pick")){
		if(request.getParameter("c_id")!="" && request.getParameter("fac_name")!="" 
				&& request.getParameter("quarter")!="" && request.getParameter("year")!=""){
			q = 
					"SELECT count(*) AS sum FROM enrollment e, sections sec, classes c " +
					"WHERE e.class_id=c.class_id AND sec.class_id=c.class_id AND e.grade LIKE 'A%' " +
					"AND c.course_name='" + request.getParameter("c_id") + "' " +
					"AND sec.taught_by='"+request.getParameter("fac_name")+"' AND c.year=" + 
					request.getParameter("year") + " AND c.quarter='" + request.getParameter("quarter") +"'";
			statement=conn.createStatement();
			ResultSet ar = statement.executeQuery(q);
			int a = 0;
			if(ar.next()){
				a=ar.getInt("sum");
			}
			q = 
					"SELECT count(*) AS sum FROM enrollment e, sections sec, classes c " +
					"WHERE e.class_id=c.class_id AND sec.class_id=c.class_id AND e.grade LIKE 'B%' " +
					"AND c.course_name='" + request.getParameter("c_id") + "' " +
					"AND sec.taught_by='"+request.getParameter("fac_name")+"' AND c.year=" + 
					request.getParameter("year") + " AND c.quarter='" + request.getParameter("quarter") +"'";
			statement=conn.createStatement();
			ResultSet br = statement.executeQuery(q);
			int b = 0;
			if(br.next()){
				b=br.getInt("sum");
			}
			q = 
					"SELECT count(*) AS sum FROM enrollment e, sections sec, classes c " +
					"WHERE e.class_id=c.class_id AND sec.class_id=c.class_id AND e.grade LIKE 'C%' " +
					"AND c.course_name='" + request.getParameter("c_id") + "' " +
					"AND sec.taught_by='"+request.getParameter("fac_name")+"' AND c.year=" + 
					request.getParameter("year") + " AND c.quarter='" + request.getParameter("quarter") +"'";
			statement=conn.createStatement();
			ResultSet cr = statement.executeQuery(q);
			int c = 0;
			if(cr.next()){
				c=cr.getInt("sum");
			}
			q = 
					"SELECT count(*) AS sum FROM enrollment e, sections sec, classes c " +
					"WHERE e.class_id=c.class_id AND sec.class_id=c.class_id AND e.grade LIKE 'D%' " +
					"AND c.course_name='" + request.getParameter("c_id") + "' " +
					"AND sec.taught_by='"+request.getParameter("fac_name")+"' AND c.year=" + 
					request.getParameter("year") + " AND c.quarter='" + request.getParameter("quarter") +"'";
			statement=conn.createStatement();
			ResultSet dr = statement.executeQuery(q);
			int d = 0;
			if(dr.next()){
				d=dr.getInt("sum");
			}
			q = 
					"SELECT count(*) AS sum FROM enrollment e, sections sec, classes c " +
					"WHERE e.class_id=c.class_id AND sec.class_id=c.class_id AND e.grade LIKE 'F%' " +
					"AND c.course_name='" + request.getParameter("c_id") + "' " +
					"AND sec.taught_by='"+request.getParameter("fac_name")+"' AND c.year=" + 
					request.getParameter("year") + " AND c.quarter='" + request.getParameter("quarter") +"'";
			statement=conn.createStatement();
			ResultSet fr = statement.executeQuery(q);
			int f = 0;
			if(fr.next()){
				f=fr.getInt("sum");
			}
			%>
			
			<h3>Grade Count</h3>
			<table border="1">
			<tr>
			<td>A</td>
			<td>B</td>
			<td>C</td>
			<td>D</td>
			<td>Other</td>
			</tr>
			<tr>
			<td><%=a %></td>
			<td><%=b %></td>
			<td><%=c %></td>
			<td><%=d %></td>
			<td><%=f %></td>
			</tr>
			</table>
			<%
		} //course and faculty
		else if(request.getParameter("c_id")!="" && request.getParameter("fac_name")!=""){
			q = "select sec.taught_by, c.course_name, avg(gc.NUMBER_GRADE) AS GPA from students s, enrollment e, classes c, GRADE_CONVERSION gc, sections sec " +
					"WHERE e.s_id=s.id AND c.class_id=e.class_id AND e.grade=gc.LETTER_GRADE AND c.course_name='" + request.getParameter("c_id") + "' " +
				      "AND sec.taught_by='" + request.getParameter("fac_name") +"' AND sec.class_id=c.class_id GROUP BY taught_by, course_name";
			statement = conn.createStatement();
			rs = statement.executeQuery(q);
			double average = 0;
			if(rs.next()){
				average = rs.getDouble("GPA");
			}
			%>
			<h3>The Average GPA for this Professor and Course is: <%=average%></h3>
			<%
			q = 
					"SELECT count(*) AS sum FROM enrollment e, sections sec, classes c " +
					"WHERE e.class_id=c.class_id AND sec.class_id=c.class_id AND e.grade LIKE 'A%' " +
					"AND c.course_name='" + request.getParameter("c_id") + "' " +
					"AND sec.taught_by='"+request.getParameter("fac_name")+"'";
			statement=conn.createStatement();
			ResultSet ar = statement.executeQuery(q);
			int a = 0;
			if(ar.next()){
				a=ar.getInt("sum");
			}
			q = 
					"SELECT count(*) AS sum FROM enrollment e, sections sec, classes c " +
					"WHERE e.class_id=c.class_id AND sec.class_id=c.class_id AND e.grade LIKE 'B%' " +
					"AND c.course_name='" + request.getParameter("c_id") + "' " +
					"AND sec.taught_by='"+request.getParameter("fac_name")+"'";
			statement=conn.createStatement();
			ResultSet br = statement.executeQuery(q);
			int b = 0;
			if(br.next()){
				b=br.getInt("sum");
			}
			q = 
					"SELECT count(*) AS sum FROM enrollment e, sections sec, classes c " +
					"WHERE e.class_id=c.class_id AND sec.class_id=c.class_id AND e.grade LIKE 'C%' " +
					"AND c.course_name='" + request.getParameter("c_id") + "' " +
					"AND sec.taught_by='"+request.getParameter("fac_name")+"'";
			statement=conn.createStatement();
			ResultSet cr = statement.executeQuery(q);
			int c = 0;
			if(cr.next()){
				c=cr.getInt("sum");
			}
			q = 
					"SELECT count(*) AS sum FROM enrollment e, sections sec, classes c " +
					"WHERE e.class_id=c.class_id AND sec.class_id=c.class_id AND e.grade LIKE 'D%' " +
					"AND c.course_name='" + request.getParameter("c_id") + "' " +
					"AND sec.taught_by='"+request.getParameter("fac_name")+"'";
			statement=conn.createStatement();
			ResultSet dr = statement.executeQuery(q);
			int d = 0;
			if(dr.next()){
				d=dr.getInt("sum");
			}
			q = 
					"SELECT count(*) AS sum FROM enrollment e, sections sec, classes c " +
					"WHERE e.class_id=c.class_id AND sec.class_id=c.class_id AND e.grade LIKE 'F%' " +
					"AND c.course_name='" + request.getParameter("c_id") + "' " +
					"AND sec.taught_by='"+request.getParameter("fac_name")+"'";
			statement=conn.createStatement();
			ResultSet fr = statement.executeQuery(q);
			int f = 0;
			if(fr.next()){
				f=fr.getInt("sum");
			}
			%>
			
			<h3>Grade Count</h3>
			<table border="1">
			<tr>
			<td>A</td>
			<td>B</td>
			<td>C</td>
			<td>D</td>
			<td>Other</td>
			</tr>
			<tr>
			<td><%=a %></td>
			<td><%=b %></td>
			<td><%=c %></td>
			<td><%=d %></td>
			<td><%=f %></td>
			</tr>
			</table>
			<%
			
		} //JUST COURSE
		else if(request.getParameter("c_id")!=""){
			q = 
					"SELECT count(*) AS sum FROM enrollment e, sections sec, classes c " +
					"WHERE e.class_id=c.class_id AND sec.class_id=c.class_id AND e.grade LIKE 'A%' " +
					"AND c.course_name='" + request.getParameter("c_id") + "'";
			statement=conn.createStatement();
			ResultSet ar = statement.executeQuery(q);
			int a = 0;
			if(ar.next()){
				a=ar.getInt("sum");
			}
			q = 
					"SELECT count(*) AS sum FROM enrollment e, sections sec, classes c " +
					"WHERE e.class_id=c.class_id AND sec.class_id=c.class_id AND e.grade LIKE 'B%' " +
					"AND c.course_name='" + request.getParameter("c_id") + "'";
			statement=conn.createStatement();
			ResultSet br = statement.executeQuery(q);
			int b = 0;
			if(br.next()){
				b=br.getInt("sum");
			}
			q = 
					"SELECT count(*) AS sum FROM enrollment e, sections sec, classes c " +
					"WHERE e.class_id=c.class_id AND sec.class_id=c.class_id AND e.grade LIKE 'C%' " +
					"AND c.course_name='" + request.getParameter("c_id") + "'";
			statement=conn.createStatement();
			ResultSet cr = statement.executeQuery(q);
			int c = 0;
			if(cr.next()){
				c=cr.getInt("sum");
			}
			q = 
					"SELECT count(*) AS sum FROM enrollment e, sections sec, classes c " +
					"WHERE e.class_id=c.class_id AND sec.class_id=c.class_id AND e.grade LIKE 'D%' " +
					"AND c.course_name='" + request.getParameter("c_id") + "'";
			statement=conn.createStatement();
			ResultSet dr = statement.executeQuery(q);
			int d = 0;
			if(dr.next()){
				d=dr.getInt("sum");
			}
			q = 
					"SELECT count(*) AS sum FROM enrollment e, sections sec, classes c " +
					"WHERE e.class_id=c.class_id AND sec.class_id=c.class_id AND e.grade LIKE 'F%' " +
					"AND c.course_name='" + request.getParameter("c_id") + "'";
			statement=conn.createStatement();
			ResultSet fr = statement.executeQuery(q);
			int f = 0;
			if(fr.next()){
				f=fr.getInt("sum");
			}
			%>
			
			<h3>Grade Count</h3>
			<table border="1">
			<tr>
			<td>A</td>
			<td>B</td>
			<td>C</td>
			<td>D</td>
			<td>Other</td>
			</tr>
			<tr>
			<td><%=a %></td>
			<td><%=b %></td>
			<td><%=c %></td>
			<td><%=d %></td>
			<td><%=f %></td>
			</tr>
			</table>
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