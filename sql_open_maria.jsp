<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("UTF-8"); // 한글 처리
	Connection conn = null;
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	
	//String jdbcDriver = "jdbc:mariadb://localhost:3306/bookstore";
	//Class.forName("com.mysql.jdbc.Driver"); //mysql 드라이버 로딩
	String jdbcUrl = "jdbc:mariadb://localhost:3307/bookstore";
	String dbId = "root";
	String dbPass = "jsppass";
	
	request.setCharacterEncoding("utf-8"); // 한글 처리
	conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
	
	//String sql = "select * from review";	
	//pstmt = conn.prepareStatement(sql);
	//rs = pstmt.executeQuery();
	
//	if (rs.next()) {
//	place_name = rs.getString("place_name");
//	}
%>