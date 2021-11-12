<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	//int member_seq = (Integer)session.getAttribute("seq");

	String sql = "SELECT seq FROM schedule WHERE member_seq = ?"; //스케줄 테이블에서 회원이 짠 스케줄 seq 검색
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, 1);
	rs = pstmt.executeQuery();

	ArrayList<Integer> schedule_seq_list = new ArrayList<>();
	int seq = 0;

	while(rs.next()) {
		seq = rs.getInt("seq");
		schedule_seq_list.add(seq);
	}

	/*
	for(int i = 0; i < schedule_seq_list.size(); i++){ //size = 리스트에 들어있는 원소 수
		int schedule_seq = schedule_seq_list.get(i);
		sql = "select schedule_seq from schedule_detail where schedule_seq = ?"; //스케줄 상세 테이블에서 회원이 짠 스케줄 seq로 데이터 검색
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, schedule_seq);
		ResultSet rs2 = pstmt.executeQuery();
		
		while(rs.next()){
			
			sql = "delete from schedule_detail where schedule_seq = ?"; //검색한 데이터를 스케줄 상세 테이블에서 삭제
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, schedule_seq);
			pstmt.executeUpdate();
			
		}
	}
	*/

	for(int i = 0; i < schedule_seq_list.size(); i++){
		int schedule_seq = schedule_seq_list.get(i);
		out.print(schedule_seq+"<br>");
	}
	pstmt.close(); conn.close();
%>

