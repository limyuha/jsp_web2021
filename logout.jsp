<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	session.invalidate(); // 세션초기화
%>
	<script>
		alert('로그아웃 되었습니다.');
		location.href = 'main.jsp';
	</script>