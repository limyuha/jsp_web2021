<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	int member_seq = (Integer)session.getAttribute("seq");
	int schedule_seq = 0;

	String sql = "select * from schedule where member_seq = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, member_seq);
	rs = pstmt.executeQuery();
%>
<p>스케줄 리스트 목록</p>
<div class="width_900 schedule_list">
	<% if(!rs.isBeforeFirst()) { //isBeforeFirst : 결과에 무언가 있는지 확인하고 커서 이동 X, rs.next() 사용하면 커서 이동하게 됨 %>
		<p>관광지를 장바구니에 담고 나만의 스케줄을 짜보세요!</p>
	<% } else { %>
		<button type="button" id="explain_btn">설명서 보기</button>
		<div class="explain_box">
			<p>공유 체크박스를 클릭하면 공유박스가 체크되고, 스케줄 게시판에 내가 제작한 스케줄이 올라갑니다.</p>
			<p>지도 아이콘(<i class="fas fa-map"></i>)을 클릭하면 지도에 마커가 생성된 아이콘(<i class="fas fa-map-marked-alt"></i>)으로 변경되고, 지도에 관광지들의 위치를 알 수 있는 마커(<i class="fas fa-map-marker-alt explainmarker"></i>)가 생성됩니다.</p>
			<p>다시 지도 아이콘(지도에 마커가 생성된 아이콘(<i class="fas fa-map-marked-alt"></i>))을 클릭하면 마커(<i class="fas fa-map-marker-alt explainmarker"></i>)가 삭제됩니다.</p>
			<p>( <i class="fas fa-exclamation"></i> ) 여러개의 스케줄에 관한 마커를 동시에 볼 수 있지만 지도에 마커가 생성된 아이콘(<i class="fas fa-map-marked-alt"></i>)을 클릭하면 모든 마커(<i class="fas fa-map-marker-alt explainmarker"></i>)가 삭제됩니다.</p>
			<p>휴지통 아이콘(<i class="fas fa-trash-alt"></i>)을 클릭하여 제작한 스케줄을 삭제할 수 있습니다.</p>
		</div>
	
		<ul class="list_box">
			<% while(rs.next()) { %>
				<li class="hover-map" data-seq="<%=rs.getInt("seq")%>">				
					<button type="button" class="share_btn" data-seq="<%=rs.getInt("seq")%>"> <!-- data-seq 데이터 넘기기 -->
					<% if(rs.getInt("on_off") == 1) { %>
					<i class="far fa-check-square"></i>
					<% } else if(rs.getInt("on_off") == 0) { %>
					<i class="far fa-square"></i>
					<% } %>
					 공유</button>
					
					<a href="main.jsp?target=schedule_detail&schedule_seq=<%=rs.getInt("seq")%>">
						<%=rs.getString("schedule_name")%>
					</a>
					
					<button type="button" class="map_bth" title="마커 보기" data-seq="<%=rs.getInt("seq")%>">  <!-- ajax로 넘기는데 필요한 seq -->
						<i class="fas fa-map" data-seq="<%=rs.getInt("seq")%>"></i> <!-- on아이콘에 넘기는데 필요한 seq -->
					</button>
					
					<button type="button" class="delete_btn" title="삭제하기" 
						onclick="location.href='action/schedule_list_delete.jsp?&schedule_seq=<%=rs.getInt("seq")%>' ">
						<i class="fas fa-trash-alt"></i>
					</button>
				</li>		
			<% } %>
		</ul>	
	
		<div class="schedule_list_map">
				<div id="map" style="width:619px;height:700px;"></div>
		</div>
	<% } %>
