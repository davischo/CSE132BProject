<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.sql.*"%>
<%@page import="java.sql.Connection"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Add A Section</title>
</head>
<body>
<%
String failure = (String) session.getAttribute("failure");
String success = (String) session.getAttribute("success");
if (success != null) {
%>
<p style="color:rosybrown;font-size:18px;"><bold><%=success%></bold></p>
<%
session.setAttribute("success", null);
}

if (failure != null) {
%>
    <p style="color:darkred"><%=failure%></p>
<%
    session.setAttribute("failure", null);
}

Connection conn = null;
Statement statement = null;
PreparedStatement ps = null;
Statement s = null;
ResultSet r  = null;
ResultSet rs = null;
String[] day = {"","M","T", "W", "Th", "F", "S", "Su"};
String[] days = {"","M W F","T Th","M W", "W F", "M","T","W","Th", "F", "M T W", "M T Th" , "M T F", "T W Th", "T W F", "T Th F", "W Th F", "M T","M Th", "T W", "T F", "W Th", "W F", "Th F"};
String[] time = {"", "0800","0900","1000","1100","1200","0100","0200","0300","0400","0500","0600","0700"};
String[] month ={"","Jan", "Feb", "March","Apr","May", "June", "July", "Aug", "Sep", "Oct", "Nov","Dec"};
String[] date = {"","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20",
		        "21","22","23","24","25","26","27","28","29","30","31"};

try{
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost/postgres?" +
                    "user=postgres&password=postgres");
	 
	String action = request.getParameter("action");
	statement = conn.createStatement();
	rs = statement.executeQuery("Select class_id, course_name, quarter, year from classes where (year = 2017 and quarter != 'WI' )" +
	" or (year > 2017) order by year ASC, quarter DESC");		
%>
<form action="add-sections-form.jsp" method="post">
<input type="hidden" value="pick" name="action">
<select id="cid" required ="required" name="cid">
<% 
while(rs.next()){
%>
    <option value="<%=rs.getInt("class_id")%>"> <%=rs.getString("course_name") + " " 
			+ rs.getString("quarter") + rs.getInt("year") %></option> 
<%}%>

</select>
<input type="submit" value="Add A Section To This Class">
</form>

<%if(action != null && action.equals("pick")){
	int courseid = Integer.parseInt(request.getParameter("cid"));
%> 	
<!-- Add an HTML table header row to format the results -->
<form action="add-sections-form.jsp" method="get">
<input type="hidden" value="insert" name="action">

<table border="1">
    <tr>
        <th>Section ID</th>
        <th>Enrollment Limit</th>
        <th>Lecture Time</th>
        <th>Discussion Time</th>
        <th>Lab Time</th>
        <th>Final Exam</th>
    </tr>
    <tr>
         <th><input value="" name="secid" required ="true"></th>
         <th><input value ="" name ="enlimit" required="true"></th>   
         <input type="hidden" name="cid"  value="<%=courseid%>">
         <th>
			<select name="lecDay">
			<% 
			for(int i = 0; i < days.length; i++){
			%>
			    <option value="<%=days[i]%>"><%=days[i]%></option> 
			<%}%>
			</select> <select name="lecTime">
			<% 
			for(int i = 0; i < time.length; i++){
			%>
			    <option value="<%=time[i]%>"><%=time[i]%></option> 
			<%}%>
			</select>
         </th>     
         
         <th>
			<select name="disDay">
			<% 
			for(int i = 0; i < days.length; i++){
			%>
			<option value="<%=days[i]%>"><%=days[i]%></option> 
			<%}%>
			</select> <select name="disTime">
			<% 
			for(int i = 0; i < time.length; i++){
			%>
			    <option value="<%=time[i]%>"><%=time[i]%></option> 
			<%}%>
			</select>
         </th>         
         <th>
			<select name="labDay">
			<% 
			for(int i = 0; i < days.length; i++){
			%>
			    <option value="<%=days[i]%>"><%=days[i]%></option> 
			<%}%>
			</select> <select name="labTime">
			<% 
			for(int i = 0; i < time.length; i++){
			%>
			    <option value="<%=time[i]%>"><%=time[i]%></option> 
			<%}%>
			</select>
           </th>  
            <th>
            <select name="finMonth">
			<option>March</option>
			</select>
			 <select name="finDate">
			<% 
			for(int i = 14; i < 19; i++){
			%>
			    <option value="<%=date[i]%>"><%=date[i]%></option> 
			<%}%>
			</select>
			<select name="finDay">
			<% 
			for(int i = 0; i < day.length; i++){
			%>
			    <option value="<%=day[i]%>"><%=day[i]%></option> 
			<%}%>
			</select> <select name="finTime">
			<% 
			for(int i = 0; i < time.length; i++){
			%>
			    <option value="<%=time[i]%>"><%=time[i]%></option> 
			<%}%>
			</select>
         </th>  
    </tr>
</table>

<p>Review Session:</p>
<table border="1">
<tr>
<th>Midterm Review </th>
</tr>
<tr>

<th>
<select name="rev1Month">
<% 
for(int i = 0; i < month.length; i++){
%>
<option value="<%=month[i]%>"><%=month[i]%></option> 
<%}%>
</select> <select name="rev1Date">
<% 
for(int i = 0; i < date.length; i++){
%>
<option value="<%=date[i]%>"><%=date[i]%></option> 
<%}%>
</select>
<select name="rev1Day">
<% 
for(int i = 0; i < day.length; i++){
%>
<option value="<%=day[i]%>"><%=day[i]%></option> 
<%}%>
</select> <select name="rev1Time">
<% 
for(int i = 0; i < time.length; i++){
%>
<option value="<%=time[i]%>"><%=time[i]%></option> 
<%}%>
</select>
</th>
</tr>
</table>

<table border="1">
<tr>
<th>Final Review</th>
</tr>
<tr>
<th>
<select name="rev2Month">
<% 
for(int i = 0; i < month.length; i++){
%>
<option value="<%=month[i]%>"><%=month[i]%></option> 
<%}%>
</select> <select name="rev2Date">
<% 
for(int i = 0; i < date.length; i++){
%>
<option value="<%=date[i]%>"><%=date[i]%></option> 
<%}%>
</select>
<select name="rev2Day">
<% 
for(int i = 0; i < day.length; i++){
%>
<option value="<%=day[i]%>"><%=day[i]%></option> 
<%}%>
</select> <select name="rev2Time">
<% 
for(int i = 0; i < time.length; i++){
%>
<option value="<%=time[i]%>"><%=time[i]%></option> 
<%}%>
</select>
</th>  
</tr>
</table>

<input type="submit" value="Add A Section">
</form>
<%}

