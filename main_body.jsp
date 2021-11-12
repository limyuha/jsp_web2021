<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	String sql = "select * FROM tour ORDER BY place_hit desc LIMIT 3";
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
	int i = 1;
	
	/* sql = "SELECT thumbnail FROM tour order BY RAND() LIMIT 5"; */
	sql = "SELECT thumbnail FROM banner";
	pstmt = conn.prepareStatement(sql);
	ResultSet rs2 = pstmt.executeQuery();
	
%>
<div class="width_1200 main_body">
	<ul class="top5_slide">
		<%while(rs2.next()) {%>
			<li>
				<img src="<%=rs2.getString("thumbnail")%>"/>
			</li>
		<% } %>
	</ul>
	
	<button type="button" class="banner-prev" id="banner-prev"><i class="fas fa-chevron-left"></i></button>
	<button type="button" class="banner-next" id="banner-next"><i class="fas fa-chevron-right"></i></button>
		
	<script type="text/javascript" src="//code.jquery.com/jquery-1.11.0.min.js"></script>
	<script type="text/javascript" src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
	<script type="text/javascript" src="slick/slick.min.js"></script>
		
	<script>
	$('.top5_slide').slick({
		  slidesToShow: 1, //한 화면에 보여질 컨텐츠 개수
		  slidesToScroll: 1, //스크롤 한번에 움직일 컨텐츠 개수
		  autoplay: true,
		  autoplaySpeed: 2000,
		  //dots : true, 		//스크롤바 아래 점
		  //dotsClass : "slick-dots", 	//아래 나오는 페이지네이션(점) css class 지정
		  arrows: true,  //옆으로 이동하는 화살표 표시 여부
		  prevArrow : $('#banner-prev'),	// 이전 화살표 모양 설정
		  nextArrow : $('#banner-next'),	// 다음 화살표 모양 설정
		  draggable : true, 	//드래그 가능 여부
		  useCSS : true
		});
	</script>

	<p class="title">조회수가 높은 추천 명소 TOP3!</p>
	
	<ul class="place_box">
		<%while(rs.next()) {%>
			<li>
				<a href="main.jsp?target=tour_page&tour_seq=<%=rs.getInt("seq")%>">
					<div class="img_box">
						<img src="<%=rs.getString("thumbnail")%>">
					</div>
					<div class="content_box">
						<p class="name_title"><i class="fas fa-crown"></i> 0<%=i %> <%=rs.getString("place_name") %></p>
						<p class="content"><%=rs.getString("simple_content") %></p>
					</div>
				</a>
			</li>
		<% i++; }%>
	</ul>
</div>
<% pstmt.close(); conn.close(); %>