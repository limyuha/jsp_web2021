<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	int member_seq = (Integer)session.getAttribute("seq"); 
	int tour_seq =  Integer.parseInt(request.getParameter("tour_seq"));
	
	String sql = "delete from cart where member_seq = ? and tour_seq = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, member_seq);
	pstmt.setInt(2, tour_seq);
	pstmt.executeUpdate();
%>
	<script>
	alert("삭제했습니다.");
	location.href="/jsp_web2021/main.jsp?target=tour_plan";
	//response.sendRedirect("/yuha_jsp2021/Main.jsp?target=Tour_plan");
	</script>
<% pstmt.close(); conn.close(); %>