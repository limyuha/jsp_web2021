<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	int member_seq = (Integer)session.getAttribute("seq");
	
	//tour 테이블에서 관광지 정보 가져오기 위해서 조인
	String sql = "select tour.place_name, tour.thumbnail, tour.seq from tour, tour_like where tour_like.member_seq = ? and tour_like.tour_seq = tour.seq";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, member_seq);
	rs = pstmt.executeQuery();
%>
<p><i class="fas fa-heart" style="color:red; margin-bottom:15px;"></i> 좋아요 한 관광지 목록</p>
<div class="width_900 tour_like_list">
	<% if(!rs.isBeforeFirst()) { //isBeforeFirst : 결과에 무언가 있는지 확인하고 커서 이동 X, rs.next() 사용하면 커서 이동하게 됨 %>	
		<p>관광지가 마음에 든다면 좋아요를 해보세요~</p>
		<p>이곳에서 확인할 수 있습니다!</p>
	<% } else { %>
		<ul>
			<% while(rs.next()) { %>
				<li>
		            <a href="main.jsp?target=tour_page&tour_seq=<%=rs.getInt("tour.seq")%>">
		              	<img src=<%=rs.getString("thumbnail")%>>
		                 <div class="info_box">
		                 	<p><%=rs.getString("place_name")%></p>
		                 </div>
		            </a>
		            
		            <% //관광지 좋아요 버튼
						sql = "select tour_seq, member_seq from tour_like where tour_seq = ? and member_seq = ?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setInt(1, rs.getInt("seq"));
						pstmt.setInt(2, member_seq);
						ResultSet rs2 = pstmt.executeQuery();
					%>
					<button type="button" class="like_btn" onclick="location.href='action/tour_like_delete.jsp?&tour_seq=<%=rs.getInt("tour.seq")%>' ">
						<i class="fas fa-heart"></i>
					</button>
					
					<%
						sql = "select seq from cart where member_seq = ? and tour_seq = ?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setInt(1, member_seq);
						pstmt.setInt(2, rs.getInt("tour.seq"));
						ResultSet rs3 = pstmt.executeQuery();
					%>
					
					<button type="button" class="basket_btn" data-seq="<%=rs.getInt("tour.seq")%>">
					<% if(rs3.next()) { %> 
						<i class="fas fa-cart-arrow-down like_tour_cart_icon like_cart-color"></i> 
					<% } else { %> 
						<i class="fas fa-cart-arrow-down like_tour_cart_icon"></i>
					<% } %>
					</button>
				</li>
			<% } %>
		</ul>
	<% } %>
</div>
<script>
$('.basket_btn').click(function(){
	var that = $(this); //ajax this 인식 못해서 변수에 넣고 사용
		$.ajax({
			url : 'action/basket_btn.jsp', //데이터 보낼 url
			type : 'post',
			data: 'tour_seq='+$(this).attr('data-seq'),
			success: function(check) { //제일 마지막 문장
				if($.trim(check) == '0') {
					that.find('.fa-cart-arrow-down').removeClass('like_cart-color');
					console.log(that.html());
				} else if($.trim(check) == '1') {
					that.find('.fa-cart-arrow-down').addClass('like_cart-color');
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
</script>