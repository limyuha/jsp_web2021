<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	int member_seq = (Integer)session.getAttribute("seq");
	String sql = "select * from member where seq = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, member_seq);
	rs = pstmt.executeQuery();
	rs.next();
%>
<p>가입 정보</p>
<table class="tb">
	<tr>
		<td>가입일</td>
		<td><%=rs.getDate("date")%></td>
	</tr>
	<tr>
		<td>ID</td>
		<td><%=rs.getString("id")%></td>
	</tr>
	<tr>
		<td>이름</td>
		<td><%=rs.getString("name")%></td>
	</tr>
	<tr>
		<td>전화번호</td>
		<td><%=rs.getString("tel")%></td>
	</tr>
	<tr>
		<td>생년월일</td>
		<td><%=rs.getInt("age")%>년생</td>
	</tr>
	<tr>
		<td>email</td>
		<td><%=rs.getString("email")%></td>
	</tr>
	<tr>
		<td>성별</td>
		<td><%=rs.getString("gender")%></td>
	</tr>
</table>
<% pstmt.close(); conn.close(); %>
	