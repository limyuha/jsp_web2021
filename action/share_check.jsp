<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	//String on_off = request.getParameter("on_off");
	//int on_off = Integer.parseInt(request.getParameter("on_off"));
	//out.println(on_off);
	//return;
	
	//String[] on = request.getParameterValues("on");
	//String on = request.getParameter("on");
	//String[] off = request.getParameterValues("off");
	
	//String schedule_seq = request.getParameter("schedule_seq");
	int schedule_seq = Integer.parseInt(request.getParameter("schedule_seq"));
	//out.println(schedule_seq);
	//out.println(on_off);
	//out.println(on);
	//out.println(off);
	
	/*
	out.println(schedule_seq);
	for(int i=0; i < on.length; i ++){
	out.println(on[i]);
	}
	
	for(int i=0; i < off.length; i ++){
	out.println(off[i]);
	}
	*/
	
	
	String sql = "select seq, on_off from schedule where seq = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, schedule_seq);
	rs = pstmt.executeQuery();
	//rs.next();
	//String check = "성공";
	
	if(rs.next()) {
		int up_field = (rs.getInt("on_off") == 1) ? 0 : 1; //삼항 연산자
		/*
		if(rs.getInt("on_off") == 1) {
			 sql = "update schedule set on_off = 0 where seq = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, schedule_seq);
			pstmt.executeUpdate();
			out.print("0");
			return;
		} else if(rs.getInt("on_off") == 0) {
			
		} 
		*/
		
		sql = "update schedule set on_off = "+up_field+" where seq = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, schedule_seq);
		pstmt.executeUpdate();
		out.print(up_field); 
		//return;
	} 
	
	pstmt.close(); conn.close();
%>