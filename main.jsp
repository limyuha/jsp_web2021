<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String target = request.getParameter("target");
	//String tp = "TourList";
	if (target == null) {
		target = "main_body";
	}
	String targetpage = target + ".jsp";
	
	java.util.Date today = new java.util.Date(); //현재 날짜(변하는 값) //css수정 시 빠르게 보려고
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<!-- 초기화 css -->
	<link rel="stylesheet" href="css/reset.css" />
	
	<!-- 모든 css -->
	<link rel="stylesheet" href="css/all.css?v=<%=today%>" />
	
	<!-- 아이콘 css -->
	<script src="https://kit.fontawesome.com/a076d05399.js"></script>
	
	<!-- 카카오 지도 -->
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=6375ed17a9c86d1c61f9cc019d14d54b"></script>

	<!-- 슬라이드 -->
	<link rel="stylesheet" type="text/css" href="slick/slick.css"/>
	<!-- <link rel="stylesheet" type="text/css" href="slick/slick-theme.css"/> -->
	
	<!-- 폰트 -->
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100;300;400;500;700;900&display=swap" rel=sytlesheet">

	<!-- 네이버 지도 -->
	<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=fgesmtv3s1&submodules=geocoder"></script>
	
	<!-- 자바스크립트 이벤트 사용시 필요한 소스 -->
	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<title>Insert title here</title>
<style> 
	body{background:#FFFAFA;} /* 눈색 */
</style>
</head>
<body>
	<jsp:include page="menu2.jsp" flush="false"/>

	<jsp:include page="<%=targetpage%>" flush="false"/>
</body>
</html>