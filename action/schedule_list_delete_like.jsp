<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	int member_seq = (Integer)session.getAttribute("seq"); 
	int schedule_seq =  Integer.parseInt(request.getParameter("schedule_seq"));

	String sql = "delete from schedule_like where schedule_seq = ? and member_seq = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, schedule_seq);
	pstmt.setInt(2, member_seq);
	pstmt.executeUpdate();
%>
	<script>
	alert("삭제했습니다.");
	location.href="/jsp_web2021/main.jsp?target=mypage&target2=mypage_like_schedule_list";
	</script>