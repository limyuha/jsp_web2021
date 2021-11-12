<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file = "sql_open.jsp" %>
<%
	String id = (String)session.getAttribute("id"); 
	if (id == null) {  %>
	<script>
	//cfm = confirm("이 서비스는 회원전용으로 제공됩니다.\n로그인 하시겠습니까?");
	if(confirm("이 서비스는 회원전용으로 제공됩니다.\n로그인 하시겠습니까?")) {
		location.href="main.jsp?target=j_rogin";
	} else {
		history.back();
	}
	</script>
	<% return; } 

	int member_seq = (Integer)session.getAttribute("seq"); 
	int tour_seq =  Integer.parseInt(request.getParameter("tour_seq"));
	Timestamp date = new Timestamp(System.currentTimeMillis());
	
	String sql = "select * from cart where member_seq =? and tour_seq =?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, member_seq);
	pstmt.setInt(2, tour_seq);
	rs = pstmt.executeQuery();
	
	if(rs.next()) { %>
		<script>
			alert("이미 장바구니에 담겨있습니다.");
			history.back();
		</script>
<%  } else { 

	sql = "insert into cart(member_seq, tour_seq, date) values(?, ?, ?)";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, member_seq);
	pstmt.setInt(2, tour_seq);
	pstmt.setTimestamp(3, date);
	pstmt.executeUpdate();
	
	pstmt.close();
	conn.close();
%>
	<script>
		alert("장바구니에 넣었습니다.");
		//location.href="Main.jsp?target=Tour_plan";
		//location.href="main.jsp?target=tour_list";
		location.href="main.jsp?target=tour_page&tour_seq=<%=tour_seq%>";		
	</script>
<% } %>
