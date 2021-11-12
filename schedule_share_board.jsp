<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	int member_seq = 0;
	if((Integer)session.getAttribute("seq") != null){
		member_seq = (Integer)session.getAttribute("seq");
	}

	int schedule_seq = 1;
	
	String sql = "select seq, member_seq, schedule_name, plan_date from schedule where on_off = 1 ORDER BY plan_date desc"; //스케줄 공유한 사람만 보여줌
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
	
	ResultSet rs2 = null; //회원 아이디
	ResultSet rs3 = null; //이미지
	
	ResultSet rs7 = null;
	
	sql = "SELECT sl.schedule_seq, COUNT(schedule_seq) as cnt FROM schedule_like sl GROUP BY schedule_seq ORDER BY cnt DESC LIMIT 3";
	pstmt = conn.prepareStatement(sql);
	ResultSet rs5 = pstmt.executeQuery();
	
	//schedule table seq -> schedule_detail table tour_seq -> tour table thumbnail -> order by rand() limit 1 = 결과 중 랜덤하게 1개만 가져오기
	// 또는 sort 값이 1로 확정적으로 하나만 하기
	//select  thumbnail from tour, schedule_detail where schedule_detail.schedule_seq = ? and schedule_detail.sort = 1 and schedule_detail.tour_seq = tour.seq	
	int i = 1;
%>
<div class="width_1400 share_board">
	<p class="top3_title">좋아요 많이 받은 TOP3</p>
	
	<ul class="top3_box">
		<% while(rs5.next()) { %>
			<li>
				<a href="main.jsp?target=schedule_detail&schedule_seq=<%=rs5.getInt("sl.schedule_seq")%>">
					<%
						sql = "SELECT m.id, s.schedule_name, s.plan_date FROM schedule s, member m WHERE s.seq = ? AND s.member_seq = m.seq"; //회원 id, 스케줄 이름
						pstmt = conn.prepareStatement(sql);
						pstmt.setInt(1, rs5.getInt("sl.schedule_seq"));
						ResultSet rs6 = pstmt.executeQuery();
						rs6.next();
					
						sql = "select thumbnail from tour, schedule_detail where schedule_detail.schedule_seq = ? and schedule_detail.tour_seq = tour.seq order by rand() limit 1";
						pstmt = conn.prepareStatement(sql);
						pstmt.setInt(1, rs5.getInt("sl.schedule_seq"));
						rs7 = pstmt.executeQuery();
						if(rs7.next()){
					 %>
					<div class="topimgbox">
						<img src=<%=rs7.getString("thumbnail")%>><% } %>
					</div>
					
					<div class="top3_schedule_name_box">
						<p><i class="fas fa-hand-holding-heart"> <%=rs5.getInt("cnt")%></i></p>
						<p>[<%=i %>위] <%=rs6.getString("s.schedule_name")%></p>
					</div>
					
					<div class="top3_content_box">
						<p><%=rs6.getString("m.id")%> | <%=rs6.getDate("s.plan_date")%></p>
						<!-- 날짜 / 조회수 -->
					</div>
				</a>
			</li>
		<% i++; } %>
	</ul>
	
	<hr>
	
	<p style="text-align:left;">최신순</p>
	<ul class="share_board_box">
		<% while(rs.next()) { %>
			<li>
				<a href="main.jsp?target=schedule_detail&schedule_seq=<%=rs.getInt("seq")%>">
					<div class="img_box">
					<%
						sql = "select id from member where seq = ?"; //회원 아이디
						pstmt = conn.prepareStatement(sql);
						pstmt.setInt(1, rs.getInt("schedule.member_seq"));
						rs2 = pstmt.executeQuery();
						rs2.next();
					
						sql = "select thumbnail from tour, schedule_detail where schedule_detail.schedule_seq = ? and schedule_detail.tour_seq = tour.seq order by rand() limit 1";
						pstmt = conn.prepareStatement(sql);
						pstmt.setInt(1, rs.getInt("schedule.seq"));
						rs3 = pstmt.executeQuery();
						if(rs3.next()){
					 %>
						<img src=<%=rs3.getString("tour.thumbnail")%>><% } %>
					</div>
					
					<div class="content_box">
						<p style="color:lightgray;"><%=rs2.getString("member.id")%> | <%=rs.getDate("plan_date")%></p>
						<p class="schedule_name"><%=rs.getString("schedule_name")%></p>
					</div>
				</a>
				
				<% if(rs.getInt("member_seq") != member_seq ) { 
					sql = "select schedule_seq, member_seq from schedule_like where schedule_seq = ? and member_seq = ?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, rs.getInt("seq"));
					pstmt.setInt(2, member_seq);
					ResultSet rs4 = pstmt.executeQuery();
				%>
					<button type="button" class="like_btn" data-seq="<%=rs.getInt("seq")%>" title="좋아요">
					<% if(rs4.isBeforeFirst()) { %>
						<i class="fas fa-heart"></i>
					<% } else if(!rs4.isBeforeFirst()){ %>
						<i class="far fa-heart"></i>
					<% } %>
					</button>
				<% } %>
			</li>
		<% } %>
	</ul>
</div>
<script>
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
<% pstmt.close(); conn.close(); %>