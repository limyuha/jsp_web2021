<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
   int member_seq = 0; //관광지 좋아요 하는데 필요한 회원 번호
   if((Integer)session.getAttribute("seq") != null){
      member_seq = (Integer)session.getAttribute("seq");
   }
   
   String search = null; //검색하는데 필요한 변수
   if(request.getParameter("search") == null){
      search = null;
   } else {
      search = request.getParameter("search") ;
   }
   
   String sql = "select seq, thumbnail, place_name, simple_content, place_hit from tour";
      if(search != null){
         //sql = sql + "WHERE place_name LIKE(?)";
         sql = "select seq, thumbnail, place_name, simple_content, place_hit from tour WHERE place_name LIKE(?)";
      }
      pstmt = conn.prepareStatement(sql,ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
         if(search != null) {
            pstmt.setString(1, "%" + search + "%");
         }
      rs = pstmt.executeQuery();
      
      int totalCount = 0;
      
      rs.last();
      int rowCount = rs.getRow(); //tour테이클 컬럼카운트
      rs.beforeFirst();
      //System.out.print(rowCount);
      
      String pageNum = request.getParameter("pageNum");//넘어온 페이지 번호
      int currentPage = 1; // 첫시작시 현재 페이지
      int currentPageSetup; // 이전버튼누를시 이동할 페이지
      int currentPageNext; // 다음버튼 누를시 이동할 페이지
      int startPage; // 이 화면에서 보여줄 페이지중에서 가장 앞페이지
      int endPage;
      

      if(pageNum != null){
         currentPage = Integer.parseInt(pageNum); //넘어온 페이지번호가 존재할경우 현재페이지에 값 넣어주기   
      }

      int pageLimit = 10; //한번에 보이는 페이지수
      int tourLimit = 12; //한페이지에 보이는 게시물

      int totalPage = rowCount / tourLimit; //전체 페이지
      if(rowCount % tourLimit != 0){ //나머지가 0이 아니면 페이지 하나 더만듬
         totalPage++;
      }
      
      int start = (currentPage-1) * tourLimit +1; //db에서 가져올 rownum의 시작, 1 13 25 .. (1부터 12배수 + 1)
      int end = currentPage * tourLimit; //db에서 가져올 rownum의 끝, 12 24 .. 12배수
      int lastCheck = rowCount - start; //마지막 페이지 체크
      
      currentPageSetup = (currentPage/pageLimit) * pageLimit; // (n+0)*pageLimit +1 부터 (n+1)*pageLimit까지는 n*10 ...
      if(currentPage % pageLimit == 0){
         currentPageSetup = currentPageSetup - pageLimit ;
      }

      currentPageNext = (currentPage/pageLimit) * pageLimit + pageLimit + 1;
      if(currentPage % pageLimit == 0){
         currentPageNext = currentPageNext - pageLimit;
      }
      
      startPage = currentPageSetup + 1;
      endPage = startPage + (pageLimit - 1);
      if(startPage == totalPage){
         endPage = startPage;
      }
      if(endPage > totalPage){
         endPage = totalPage;
      }
%>
<div class="Tour_list">
   <form action="/jsp_web2021/main.jsp" id="search_form" method="get">
      <input type="hidden" name="target" value="tour_list"/>
      <div class="search_box">
         <span class="search_icon"><i class="fa fa-search"></i></span>
         <input type="search" name="search" class="search" placeholder="Search...">
         <button type="submit" class="search_btn">검색</button>   
      </div>
   </form>
   
   <ul class="Tour_list_box" >
	 <%
     	 rs.absolute(start - 1); //처음) start = 1
     		if (tourLimit > lastCheck) { // 12 > rowCount - start
   			   end = start + lastCheck; // = rowCount
     		}
     		
			while (rs.getRow() < end ) { //처음) end = 11
      			rs.next(); //rs.next() 이후 start ~ end = 1 ~ 12
      %>
         <li>
         <% //관광지 좋아요 버튼
            sql = "select tour_seq, member_seq from tour_like where tour_seq = ? and member_seq = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, rs.getInt("seq"));
            pstmt.setInt(2, member_seq);
            ResultSet rs2 = pstmt.executeQuery();
         %>
         <button type="button" class="like_btn" data-seq="<%=rs.getInt("seq")%>" title="좋아요">
         <% if(rs2.isBeforeFirst()) { %>
            <i class="fas fa-heart"></i>
         <% } else if(!rs2.isBeforeFirst()){ %>
            <i class="far fa-heart"></i>      
         <% } %>
         </button>
                  
            <a href="main.jsp?target=tour_page&tour_seq=<%=rs.getInt("seq")%>">
               <div class="img_box"><img src=<%=rs.getString("thumbnail")%>>
                     <p class="hit_icon">
                       <i class="far fa-eye"> <%=rs.getInt("place_hit") %></i>
                    </p>
                 
                  <div class="info_box">
                     <p><%=rs.getString("place_name")%></p>
                     <p class="content_font"><%=rs.getString("simple_content")%></p>
                  </div>
               </div>
            </a>
         </li>
      <%  }  %>
   </ul>
      
	<div class="num_box">
		<ul>
			<% if(currentPage > 10){%>
				<li>
					<a href="main.jsp?target=tour_list&pageNum=<%=currentPageSetup %>"><i class="fas fa-chevron-left"></i></a>
				</li>
			<% } %>
			
			<% for(int i = startPage ; i <= endPage; i++) {
				if(search == null) {
				  		search = "";
				}
			%>
				<li>
				   <a href="main.jsp?target=tour_list&pageNum=<%=i %>&search=<%=search%>"><%=i %></a>
				</li>
			<% } %>
			
				<li>
				<% if((totalPage - startPage) >= 10 ) {%>
					<a href="main.jsp?target=tour_list&pageNum=<%=currentPageNext %>"><i class="fas fa-chevron-right"></i></a>
				<% } %>
				</li>
		</ul>
	</div>
</div>
<% pstmt.close(); conn.close(); %>
<script>
$('.like_btn').click(function() {
   var that = $(this);   
      $.ajax({
         url : 'action/tour_like.jsp',
         type : 'post',
         data : 'tour_seq='+$(this).attr('data-seq'),
         success : function(like) {
            //console.log(like);
            if($.trim(like) == '비회원') {
               if(confirm("이 서비스는 회원전용으로 제공됩니다.\n로그인 하시겠습니까?")) {
                  location.href="main.jsp?target=j_rogin";
               }
            }
            else if($.trim(like) == '좋아요') {
               that.find('.fa-heart').removeClass('far').addClass('fas');
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
<script>
/*
   $('.save_btn').click(function(){ 
      $.ajax({
         url:'action/tour_list_search.jsp', //데이터 보낼 url
         type:'post', //form 태그의 method 속성(post 또는 get)
         data: $('#search_form').serialize(), //폼 두개
         success: function(e) { //제일 마지막 문장
            if($.trim(e)){ //공백 있어서 trim으로 공백 삭제
               alert(e);
               //location.reload();
            } 
            console.log(e);
         },
         error: function(e) {
            console.log(e);
         }
      });
   });
   */
</script>