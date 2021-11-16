<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="sql_open.jsp" %>
<%
	String id = request.getParameter("id");
	String password = request.getParameter("passwd");
	int seq = 0;
			
	String sql = "select password, seq, id from member where id = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, id);
	rs = pstmt.executeQuery();
	
	if (rs.next()) {
		if (password.equals(rs.getString("password"))) {
			session.setAttribute("seq", rs.getInt("seq")); // 세션 seq에 회원의 seq값 저장
			session.setAttribute("id", rs.getString("id"));
			//out.println(session.getAttribute("seq"));
			response.sendRedirect("/jsp_web2021/main.jsp"); //로그인 성공시 페이지 이동
			
		} else {
			%>
			<script>
				alert('패스워드를 틀렸습니다.');
				history.back();
			</script>
			<%
		}
	} else {
		%>
		<script>
			alert('아이디가 없습니다.');
			history.back();
		</script>
		<%
	}
	
%>