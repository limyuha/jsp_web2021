<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String target2 = request.getParameter("target2");
	if (target2 == null) {
		target2 = "mypage_result";
	}
	
	String targetpage2 = target2 + ".jsp";
%>
<div class="width_1400 mypage_body">
	<div class="mypage_menu">
		<p><a href="main.jsp?target=mypage">내 정보</a></p><hr style="width:320px;">
		<ul>
			<li>
				<a href="main.jsp?target=mypage&target2=mypage_like_tour_list">좋아요 한 관광지 목록</a>
			</li>
			<li>
				<a href="main.jsp?target=mypage&target2=schedule_list">나의 스케줄 리스트</a>
			</li>
			<li>
				<a href="main.jsp?target=mypage&target2=mypage_like_schedule_list">좋아요 한 스케줄 리스트</a>
			</li>
			<li>
				<a href="main.jsp?target=mypage&target2=mypage_member_update">
					수정하기
				</a>
			</li>
			<li>
				<a href="main.jsp?target=mypage&target2=mypage_member_delete">
					회원탈퇴
				</a>
			</li>
			<li>
				<a href="logout.jsp">
					로그아웃
				</a>
			</li>
		</ul>
	</div>
	
	<div class="mypage_result">
		<jsp:include page="<%=targetpage2%>" flush="false"/>
	</div>
</div>