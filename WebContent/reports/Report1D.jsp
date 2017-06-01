<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%Connection conn = null;
Statement statement = null;
Statement s = null;
ResultSet r  = null;
ResultSet rs = null;
ResultSet rrs = null;
ResultSet rss = null;

PreparedStatement pps = null;
PreparedStatement ps = null;

try{
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost/postgres?" +
                    "user=postgres&password=postgres");
	statement = conn.createStatement();
	s = conn.createStatement();
    String action = null;
    if(request.getParameter("action")!=null){
		 action = request.getParameter("action");
	}
	
//if(action == null){
	rs = statement.executeQuery("Select s.id as sid, first,middle,last from students s where s.level = 'Undergraduate'");
	r = s.executeQuery("select id, name from degrees where type <> 'M.S'");
%>
<p>Pick a Student And a Degree to Get Report </p>

<form action="Report1D.jsp" method="post">
<input type="hidden" value="pick" name="action">
<select id="sid" required ="required" name="sid">
<% 
while(rs.next()){
%>
    <option value="<%=rs.getInt("sid")%>"><%=rs.getString("first") + " " + rs.getString("last")%> </option>
<%}%>
</select>

<select required ="required" name="degree">
<% 
while(r.next()){
%>
    <option value="<%=r.getInt("id")%>"><%=r.getString("name")%></option>
<%}%>
</select>
<input type="submit" value="Submit">
</form>
<%//}
if (action != null && action.equals("pick") ){
%> 	
<%
int sid = Integer.parseInt(request.getParameter("sid"));
int did = Integer.parseInt(request.getParameter("degree"));
rss = statement.executeQuery("Select id,first,middle,last,ssn from students where id = " +sid);
rrs = s.executeQuery("Select name,type from degrees where id = " + did );
if(rss.next() && rrs.next()){
%>
</br>
<form action="Report1D.jsp" method="post">
<table cellspacing="5">
	<table border="1" cellspacing="5">
	<thead>
	<tr>
	<th>First Name </th>
	<th>Middle Name</th>
	<th>Last Name </th>
	<th> SSN </th>
	</tr>
	</thead>
    <tbody>
    <tr>
	<td><%=rss.getString("first")%></td>
	<td><%=rss.getString("middle")%></td>
	<td><%=rss.getString("last")%></td>
	<td><%=rss.getInt("ssn")%></td>
    </tr>
    </tbody>
    </table>
    <table border="1" cellspacing="5">
	<tr>
	<th>Degree Name </th>
	<th>Degree Type</th>
	</tr>
	<tr>
	<td><%=rrs.getString("name")%></td>
	<td><%=rrs.getString("type")%></td>
	</tr>
	</table>
	</br>
    <input type="hidden" value="report" name="action">
    <input type="hidden" value=<%=sid%> name ="sid">
    <input type="hidden" value=<%=did%> name="did">
    <input type="submit" value="Get Student Report with Required Units in Degree">
    </table>
</form>
<%}}

if(action != null && action.equals("report")){
	int sid = Integer.parseInt(request.getParameter("sid"));
	System.out.println(sid);
	int did = Integer.parseInt(request.getParameter("did"));
	String sql = "WITH coursesTaken AS " + 
			        "(Select course_name,e.units,A.department as dep " + 
				    "from (select cs.course_name, class_id, cs.department " +
					"From courses cs join classes c on cs.course_name = c.course_name) AS A, enrollment e " +
					"Where A.class_id = e.class_id and e.s_id = " + sid + " and (e.quarter != 'SP' and e.year != 2017)) " +
					"Select ctc.*, units,dep " +
					"From coursesTaken ct left outer join course_to_cat ctc on ct.course_name = ctc.course ";
	
	
	Statement st = conn.createStatement();
	Statement stt = conn.createStatement();
	ResultSet rS = st.executeQuery("Select totalu,lowerdiv, upperdiv,techelec from degrees where id = " + did);
	int total = 0 ,ld = 0 ,ud = 0,te = 0;
	if(rS.next()){
		total = rS.getInt("totalu");
		ld = rS.getInt("lowerdiv");
		ud = rS.getInt("upperdiv");
		te = rS.getInt("techelec");
	}
	
	stt = conn.createStatement();
	ResultSet rSS = stt.executeQuery(sql);
	
	int sT = 0;
	int sld = 0;
	int sud = 0;
	int ste = 0;
	while(rSS.next()){
		int unit = rSS.getInt("units");
		int cid = rSS.getInt("dep");
		if((boolean)rSS.getBoolean("isld")&& (cid==did)){
			sld = sld + unit;
			sT = sT + unit;
		}
		if((boolean)rSS.getBoolean("isud")&& (cid==did)){
			sud = sud + unit;
			sT = sT + unit;
		}
		if((boolean)rSS.getBoolean("isteche")&& (cid==did)){
			ste = ste + unit;
			sT = sT + unit;
		}
	}  
	sld = ld - sld;
	sud = ud - sud;
	ste = te -ste;
	int remain = total - sT;
%>
<p> Total Units Degree Requirement: <%=total%></p>
<table cellspacing="5">
	<table border="1" cellspacing="5">
	<thead>
	<tr>
	<th>Lower Division Requirement</th>
	<th>Upper Division Requirement</th>
	<th>Technical Electives Requirement</th>
	</tr>
	</thead>
	<tbody>
	<tr>
	<td><%=ld%></td>
	<td><%=ud%></td>
	<td><%=te%></td>
	</tr>
	</tbody>
</table>
</table>
</br>
<p> Total Remaining Units Required For Selected Student: <%=remain%></p>
<p>These remaining units are categorized as following: </p>
<table cellspacing="5">
	<table border="1" cellspacing="5">
	<thead>
	<tr>
	<th>Lower Division Requirement</th>
	<th>Upper Division Requirement</th>
	<th>Technical Electives Requirement</th>
	</tr>
	</thead>
	<tbody>
	<tr>
	<td><%=sld%></td>
	<td><%=sud%></td>
	<td><%=ste%></td>
	</tr>
	</tbody>
</table>
</table>
<%}}
catch(Exception e) {e.printStackTrace();}
finally{	
	if (r!=null){ r.close();}
	if(rs != null) {rs.close();}
	if(rrs != null) {rrs.close();}
	if(rss !=null) {rss.close();}
	if(s!=null) {s.close();}
	if(ps!=null) {ps.close();}
	if(pps!=null) {pps.close();}
	if(conn!= null) {conn.close();}}%>
</body>
</html>