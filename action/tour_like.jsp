<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	if((Integer)session.getAttribute("seq") == null){
		out.print("비회원");
		return;
	}
	int tour_seq = Integer.parseInt(request.getParameter("tour_seq"));
	int member_seq = (Integer)session.getAttribute("seq");
	
	String sql = "select tour_seq, member_seq from tour_like where tour_seq = ? and member_seq = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, tour_seq);
	pstmt.setInt(2, member_seq);
	rs = pstmt.executeQuery();

	if(!rs.isBeforeFirst()) {
		sql = "insert into tour_like (tour_seq, member_seq) values(?, ?)";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, tour_seq);
		pstmt.setInt(2, member_seq);
		pstmt.executeUpdate();
		out.print("좋아요");
		return;
	} else {
		sql = "delete from tour_like where tour_seq = ? and member_seq = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, tour_seq);
		pstmt.setInt(2, member_seq);
		pstmt.executeUpdate();
		out.print("좋아요취소");
	}
	
	//pstmt.close(); conn.close();
%>