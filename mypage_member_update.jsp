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
<form action="action/member_update.jsp" method="post">
	<input type="hidden" name="member_seq" value="<%=member_seq%>">
	<table class="tb">
		<tr>
			<td>이름</td>
			<td><input type="text" name="name" placeholder="새 이름 입력"></td>
		</tr>
		<tr>
			<td>전화번호</td>
			<td><input type="text" name="tel" placeholder="새 전화번호 입력"></td>		
		</tr>
		<tr>
			<td>이메일</td>
			<td><input type="text" name="email" placeholder="새 이메일 입력"></td>
		</tr>
	</table>
	<button type="submit" class="mypage_update_btn">수정하기</button>
</form>
<% pstmt.close(); conn.close(); %>