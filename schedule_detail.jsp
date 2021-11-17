<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	int member_seq = 0;
	if((Integer)session.getAttribute("seq") != null){
		member_seq = (Integer)session.getAttribute("seq");
	}
	
	int schedule_seq = Integer.parseInt(request.getParameter("schedule_seq"));
	String sql = "select * from tour, schedule_detail where schedule_detail.schedule_seq = ? and tour.seq = schedule_detail.tour_seq";	
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, schedule_seq);
	rs = pstmt.executeQuery();
	
	ResultSet rs2 = null;
	sql = "SELECT * FROM schedule, member where schedule.seq = ? AND schedule.member_seq = member.seq";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, schedule_seq);
	rs2 = pstmt.executeQuery();
	rs2.next();
	
	ResultSet rs3 = null;
	sql = "select schedule_seq, member_seq from schedule_like where schedule_seq = ? and member_seq = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, schedule_seq);
	pstmt.setInt(2, member_seq);
	rs3 = pstmt.executeQuery();
	
	sql = "select count(schedule_seq) cnt from schedule_like where schedule_seq = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, schedule_seq);
	ResultSet rs4 = pstmt.executeQuery();
	rs4.next();

	//조회수 세션
	int plan_hit = rs2.getInt("plan_hit"); //조회수
	String cntPlanhit = "count" + schedule_seq; //스케줄 seq
	
	if(session.getAttribute(cntPlanhit) == null) //세션에 cntName 없으면 실행
	{
		
		plan_hit++;
		session.setAttribute(cntPlanhit, plan_hit); //세션에 cntName 저장
		sql = "update schedule set plan_hit = ? WHERE seq = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, plan_hit);
		pstmt.setInt(2, schedule_seq);
		pstmt.executeUpdate();
	}
%>
<script>
	var x = new Array();
	var y = new Array();
	var place_name = new Array();
</script>
<div class="width_1200 schedule_detail_box">
	<% if(rs2.getInt("member.seq") == member_seq ) { %>
	<div class="sd_box">
		<i class="fas fa-heart like_icon"></i><spen>
		<p class="sd_name"><spen style="font-size:15px;"><%=rs4.getInt("cnt")%></spen> 나의 [<%=rs2.getString("schedule.schedule_name")%>] 스케줄</p>
		<button type="button" class="delete_btn" onclick="location.href='action/schedule_list_delete.jsp?&schedule_seq=<%=schedule_seq%>' ">
			삭제하기 <i class="fas fa-minus-square"></i>
		</button>
	</div>
	<% } else { %>
	<div class="sd_box">
		<p class="sd_name"><%=rs2.getString("member.id")%>님의 [<%=rs2.getString("schedule.schedule_name")%>] 스케줄</p>
		
		<button type="button" class="like_btn" data-seq="<%=schedule_seq%>" title="좋아요">
		<% if(rs3.isBeforeFirst()) { %>
			<i class="fas fa-heart"></i>
		<% } else if(!rs3.isBeforeFirst()){ %>
			<i class="far fa-heart"></i>
		</button>
		<% } %>
	</div>
	<% } %>
	<ul class="schedule_tour_box">
		<% while(rs.next()) { %>
			<li>
				<a href ="main.jsp?target=tour_page&tour_seq=<%=rs.getInt("tour.seq")%>">
					<div class="img_box"><img src=<%=rs.getString("tour.thumbnail")%>>
						<div class="info_box">
							<p><%=rs.getString("tour.place_name")%></p>
							<p class="content_font"><%=rs.getString("tour.simple_content")%></p>
						</div>	
					</div>
				</a>
			</li>
			
			<script>
			x.push("<%=rs.getDouble("tour.place_x")%>"); //x 값 푸시
			y.push("<%=rs.getDouble("tour.place_y")%>"); //y 값 푸시
			place_name.push("<%=rs.getString("tour.place_name")%>"); //관광지 이름 푸시
			</script>
		<% } %>
	</ul>
	
	<div class="schedule_detail_map" id='map'></div> <!-- 지도 -->
</div>
<script>
	var markers = [],  infoWindows = []; //마커들 담을 배열
	var container = document.getElementById('map'); //지도를 표시할 div
	var mapOptions = {
		    center: new naver.maps.LatLng(x[0], y[0]),
		    zoom: 12
		};
	var map = new naver.maps.Map('map', mapOptions); //맵생성
	var num = 1;

	 for(i = 0; i <= x.length; i++){
		 var marker = new naver.maps.Marker({
			    position: new naver.maps.LatLng(x[i], y[i]),
			    map: map,
			    icon: {
			    	content: '<i class="fas fa-map-marker schedule_detail_marker"><spen class="schedule_detail_marker_num">'+[num]+'</spen></i><spen>'+place_name[i]+'</spen>',
			    	//url: 'target.png', //<i class="fas fa-map-marker-alt"></i>
			    	size: new naver.maps.Size(22,36),
			    	origin: new naver.maps.Point(0,0),
			    	anchor: new naver.maps.Point(11,35)
			    },
			    //draggable: true
			});
	    markers.push(marker);
		num++;
	}
	
	$('.like_btn').click(function() {
		var that = $(this);	
			$.ajax({
				url : 'action/schedule_like.jsp',
				type : 'post',
				data : 'schedule_seq='+$(this).attr('data-seq'),
				success : function(like) {
					//console.log(like);
					if($.trim(like) == '비회원') {
						if(confirm("이 서비스는 회원전용으로 제공됩니다.\n로그인 하시겠습니까?")) {
							location.href="main.jsp?target=j_rogin";
						}
					}
					else if($.trim(like) == '좋아요') {
						that.find('.fa-heart').removeClass('far').addClass('fas');
						//console.log(that.html());
					} else if($.trim(like) == '좋아요취소') {
						that.find('.fa-heart').removeClass('fas').addClass('far');
					}
				},
				error: function(like) {
					alert("실패");
					console.log(like);
				}
			});
		});
</script>