<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	if((Integer)session.getAttribute("seq") == null){
		out.print("비회원");
		return;
	}
	int schedule_seq = Integer.parseInt(request.getParameter("schedule_seq"));
	int member_seq = (Integer)session.getAttribute("seq");
	
	String sql = "select schedule_seq, member_seq from schedule_like where schedule_seq = ? and member_seq = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, schedule_seq);
	pstmt.setInt(2, member_seq);
	rs = pstmt.executeQuery();

	if(!rs.isBeforeFirst()) {
		sql = "insert into schedule_like (schedule_seq, member_seq) values(?, ?)";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, schedule_seq);
		pstmt.setInt(2, member_seq);
		pstmt.executeUpdate();
		out.print("좋아요");
		return;
	} else {
		sql = "delete from schedule_like where schedule_seq = ? and member_seq = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, schedule_seq);
		pstmt.setInt(2, member_seq);
		pstmt.executeUpdate();
		out.print("좋아요취소");
	}
	
	//pstmt.close(); conn.close();
%>