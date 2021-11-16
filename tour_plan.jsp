<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="sql_open.jsp" %>
<%	
	int member_seq = (Integer)session.getAttribute("seq");  // 세션 값 가져오기 
	//out.println(id);
	String place_name = "";

	String sql = "select * from tour, cart where tour.seq = cart.tour_seq and cart.member_seq = ?";	
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, member_seq);
	rs = pstmt.executeQuery();
%>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script>
  $( function() {
    $( ".column" ).sortable({
      connectWith: ".column",
      handle: ".portlet-header",
      //cancel: ".portlet-toggle",
      //placeholder: "portlet-placeholder ui-corner-all"
      
	   /* 드래그 멈췄을 때 값, 순서 부여*/
      stop:function(event, ui) {	    	 
    	  //초기화
    	  $('.column li span.ord').remove(); //삭제, ord클래스명을 가진 span태그에게만 적용
    	  $('.column li').removeClass('on'); //on클래스명을 가지면 삭제
    	  $('#map .fas').removeClass('darkgreenMarker'); //darkgreenMarker클래스 삭제, 스케줄박스에서 벗어나면 삭제
    	  
    	  $('#map .fas span.orm').remove();
    	  $('#map .fas').removeClass('fa-map-marker');
    	  $('#map .fas').addClass('fa-map-marker-alt');
    	  
    	  //추가
    	  $('.plan_box li').each(function() { //each = 반복문
    		  $(this).append("<span class='ord'>"+($(this).index()+1)+"</span>");
    	  	  $(this).addClass('on');	//on클래스명을 가지면 추가
    	  	
    		$('#map .fas[data-seq="'+$(this).attr('data-seq')+'"]').removeClass('fa-map-marker-alt'); //마커 변경
    		$('#map .fas[data-seq="'+$(this).attr('data-seq')+'"]').addClass('fa-map-marker'); //마커 변경
    		$('#map .fas[data-seq="'+$(this).attr('data-seq')+'"]').addClass('darkgreenMarker');
    	  	$('#map .fas[data-seq="'+$(this).attr('data-seq')+'"]').append("<span class='orm'>"+($(this).index()+1)+"</span>"); //번호
    	  	
    	  });    	   
      }

    });
      
      $( ".portlet" )
      .addClass( "ui-widget ui-widget-content ui-helper-clearfix ui-corner-all" )
      .find( ".portlet-header" )
        .addClass( "ui-widget-header ui-corner-all" )
        .prepend( "<span class='ui-icon ui-icon-minusthick portlet-toggle'></span>");
    });
	  
	var x = new Array();
	var y = new Array();
	var tour_seq = new Array();
	var place_name = new Array();
	 </script>

	<div class="width_1400 tour_plan">
		<div class="basket_schedule_save_box">
			<div class="text_box">
				<p>장바구니에 있는 관광지를 드래그해서 오른쪽으로 옮겨보세요</p>
				<i class="fas fa-cart-arrow-down tour_plan_cart_icon"></i>
			</div>
			
			<div class="basket_schedule_box">
				<% if(!rs.isBeforeFirst()) { %>
			<div style=" width:498px; height:500px; float:left; line-height:500px; text-align:center;">장바구니가 비었어요</div>
			<% } else { %>
				<ul class="basket_box column">
					<% while(rs.next()) { %>
						<li class ="portlet line tour_box" data-seq="<%=rs.getInt("tour.seq")%>">
						
							<div class="portlet-header">
								<div class="thumbnail_box">
									<img src="<%=rs.getString("tour.thumbnail")%>"/>
								</div>
								
								<div class="tour_detail_box">
									<p><spen>관광지 이름 :</spen><%=rs.getString("tour.place_name")%></p>
									<p class="adress">주소 : <%=rs.getString("tour.tour_url")%></p>
								</div>
								
								<div class="delete_box">
										<button type="button" onclick="location.href='action/tour_plan_cart_delete.jsp?&tour_seq=<%=rs.getInt("cart.tour_seq")%>' ">
											<i class="fas fa-times" ></i>
										</button>
								</div>
								<input type="hidden" name="cart_no" value="<%=rs.getInt("cart.tour_seq")%>"/>
								<script>
								x.push("<%=rs.getDouble("tour.place_x")%>"); //x 값 푸시
								y.push("<%=rs.getDouble("tour.place_y")%>"); //y 값 푸시
								tour_seq.push("<%=rs.getInt("tour.seq")%>"); // 관광지 번호
								place_name.push("<%=rs.getString("tour.place_name")%>"); // 관광지 이름
								</script>
							</div>
						</li>
					<% } %>
				</ul>
			<% } %>
				<form id="planForm"><!-- method="post" action="Action/Tour_plan_Save.jsp"-->
						<ul class="plan_box column">
							<!--<li class ="portlet"><div class="portlet-header">관광지11</div></li>
							<li class ="portlet"><div class="portlet-header">관광지22</div></li>
							<li class ="portlet"><div class="portlet-header">관광지33</div></li>-->
						</ul>
				</form>
			</div>
			
			<form class="check_box" id="infoForm">
				<div class="plan_mini_box">
					<p><spen class="bold">* 스케줄 이름 :</spen>
						<input type="text" placeholder=" 예시 ) 서울 데이트 코스" name="schedule_name" class="plan_input_box"/></p>
						<spen class="bold">* 저장한 스케줄 장바구니에서 삭제하기 </spen><input type="checkbox" name="check" value="delete"/>
							<!--<input type="button" id="save" value="저장하기"/>-->
							<button type="button" class="save_btn" id="save">저장하기</button>	
				</div>
			</form>
		</div>
		
		<div class="tour_plan_map" id='map' style="width:500px; height:800px;"></div> <!-- 지도 -->
	</div>
		
