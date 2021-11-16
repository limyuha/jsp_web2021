<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="sql_open.jsp"%>
<%	
	int tour_seq =  Integer.parseInt(request.getParameter("tour_seq"));
	
	String sql = "select img_url from tour_img where tour_list_seq = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, tour_seq);
	rs = pstmt.executeQuery();
	
	ResultSet rs2 = null;
	sql = "select place_name, simple_content, tour_url, place_x, place_y, place_hit, us_time, park, pet, card from tour where seq = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, tour_seq);
	rs2= pstmt.executeQuery();
	rs2.next();
	double x = rs2.getDouble("place_x");
	double y = rs2.getDouble("place_y");
	
	//조회수 세션
	int place_hit = rs2.getInt("place_hit"); //조회수
	String cntName = "count" + tour_seq; //관광지 seq
	
	if(session.getAttribute(cntName) == null) //세션에 cntName 없으면 실행
	{
		
		place_hit++;
		session.setAttribute(cntName, place_hit); //세션에 cntName 저장
		sql = "update tour set place_hit = ? WHERE seq = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, place_hit);
		pstmt.setInt(2, tour_seq);
		pstmt.executeUpdate();
	}
%>
<div class="width_1300 tour_page">
	<div>
		<ul class="tour_slide">
			<% while(rs.next()){ %>
				<li>
					<img src="<%=rs.getString("tour_img.img_url")%>" /> 
				</li>
			<% } %>
			
		</ul>
		<button type="button" class="slick-prev" id="slick-prev">
			<i class="fas fa-chevron-left"></i>
		</button>
		<button type="button" class="slick-next" id="slick-next">
			<i class="fas fa-chevron-right"></i>
		</button>
		<script type="text/javascript"
			src="//code.jquery.com/jquery-1.11.0.min.js"></script>
		<script type="text/javascript"
			src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
		<script type="text/javascript" src="slick/slick.min.js"></script>

		<script>
	$('.tour_slide').slick({
		  slidesToShow: 1, //한 화면에 보여질 컨텐츠 개수
		  slidesToScroll: 1, //스크롤 한번에 움직일 컨텐츠 개수
		  dots : true, 		//스크롤바 아래 점
		  dotsClass : "slick-dots", 	//아래 나오는 페이지네이션(점) css class 지정
		  arrows: true,  //옆으로 이동하는 화살표 표시 여부
		  prevArrow : $('#slick-prev'),	// 이전 화살표 모양 설정
		  nextArrow : $('#slick-next'),	// 다음 화살표 모양 설정
		  draggable : true, 	//드래그 가능 여부
		  useCSS : true
		});
	</script>
		<div class="tour_page_box position_r">
			<p class="float_left tag_pd"><!-- 태그 아이콘 -->
				<i class="fas fa-tag  fa-rotate-90"></i><spen class="tag"> 연관태그 </spen>
			</p>
			<spen class="hit"><%=place_hit %>회 구경</spen>
			
			<p class="float_left bold keyword_pd">#전통 #관광지 #문화재</p>

			<p class="bold font_size25"><%=rs2.getString("place_name")%></p>

			<hr style="width: 80%;" />

			<table>
					<tr>
						<td class="bold">
							이용시간
						</td>
						<td>
							<%=rs2.getString("us_time")%>
						</td>
					</tr>
					<tr>
						<td class="bold">
							주차시설
						</td>
						<td>
							<%=rs2.getString("park")%>
						</td>
					</tr>
					<tr>
						<td class="bold">
							주차시설
						</td>
						<td>
							<%=rs2.getString("park")%>
						</td>
					</tr>
					<tr>
						<td class="bold" style="width:190px;">
							애완동물 동반 가능 여부
						</td>
						<td>
							<%=rs2.getString("pet")%>
						</td>
					</tr>
					<tr>
						<td class="bold">
							신용카드 가능 여부
						</td>
						<td>
							<%=rs2.getString("card")%>
						</td>
					</tr>
			</table>

			<button type="button" class="basket_button"
				onclick="location.href='main.jsp?target=action/tour_page_basket_button&tour_seq=<%=tour_seq%>' ">
				<spen class="float_right"> <% 	ResultSet rs3 = null;
							if((Integer)session.getAttribute("seq") != null) {
								int member_seq = (Integer)session.getAttribute("seq");
								sql = "select seq from cart where member_seq = ? and tour_seq = ?";
								pstmt = conn.prepareStatement(sql);
								pstmt.setInt(1, member_seq);
								pstmt.setInt(2, tour_seq);
								rs3 = pstmt.executeQuery();
						 			if(rs3.next()) { %> 
						 			<i class="fas fa-cart-arrow-down tour_page_cart_icon" style="color:#FF2424;"></i> 
						 			<% } else { %> 
						 			<i class="fas fa-cart-arrow-down tour_page_cart_icon"></i>
									<% } 
						   } else { %> <i class="fas fa-cart-arrow-down tour_page_cart_icon"></i>
				<% } %> </spen>
			</button>
		</div>
	</div>

	<div>
		<p style="font-size: 20px; font-weight: bold;">개요</p>
		<p class="tour_page_simple_text"><%=rs2.getString("simple_content")%></p>
	</div>

	<div>
		<hr>
		<p class="tour_url_text">
			<i class="fas fa-map-marked-alt"></i>
			<spen><%=rs2.getString("tour_url")%></spen>
		</p>
		<div class="tour_page_map" id="map"></div>
	</div>
</div>

<script>
	var container = document.getElementById('map'); //지도를 표시할 div
	var x = '<%=x%>';
	var y = '<%=y%>';

	var map = new naver.maps.Map('map', {
	    center: new naver.maps.LatLng(x, y),
	    zoom: 15
	});

	var marker = new naver.maps.Marker({
	    position: new naver.maps.LatLng(x, y),
	    map: map
	});

	/*
	var options = {
		center : new kakao.maps.LatLng(x, y), //지도의 중심 좌표
		level : 3
	//지도 확대 레벨
	};

	var map = new kakao.maps.Map(container, options); //지도 생성
	
	var marker = new naver.maps.Marker({
	    position: new naver.maps.LatLng(x, y),
	    map: map
	});
	*/
</script>
<% pstmt.close(); conn.close(); %>