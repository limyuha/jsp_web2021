<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="sql_open.jsp" %>
<%
	String id = request.getParameter("id");
	String password = request.getParameter("password");
	String cpassword = request.getParameter("cpassword");
	String email = request.getParameter("email");
	Timestamp date = new Timestamp(System.currentTimeMillis());
	
	if(id == null || id == ""){ %>
	<script>
		alert("아이디가 입력되지 않으셨습니다.");
		history.back();
	</script>
	<%	return;} %>
	
	<% if(password == null || password == ""){ %>
		<script>
		alert("비밀번호가 입력되지 않으셨습니다.");
			history.back();
		</script>
	<%	return;} %>
	
	<% if(!password.equals(cpassword)){ %>
		<script>
		alert("비밀번호를 똑같이 입력해주세요.");
			history.back();
		</script>
	<%	return;} %>
	
	
	<% if(email == null || email == ""){ %>
		<script>
		alert("이메일이 입력되지 않으셨습니다.");
			history.back();
		</script>
	<%	return;} 
	
	String sql ="insert into member(id, password, email, date) values(?, ?, ?, ?)";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, id);
	pstmt.setString(2, password);
	pstmt.setString(3, email);
	pstmt.setTimestamp(4, date);
	pstmt.executeUpdate();
	
	pstmt.close();
	conn.close();
%>
<script>
	alert("회원가입에 성공했습니다.");
	location.href="/jsp_web2021/main.jsp?target=j_rogin";
</script>