</div>
<script>

	//var markers = [] //마커들 담을 배열
	var container = document.getElementById('map'); //지도를 표시할 div
	var mapOptions = {
		    center: new naver.maps.LatLng(37.55134800394021, 126.98821586913124),
		    zoom: 10
		};
	var map = new naver.maps.Map('map', mapOptions); //맵생성
	
	/*
	 for(i = 0; i <= x.length; i++){
		 var marker = new naver.maps.Marker({
			    position: new naver.maps.LatLng(x[i], y[i]),
			    map: map,
			    icon: {
			    	content: '<i class="fas fa-map-marker-alt"></i>',
			    	//url: 'target.png', //<i class="fas fa-map-marker-alt"></i>
			    	size: new naver.maps.Size(22,36),
			    	origin: new naver.maps.Point(0,0),
			    	anchor: new naver.maps.Point(11,35)
			    },
			    draggable: true
			});
		    markers.push(marker);
	}
	*/
	
	$('#explain_btn').click(function(){
		$('.schedule_list .explain_box').toggleClass('on');
	});
		 
	$('.share_btn').click(function(){
		 //var schedule_seq = $("input[name=schedule_seq]").val(); //input 값 받기
		 
		var that = $(this); //ajax this 인식 못해서 변수에 넣고 사용
			$.ajax({
				url : 'action/share_check.jsp', //데이터 보낼 url
				type : 'post',
				data: 'schedule_seq='+$(this).attr('data-seq'),
				//async = true, //get 방식 비동기 처리
				//dataType : 'html',
				//data : {schedule_seq : schedule_seq, on_off : 1},
				success: function(check) { //제일 마지막 문장
					if($.trim(check) == '0') {
						that.find('.far').removeClass('fa-check-square').addClass('fa-square');
						console.log(that.html());
					} else if($.trim(check) == '1') {
						that.find('.far').removeClass('fa-square').addClass('fa-check-square');
						console.log(that.html());
					}
					//alert($.trim(check));
	 				//console.log(check);
				},
				error: function(check) {
					alert("실패");
					console.log(check);
				}
			});
		});
	
	//클릭 이벤트
	markers = [];
	 $('.map_bth').click(function(){
		var that = $(this);
		//var x = new Array();
		//var y = new Array();
		var x_y_place = new Array();
		var num = 1; //마커 안 숫자
		
		//toggleClass : 요소가 없으면 생성, 요소가 있으면 삭제
		 $('.map_bth .fas[data-seq="'+$(this).attr('data-seq')+'"]').toggleClass( 'on' ); //각각의 지도 아이콘으로 변경(마커 있는 지도)
			if($('.map_bth .fas[data-seq="'+$(this).attr('data-seq')+'"]').hasClass('on')) { // on클래스가 없으면 수행
				$('.map_bth .fas[data-seq="'+$(this).attr('data-seq')+'"]').removeClass('fa-map').addClass('fa-map-marked-alt'); // on 클래스 추가

				$.ajax({
					url : 'schedule_list_map.jsp', //데이터 보낼 url
					type : 'post',
					data: 'schedule_seq='+that.attr('data-seq'),
					success: function(check) { //제일 마지막 문장
						var tmp = $.trim(check);
						
						var x_y_place = tmp.split("&");
						
						for(var i = 0; i < x_y_place.length; i++){
							var x_y = x_y_place[i].split(",");
							var marker = new naver.maps.Marker({
								position: new naver.maps.LatLng(x_y[0], x_y[1]), // 0 = x좌표, 1 = y좌표		   
								map: map,
						  		icon: {
									content: '<i class="fas fa-map-marker schedule_list_marker"><spen class="schedule_detail_marker_num">'+num+'</spen></i><spen>'+x_y[2]+'</spen>',
								    size: new naver.maps.Size(22,36),
								    origin: new naver.maps.Point(0,0),
								    anchor: new naver.maps.Point(11,35)
								},
									draggable: true
								});

							 markers.push(marker);
							 num++;
						}
							
						/*
						lh = x_y_place_test.length - 1;
						
						for(var i = 0; i < lh; i+=2) {
							x.push(x_y[i]); 
						}
						
						for(var i = 1; i < lh; i+=2) { //y 홀수
							y.push(x_y[i]); 
						}
						
						
						for(i = 0; i < x_y_place.length; i++){
							var marker = new naver.maps.Marker({
								position: new naver.maps.LatLng(x_y_place[x], x_y_place[y]),			   
								map: map,
						  		icon: {
									content: '<i class="fas fa-map-marker-alt schedule_list_marker"></i>',
								    size: new naver.maps.Size(22,36),
								    origin: new naver.maps.Point(0,0),
								    anchor: new naver.maps.Point(11,35)
								},
									draggable: true
								});

							 markers.push(marker);
						}*/
					},
					error: function(check) {
						alert("실패" + check);
						console.log(check);
					}
				});
			} else { // on 없을 시 / 한번 더 클릭하면 => 모든 마커 삭제, 모든 지도 아이콘으로 변경(마커 없는 지도)
				/* $('.map_bth .fas[data-seq="'+$(this).attr('data-seq')+'"]').removeClass('fa-map-marked-alt').addClass('fa-map'); */
				$('.map_bth .fas').removeClass('fa-map-marked-alt').addClass('fa-map');
				for(i = 0; i < markers.length; i++){ //markers.length
					markers[i].setMap(null);
				}
			}
	});
	
	 /* mouseover이벤트 구현
	 markers = [];
	 	//console.log(lh);
		$(".hover-map").mouseover(function(){ //li 요소들
			var that = $(this);
			var x = new Array();
			var y = new Array();
			
			$.ajax({
				url : 'schedule_list_map.jsp', //데이터 보낼 url
				type : 'post',
				data: 'schedule_seq='+that.attr('data-seq'),
				success: function(check) { //제일 마지막 문장
					var x_y = $.trim(check);

					x_y = x_y.split("&");
					lh = x_y.length - 1;
					
					for(var i = 0; i < lh; i+=2) {
						x.push(x_y[i]); 
					}
					
					for(var i = 1; i < lh; i+=2) { //y 홀수
						y.push(x_y[i]); 
					}
					
					 for(i = 0; i <= lh; i++){
						 var marker = new naver.maps.Marker({
							    position: new naver.maps.LatLng(x[i], y[i]),			   
							    map: map,
							    icon: {
							    	content: '<i class="fas fa-map-marker-alt schedule_list_marker"></i>',
							    	//url: "resources/Test_Images/target.png",
							    	size: new naver.maps.Size(22,36),
							    	origin: new naver.maps.Point(0,0),
							    	anchor: new naver.maps.Point(11,35)
							    },
							    draggable: true
							});

						 markers.push(marker);
						}
					//alert(x_y[0] + " " + x_y[1] + " " + x_y[2]);
					//alert(check);
					//console.log(check);
				},
				error: function(check) {
					alert("실패" + check);
					console.log(check);
				}
			});
			//return lh;
		}).mouseout(function(){
			for(i = 0; i < markers.length; i++){
				markers[i].setMap(null);
			}	
		});
	 */
</script>
