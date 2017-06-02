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
	

	rs = statement.executeQuery("Select s.id as sid, first,middle,last from students s where s.level = 'MS'");
	r = s.executeQuery("select id, name from degrees where type = 'M.S'");
%>
<p>Pick a Student And a Degree to Get Report </p>

<form action="Report1E.jsp" method="post">
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

<% 
if (action != null && action.equals("pick") ){

int sid = Integer.parseInt(request.getParameter("sid"));
int did = Integer.parseInt(request.getParameter("degree"));
rss = statement.executeQuery("Select id,first,middle,last,ssn from students where id = " +sid);
rrs = s.executeQuery("Select name,type from degrees where id = " + did );
if(rss.next() && rrs.next()){
%>
</br>
<form action="Report1E.jsp" method="post">
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
	int did = Integer.parseInt(request.getParameter("did"));
	System.out.print(did);

	String sql =
			"Select D.name as name, D.require as require, D.grad, D.minGPA " +
			" FROM (WITH coursesTaken AS " +
			" (Select A.course_name, B.units, B.grade " +
			" From (select cs.course_name, class_id " +
			 "      from courses cs join classes c on cs.course_name = c.course_name) AS A join " +
			 "	   (Select s.id as sid,class_id, units,grade  " +
			 "      from enrollment e join students s on e.s_id = s.id and s.level ='MS'  " +
			  "     and grade != 'IN PROGRESS' and s.id = " + sid + ") AS B on A.class_id = B.class_id) "  +
			" Select con.name as name,ctc.con, ctc.course as require, ct.course_name, ct.units, g.NUMBER_GRADE as grad, con.minGPA as minGPA, con.units " +
			" From con_to_course ctc left outer join coursesTaken ct on ct.course_name = ctc.course " +
			 " left outer join grade_conversion g" +
			" on g.letter_grade = ct.grade, concentration con" +
			" where con.id = ctc.con ) AS D order by D.con" ;
	
	String sql1 =  "WITH coursesTaken AS " +
			"(Select A.course_name, B.units, B.grade " +
					"From (select cs.course_name, class_id " +
					       "from courses cs join classes c on cs.course_name = c.course_name) AS A join " +
					 	   "(Select s.id as sid,class_id, units,grade  " +
					       "from enrollment e join students s on e.s_id = s.id and s.level ='MS' " +
					       "and grade != 'IN PROGRESS' and s.id = " +sid+ ") AS B on A.class_id = B.class_id) " +
					"Select ctc.con, ctc.course as require, ct.course_name, ct.units, g.NUMBER_GRADE as grad "+
					"From con_to_course ctc left outer join coursesTaken ct on ct.course_name = ctc.course " +
					 "left outer join grade_conversion g " +
					"on g.letter_grade = ct.grade, concentration con " +
					"where con.id = ctc.con and con.id = ? ";
	
	Statement stt = conn.createStatement();
	ResultSet set = stt.executeQuery("select id, name,units,minGPA from concentration where did = " + did);
	String conName = null;
	Map<String,Double> concentrationGPA = new HashMap<String,Double>();
	ArrayList<String> unfinishedConcentration  = new ArrayList<String>();
	ArrayList<String> finishedConcentration  = new ArrayList<String>();
	ArrayList<String> concentration  = new ArrayList<String>();

	while(set.next()){
		int conid = set.getInt("id");
		System.out.print("In side of set.next()" + conid);
		conName = set.getString("name");
		ps = conn.prepareStatement(sql1);
		ps.setInt(1,conid);

		ResultSet rec = ps.executeQuery();
		int totalUnits  = set.getInt("units");
		int minGPA = set.getInt("minGPA");
		double gpa = 0.0;
		int sunit = 0;
		double sungpa = 0.0;
		concentration.add(conName);
		int count = 0;
		while(rec.next()){
			System.out.println("In side of rec " + conName);
			if(rec.getString("course_name") == null){
				if(!unfinishedConcentration.contains(conName) && !finishedConcentration.contains(conName)){
					System.out.println("In side of rec ADDING TO unfinished " + conName);
					unfinishedConcentration.add(conName);
				}
	
		    }
			
			else {
				gpa = Double.parseDouble(rec.getString("grad"));
				sungpa = sungpa + gpa;
				count ++;
				sunit = sunit + rec.getInt("units");
			}
		}
		
		if(sunit >= totalUnits && (sungpa/count) >= minGPA && !finishedConcentration.contains(conName)){
			System.out.println("In side of ADDING FINISHING CONCENTRATION " + conName);
			finishedConcentration.add(conName);
		}
		
		if ((sunit < totalUnits) && !unfinishedConcentration.contains(conName)&& !finishedConcentration.contains(conName)){
				unfinishedConcentration.add(conName);
		}

		if(((sungpa/count) < minGPA) &&!unfinishedConcentration.contains(conName) && !finishedConcentration.contains(conName)){
				unfinishedConcentration.add(conName);		
	    } 
		

		concentrationGPA.put(conName,(double)(sungpa/count));
		System.out.println(conName);
		
	} 
		
	for(String hi:concentration){
		if(finishedConcentration.contains(hi) && unfinishedConcentration.contains(hi)){
			System.out.println("In side of REMOVING FROM unfinished " + conName);
			int i = unfinishedConcentration.indexOf(hi);
			unfinishedConcentration.remove(i);
		}
	} 
	%>
	<h2> Unfinished Concentration : </h2>
	<%for(String hi:unfinishedConcentration){ %>
		<p><%=hi %></p>
		<%}%>
	
	<h2>Finished Concentration : </h2>
	<% if(finishedConcentration.isEmpty()){%>
	<p>The student has not finished any of the concentration of this major yet</p>
	<%}
	else {
		for(String hi:finishedConcentration){ %>
		<p><%=hi %></p>
	<%
		}}%>
	
	<h2>All Concentration with List of Courses</h2>
	<%
	Statement dead = conn.createStatement();
	ResultSet rip 	= dead.executeQuery(sql);
	ResultSet p =null;

	
	String sql2 = null; %>
	<table border="1" cellspacing="5">
	<tr>
	<th>Concentration</th>
	<th>Classes Not Yet Taken</th>
	<th>Earliest Quarter Offered</th>
	</tr>
	<%while(rip.next()){
		String concen = rip.getString("name");
		System.out.println(concen);
		String requir = rip.getString("require");
		double avgGrade = concentrationGPA.get(concen);
		double minGPA = rip.getInt("minGPA");
		if(avgGrade < minGPA || rip.getInt("grad") == 0 ) {
			sql2 = "select quarter, year from classes where ( (year>2017) or (year = 2017 and quarter = 'FA') ) " +
					" and course_name = ? order by year, quarter LIMIT 1";
			pps = conn.prepareStatement(sql2);
			pps.setString(1, requir);
			p = pps.executeQuery();
			if(p.next()){
			%>
					<tr>
					<td><%=concen%></td>
					<td><%=requir%></td>
					<td><%=p.getString("quarter") + " " + p.getInt("year")%></td>
					</tr>
				
			<%}
		}
	}%>
	</table>
	<%
	p.close();
	rip.close();
	dead.close();
}
}//catch(Exception e) {e.printStackTrace();}
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