if(action != null && action.equals("insert")){
	// Begin transaction
    conn.setAutoCommit(false);

    // Create the prepared statement and use it to
    // INSERT student values INTO the students table.
   String sql = "Insert into sections(sec_id,enr_limit,class_id,taught_by,lecture,discussion,lab,review1,review2,final) " +
    "values (?,?,?,?,?,?,?,?,?,?)";
    
    String lec = request.getParameter("lecDay") + " "+ request.getParameter("lecTime");
    String dis = request.getParameter("disDay") + " "+ request.getParameter("disTime");
    String lab = request.getParameter("labDay") + " "+ request.getParameter("labTime");
    String rev1 = request.getParameter("rev1Month") + request.getParameter("rev1Date") +" " +
    			  request.getParameter("rev1Day") + " "+ request.getParameter("rev1Time");
    String rev2 = request.getParameter("rev2Month") + request.getParameter("rev2Date") +" " +
			  request.getParameter("rev2Day") + " "+ request.getParameter("rev2Time");
    String fin = request.getParameter("finMonth") + request.getParameter("finDate") +" " +
			  request.getParameter("finDay") + " "+ request.getParameter("finTime");
    
    ps = conn.prepareStatement(sql);
    int secid = Integer.parseInt(request.getParameter("secid"));
    ps.setInt(1,secid);
    ps.setInt(2, Integer.parseInt(request.getParameter("enlimit")));
    ps.setInt(3, Integer.parseInt(request.getParameter("cid")));
    
    ResultSet set = s.executeQuery("Select taught_by as fac from sections where sec_id = " +secid);
    if(set.next()){
    	ps.setString(4,set.getString("fac"));
    }
    
    ps.setString(5,lec);
    ps.setString(6,dis);
    ps.setString(7,lab);
    ps.setString(8,rev1);
    ps.setString(9,rev2);
    ps.setString(10,fin);
    
    int row = ps.executeUpdate();
    if(row != 0){
        session.setAttribute("success", "You have successfully inserted a section");
        response.sendRedirect("add-sections-form.jsp");
    }
    
}
}
catch(Exception e){}
finally{
	if (r!=null){ r.close();}
	if(rs != null) {rs.close();}
	if(s!=null) {s.close();}
	if(conn!= null) {conn.close();}
}%>
</body>
</html>
