<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1 style="color:blue">Classes Taken Entry Form</h1>
<table border="1">
<tr>
  Please Enter the Information Below
</tr>
<tr>
  <td>Student Id</td>
  <td>Class Id</td>
  <td>Section Id</td>
  <td>Term</td>
  <td>Units</td>
  <td>Grade</td>
</tr>
<tr>
<form action="classes-taken.jsp">
  <td>
  <input name="s_id" placeholder="Enter Student Id" size="15"/>
  </td>
  <td>
  <input name="class_id" placeholder="Enter Class Id" size="15"/>
  </td>
  <td>
  <input name="sec_id" placeholder="Enter Section Id" size="15"/>
  </td>
  <td>
  <input name="term" placeholder="Enter Term" size="15"/>
  </td>
  <td>
  <input name="units" placeholder="Enter Units" size="15"/>
  </td>
  <td>
  <input name="grade" placeholder="Enter Grade" size="15"/>
  </td>
  </form>
</tr>
</table>
</body>
</html>