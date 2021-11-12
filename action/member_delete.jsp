<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	int member_seq = (Integer)session.getAttribute("seq");
	String check = request.getParameter("check");
	
	if(check == null || check == "") { %>
		<script>
			alert("탈퇴하시려면 회원 탈퇴 안내에 동의해주세요!");
			history.back();
		</script>
<%	} else {
		String sql = "delete from member where seq = ?"; //회원 테이블에서 회원 삭제
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, member_seq);
		pstmt.executeUpdate();
		
		sql = "delete from cart where member_seq = ?"; //장바구니 테이블에서 회원이 작성한 것 삭제
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, member_seq);
		pstmt.executeUpdate();
		
		sql = "delete from review where member_seq = ?"; //리뷰 테이블에서 회원이 작성한 것 삭제
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, member_seq);
		pstmt.executeUpdate();
		
		sql = "delete from qna where member_seq = ?"; //qna 테이블에서 회원이 작성한 것 삭제
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, member_seq);
		pstmt.executeUpdate();
		
		sql = "delete from tour_like where member_seq = ?"; //관광지 좋아요 테이블에서 회원이 좋아요 한 것 삭제
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, member_seq);
		pstmt.executeUpdate();
		
		sql = "SELECT seq FROM schedule WHERE member_seq = ?"; //스케줄 테이블에서 회원이 짠 스케줄 seq 검색
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, member_seq);
		rs = pstmt.executeQuery();

		// 방법 2
	    ArrayList<Integer> schedule_seq_list = new ArrayList<>();
	    int seq = 0;
	      
	    while(rs.next()) {
	       seq = rs.getInt("seq"); //스케줄 번호
	       schedule_seq_list.add(seq); //rs 결과값 seq 구해서 리스트에 추가
	         
	       sql = "delete from schedule where seq = ?"; //스케줄 테이블에서 회원이 짠 스케줄 seq 삭제
	       pstmt = conn.prepareStatement(sql);
	       pstmt.setInt(1, seq);
	       pstmt.executeUpdate();
	       
	       sql = "delete from schedule_like where schedule_seq = ?"; //스케줄 좋아요 테이블에서 회원이 짠 스케줄 seq 삭제
	       pstmt = conn.prepareStatement(sql);
	       pstmt.setInt(1, seq);
	       pstmt.executeUpdate();
	    }
	      
	    for(int i = 0; i < schedule_seq_list.size(); i++){ //size = 리스트에 들어있는 원소 수
	       int schedule_seq = schedule_seq_list.get(i);
	       sql = "select schedule_seq from schedule_detail where schedule_seq = ?"; //스케줄 상세 테이블에서 회원이 짠 스케줄 seq로 데이터 검색
	       pstmt = conn.prepareStatement(sql);
	       pstmt.setInt(1, schedule_seq);
	       ResultSet rs2 = pstmt.executeQuery();
	       
	       while(rs2.next()){
	          sql = "delete from schedule_detail where schedule_seq = ?"; //검색한 데이터를 스케줄 상세 테이블에서 삭제
	          pstmt = conn.prepareStatement(sql);
	          pstmt.setInt(1, schedule_seq);
	          pstmt.executeUpdate();
	       }
	    }
		
		/* 방법 1
		while(rs.next()) {
			int seq = rs.getInt("seq");
			sql = "delete from schedule where seq = ?"; //스케줄 테이블에서 회원이 짠 스케줄 seq 삭제
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, seq);
			pstmt.executeUpdate();

			sql = "select schedule_seq from schedule_detail where schedule_seq = ?"; //스케줄 상세 테이블에서 회원이 짠 스케줄 seq로 데이터 검색
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, seq);
			ResultSet rs2 = pstmt.executeQuery();

			while(rs2.next()){
				sql = "delete from schedule_detail where schedule_seq = ?"; //검색한 데이터를 스케줄 상세 테이블에서 삭제
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, seq);
				pstmt.executeUpdate();
			}
		}
		*/

		session.invalidate(); // 세션초기화
%>
		<script>
			alert("회원이 탈퇴됐습니다.");
			location.href="/jsp_web2021/main.jsp";
		</script>
		pstmt.close(); conn.close();
<%	}  %>
