<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	int member_seq = (Integer)session.getAttribute("seq"); 
	int schedule_seq =  Integer.parseInt(request.getParameter("schedule_seq"));
	
	String sql = "delete from schedule where seq = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, schedule_seq);
	pstmt.executeUpdate();
	
	sql = "delete from schedule_like where schedule_seq = ?"; //좋아요 테이블에 있는 schedule 삭제
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, schedule_seq);
	pstmt.executeUpdate();
	
	sql = "select schedule_seq from schedule_detail where schedule_seq = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, schedule_seq);
	rs = pstmt.executeQuery();
	
	/* schedule_detail 테이블 데이터 삭제 */ 
	while(rs.next()){
		sql = "delete from schedule_detail where schedule_seq = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, schedule_seq);
		pstmt.executeUpdate();
	}
	
	
	
%>
	<script>
	alert("삭제했습니다.");
	location.href="/jsp_web2021/main.jsp?target=mypage&target2=schedule_list";
	</script>