<% pstmt.close(); conn.close(); %>
<script>
	var markers = []; //마커들 담을 배열
	var container = document.getElementById('map'); //지도를 표시할 div
	var mapOptions = {
		    center: new naver.maps.LatLng(x[0], y[0]),
		    zoom: 12
		};
	var map = new naver.maps.Map('map', mapOptions); //맵생성

	 for(i = 0; i <= x.length; i++){
		 var marker = new naver.maps.Marker({
			    position: new naver.maps.LatLng(x[i], y[i]),			   
			    map: map,
			    icon: {
			    	content: '<div class="marker_div"><i class="fas fa-map-marker-alt" data-seq="'+tour_seq[i]+'"></i><spen class="spanPlaceName">'+place_name[i]+'<spen></div>',
			    	size: new naver.maps.Size(22,36),
			    	origin: new naver.maps.Point(0,0),
			    	anchor: new naver.maps.Point(11,35)
			    },
			    //draggable: true
			});

		 markers.push(marker);
	}
	 
		$('#save').click(function(){ //button 클릭시 이벤트 발생
			$.ajax({
				url:'action/tour_plan_save.jsp', //데이터 보낼 url
				type:'post', //form 태그의 method 속성(post 또는 get)
				data: $('#planForm').serialize()+'&'+$('#infoForm').serialize(), //폼 두개
				success: function(e) { //제일 마지막 문장
					if($.trim(e) == '스케줄순서'){ //공백 있어서 trim으로 공백 삭제
						alert("스케줄 순서를 정해주세요.");
						//location.reload();
					} else if($.trim(e) == '스케줄이름'){
						alert("스케줄 이름이 입력되지 않으셨습니다.");
						//location.reload(); //history.back();
					} else if ($.trim(e) == 'y'){
						alert("성공적으로 스케줄을 짰습니다!\n저장한 스케줄은 '스케줄 리스트'에서 확인가능합니다.");
						location.reload(); //새로고침
					}
					console.log(e);
				},
				error: function(e) {
					console.log(e);
				}
			});
		});
		
		$(".portlet").mouseover(function(){ //li 요소들
			$('#map .fas[data-seq="'+$(this).attr('data-seq')+'"]').addClass('on'); //id=map을 가진 요소 안에 마커 아이콘의 tour_seq값이 각각의 li요소 tour_seq값과 같을 때, on클래스 추가
		}).mouseout(function(){
			$('#map .fas[data-seq="'+$(this).attr('data-seq')+'"]').removeClass('on');
		});
</script>
