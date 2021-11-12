<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="sql_open.jsp" %>
<%	
	int member_seq = (Integer)session.getAttribute("seq"); //getParameter는 항상 String 형태로 반환하기 때문에 형변환 필요
	int schedule_seq = 0; //shedule seq 초기화/기본값
	Timestamp date = new Timestamp(System.currentTimeMillis());
	String schedule_name = request.getParameter("schedule_name");
	
	String[] cart_no = request.getParameterValues("cart_no");
	
	if(cart_no == null) { 
		out.print("스케줄순서"); 
		return;
	}
	
	if(schedule_name == null || schedule_name == "") { 
		out.print("스케줄이름"); 
		return;
	}
	
	/* schedule 테이블에 삽입 */
	String sql = "insert into schedule (member_seq, schedule_name, plan_date, plan_hit, on_off) values(?, ?, ?, ?, ?)";
	pstmt = conn.prepareStatement(sql);
	//pstmt.setInt(1, seq);
	pstmt.setInt(1, member_seq); // Tour_plan 에서 받아온 회원 번호
	pstmt.setString(2, schedule_name);
	pstmt.setTimestamp(3, date);
	pstmt.setInt(4, 0);
	pstmt.setInt(5, 0);
	
	pstmt.executeUpdate();
	 
	/* schedule 테이블에 삽입된 seq값 받아옴 */
	sql = "select last_insert_id()"; //첫번째 AUTO_INCREMENT column의 값을 반환
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
	if(rs.next()) { schedule_seq = rs.getInt("last_insert_id()"); }
	
	//String[] cart_no = request.getParameterValues("cart_no");
	
	/* schedule_detail 테이블에 삽입 */ 
	for(int i = 0; i < cart_no.length; i++) {	
		sql = "insert into schedule_detail (schedule_seq, tour_seq, sort) values( ?, ?, ?)";
		pstmt = conn.prepareStatement(sql);
		//pstmt.setInt(1, seq);
		pstmt.setInt(1, schedule_seq);
		pstmt.setString(2, cart_no[i]); //tour_seq
		pstmt.setInt(3, i+1); //sort
		
		pstmt.executeUpdate();
	}
	
	String check = request.getParameter("check");
	
	if(check != null){ //check.equals("delete")
		for(int i = 0; i < cart_no.length; i++){
			sql = "delete from cart where member_seq = ? and tour_seq = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, member_seq);
			pstmt.setString(2, cart_no[i]);
			pstmt.executeUpdate();
		}
	} 
	
	pstmt.close();
	conn.close();
	out.print("y"); //ajax에 넘길 값
%>

