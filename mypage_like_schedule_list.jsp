<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	int member_seq = (Integer)session.getAttribute("seq");
	
	String sql = "select * from schedule, schedule_like WHERE schedule_like.member_seq = ? AND schedule_like.schedule_seq = schedule.seq";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, member_seq);
	rs = pstmt.executeQuery();
%>
<p><i class="fas fa-heart" style="color:red;"></i> 스케줄 리스트 목록</p>
<div class="width_900 schedule_list">
	<% if(!rs.isBeforeFirst()) { //isBeforeFirst : 결과에 무언가 있는지 확인하고 커서 이동 X, rs.next() 사용하면 커서 이동하게 됨 %>	
		<p>다른 사람이 올린 스케줄이 마음에 든다면 좋아요를 해보세요~</p>
		<p>이곳에서 확인할 수 있습니다!</p>
	<% } else { %>
		<button type="button" id="explain_btn">설명서 보기</button>
		<div class="explain_box_like">
			<p>좋아요 한 스케줄 박스에 마우스를 올리면 지도에 마커(<i class="fas fa-map-marker-alt explainmarker"></i>)가 나타납니다.</p>
			<p>마우스가 박스에서 벗어나면 지도에서 마커(<i class="fas fa-map-marker-alt explainmarker"></i>)가 사라집니다.
			<p>자세한 스케줄 리스트 정보를 보고 싶다면 스케줄 이름을 클릭하면 내가 좋아요 한 사람의 스케줄 리스트 페이지로 이동합니다.</p>
			<p>하트 아이콘(<i class="fas fa-heart" style="color:red;"></i>)을 클릭하여 좋아요를 취소하고 좋아요 한 스케줄 리스트 목록에서 삭제할 수 있습니다.</p>
		</div>
		
		<ul class="list_box">
			<% while(rs.next()) { 
				int mb_seq = rs.getInt("schedule.member_seq"); //스케줄 리스트 작성자의 seq 
				
				sql = "select id from member WHERE seq = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, mb_seq);
				ResultSet rs2 = pstmt.executeQuery();
				rs2.next();
			%>
				<li class="hover-map" data-seq="<%=rs.getInt("seq")%>">
					<a href="main.jsp?target=schedule_detail&schedule_seq=<%=rs.getInt("schedule.seq")%>">
						<%=rs2.getString("id")%>님의 <%=rs.getString("schedule.schedule_name")%> 스케줄
					</a>
					
					<button type="button" class="delete_btn" onclick="location.href='action/schedule_list_delete_like.jsp?&schedule_seq=<%=rs.getInt("schedule.seq")%>' ">
						<i class="fas fa-heart" style="color:red;"></i>
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
		    zoom: 11
		};
	var map = new naver.maps.Map('map', mapOptions); //맵생성
	
		$(".hover-map").mouseover(function(){ //li 요소들
			var that = $(this);
			var x = new Array();
			var y = new Array();
			//var lh;
			markers = [];
			
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
							position: new naver.maps.LatLng(x_y[0], x_y[1]),			   
							map: map,
					  		icon: {
								content: '<i class="fas fa-map-marker-alt schedule_list_marker"></i><spen>'+x_y[2]+'</spen>',
							    size: new naver.maps.Size(22,36),
							    origin: new naver.maps.Point(0,0),
							    anchor: new naver.maps.Point(11,35)
							},
								//draggable: true
							});

						 markers.push(marker);
					}
					/*
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
					 */
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
				//markers = [];
			}
		});
	
	$('#explain_btn').click(function(){
		$('.schedule_list .explain_box_like').toggleClass('on');
	});
</script>
