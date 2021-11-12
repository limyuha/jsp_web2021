<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	int member_seq = (Integer)session.getAttribute("seq"); 
	int tour_seq =  Integer.parseInt(request.getParameter("tour_seq"));

	String sql = "delete from tour_like where tour_seq = ? and member_seq = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, tour_seq);
	pstmt.setInt(2, member_seq);
	pstmt.executeUpdate();
%>
	<script>
	alert("좋아요를 취소했습니다.");
	location.href="/jsp_web2021/main.jsp?target=mypage&target2=mypage_like_tour_list";
	</script>