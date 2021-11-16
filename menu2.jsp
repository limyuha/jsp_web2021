<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
	String id = (String)session.getAttribute("id");  // 세션 값 가져오기 
%>
	<div class="menu2_box"> <!-- 부모 -->
		<a href="main.jsp" class="title">
			<!-- <img src = "test_images/sk.jpg" style="width:80px; height:80px;">hotPlace -->
			<img src = "test_images/logo.png" style="width:150px; height:80px;">
		</a>
		
		<!-- 메뉴 -->
		<ul>
			<% if (id == null) { %>
			<li><a href="main.jsp?target=tour_list">명소</a></li>
            <li><a href="main.jsp?target=schedule_share_board">스케줄</a></li>
            <li><a href="main.jsp?target=tour_support">여행 지원</a></li>
            <li class="user"><a href="main.jsp?target=j_rogin"><i class="far fa-user"> LOG IN</i></a></li>
            <% } else { %>
            <spen class="user_sp"> <%= id %> 님 | <a href="logout.jsp">LOG OUT</a></spen>
            <li><a href="main.jsp?target=tour_list">명소</a></li>
            <li><a href="main.jsp?target=schedule_share_board">스케줄</a></li>
            <li><a href="main.jsp?target=tour_plan">장바구니</a></li>
            <li><a href="main.jsp?target=mypage">마이페이지</a></li>
            <li><a href="main.jsp?target=tour_support">여행 지원</a></li>
            <!-- 
             <li class="dropdown"><spen>마이페이지</spen>
            	<div class="dropdown-content">
            		<a href="main.jsp?target=schedule_list">스케줄 리스트</a>
            		<a href="main.jsp?target=mypage">내 정보</a>
            	</div>
            </li>
             -->
            <% } %>
        </ul>
	</div>