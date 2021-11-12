<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	int member_seq =  Integer.parseInt(request.getParameter("member_seq"));
	String name = request.getParameter("name");
	String tel = request.getParameter("tel");
	String email = request.getParameter("email");

	String sql = "select name, tel, email from member where seq = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, member_seq);
	rs = pstmt.executeQuery();
	rs.next();

	if(name == null || name == "") {
		name = rs.getString("name");
	} 
	
	if(tel == null || tel == "") {
		tel = rs.getString("tel");
	} 
	
	if(email == null || email == "") {
		email = rs.getString("email");
	}
	
	sql = "update member set name = ?, tel = ?, email = ? where seq = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, name);
	pstmt.setString(2, tel);
	pstmt.setString(3, email);
	pstmt.setInt(4, member_seq);
	pstmt.executeUpdate();
%>
<% pstmt.close(); conn.close(); %>
<script>
	alert("작성한 정보가 수정됐습니다.");
	location.href="/jsp_web2021/main.jsp?target=mypage";
</script>