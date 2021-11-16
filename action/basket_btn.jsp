<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	int member_seq = (Integer)session.getAttribute("seq"); 
	int tour_seq =  Integer.parseInt(request.getParameter("tour_seq"));
	Timestamp date = new Timestamp(System.currentTimeMillis());
	
	String sql = "select * from cart where member_seq =? and tour_seq =?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, member_seq);
	pstmt.setInt(2, tour_seq);
	rs = pstmt.executeQuery();
	
	if(rs.next()) {
		sql = "delete from cart where member_seq = ? and tour_seq = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, member_seq);
		pstmt.setInt(2, tour_seq);
		pstmt.executeUpdate();
		out.print("0");
    } else { 

	sql = "insert into cart(member_seq, tour_seq, date) values(?, ?, ?)";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, member_seq);
		pstmt.setInt(2, tour_seq);
		pstmt.setTimestamp(3, date);
		pstmt.executeUpdate();
		out.print("1");
	}
	
	pstmt.close();
	conn.close();

%>
