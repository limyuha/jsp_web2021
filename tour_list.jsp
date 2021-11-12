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
		System.out.print(rowCount);
		
		String pageNum = request.getParameter("pageNum");//넘어온 페이지 번호
		int currentPage = 1; // 첫시작시 현재 페이지
		int currentPageSetup; // 이전버튼누를시 이동할 페이지
		int currentPageNext; // 다음버튼 누를시 이동할 페이지
		int startPage; // 이 화면에서 보여줄 페이지중에서 가장 앞페이지
		int endPage;

		if(pageNum!=null){
			currentPage = Integer.parseInt(pageNum); //넘어온 페이지번호가 존재할경우 현재페이지에 값 넣어주기	
		}

		int pageLimit = 10; //한번에 보이는 페이지수
		int tourLimit = 12; //한페이지에 보이는 게시물

		int totalPage = rowCount / tourLimit; //전체 페이지
		if(rowCount % tourLimit != 0){ //나머지가 0이 아니면 페이지 하나 더만듬
			totalPage++;
		}
		
		int start = (currentPage-1) * tourLimit +1; //db에서 가져올 rownum의 시작
		int end = currentPage * tourLimit; //db에서 가져올 rownum의 끝
		
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
	<form action="/yuha_jsp2021/main.jsp" id="search_form" method="get">
		<input type="hidden" name="target" value="tour_list"/>
		<div class="search_box">
			<span class="search_icon"><i class="fa fa-search"></i></span>
			<input type="search" name="search" class="search" placeholder="Search...">
			<button type="submit" class="search_btn">검색</button>	
		</div>
	</form>
	
   <ul class="Tour_list_box" >
     <% rs.absolute(start); %>
			<% while(rs.getRow() <= end) { %>
			<% //while(rs.next()){ %>
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
      <%  rs.next();} %>
   </ul>
   
   	<div>
		<ul>
			<% for(int i = startPage ; i <= endPage; i++) {
				if(search == null) {
					search = "";
				}
				%>
				<a href="main.jsp?target=tour_list&pageNum=<%=i %>&search=<%=search%>">
					<li><%=i %></li>
				</a>
			<% } %>
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
<%	
/*
	 int pageNo = 0; // 페이지 번호
	 int pageSize = 0; // 게시글 수
	 
	 int firstPageNo = 1; // 첫 번째 페이지 번호
	 int prevPageNo; // 이전 페이지 번호
	 int startPageNo; // 시작 페이지 (페이징 네비 기준)
	 //int pageNo; // 페이지 번호
	 int endPageNo; // 끝 페이지 (페이징 네비 기준)
	 int nextPageNo; // 다음 페이지 번호
	 int finalPageNo; // 마지막 페이지 번호
	 //int totalCount; // 게시 글 전체 수
	
	 if ( totalCount == 0) return; // 게시 글 전체 수가 없는 경우
	 if (pageNo == 0) { pageNo = 1; } // 기본 값 설정
	 if (pageSize == 0) { pageSize = 10; } // 기본 값 설정
	 
     int finalPage = (totalCount + (pageSize - 1)) / pageSize; // 마지막 페이지
     if (pageNo > finalPage) pageNo = finalPage; // 기본 값 설정
     
     if (pageNo < 0 || pageNo > finalPage) pageNo = 1; // 현재 페이지 유효성 체크

     boolean isNowFirst = pageNo == 1 ? true : false; // 시작 페이지 (전체)
     boolean isNowFinal = pageNo == finalPage ? true : false; // 마지막 페이지 (전체)

     int startPage = ((pageNo - 1) / 10) * 10 + 1; // 시작 페이지 (페이징 네비 기준)
     int endPage = startPage + 10 - 1; // 끝 페이지 (페이징 네비 기준)

     if (endPage > finalPage) { // [마지막 페이지 (페이징 네비 기준) > 마지막 페이지] 보다 큰 경우
         endPage = finalPage;
     }

     if (isNowFirst) {
    	 prevPageNo = 1; // 이전 페이지 번호
     } else {
    	 prevPageNo = (((pageNo - 1) < 1 ? 1 : (pageNo - 1))); // 이전 페이지 번호
     }

     //this.setStartPageNo(startPage); // 시작 페이지 (페이징 네비 기준)
     //this.setEndPageNo(endPage); // 끝 페이지 (페이징 네비 기준)

     if (isNowFinal) {
    	 nextPageNo = finalPage; // 다음 페이지 번호
     } else {
    	 nextPageNo = (((pageNo + 1) > finalPage ? finalPage : (pageNo + 1))); // 다음 페이지 번호
     }

     //this.setFinalPageNo(finalPage); // 마지막 페이지 번호
	 
	*/
	
	 /*
	 if (this.totalCount == 0) return; // 게시 글 전체 수가 없는 경우
     if (this.pageNo == 0) this.setPageNo(1); // 기본 값 설정
     if (this.pageSize == 0) this.setPageSize(10); // 기본 값 설정

     int finalPage = (totalCount + (pageSize - 1)) / pageSize; // 마지막 페이지
     if (this.pageNo > finalPage) this.setPageNo(finalPage); // 기본 값 설정

     if (this.pageNo < 0 || this.pageNo > finalPage) this.pageNo = 1; // 현재 페이지 유효성 체크

     boolean isNowFirst = pageNo == 1 ? true : false; // 시작 페이지 (전체)
     boolean isNowFinal = pageNo == finalPage ? true : false; // 마지막 페이지 (전체)

     int startPage = ((pageNo - 1) / 10) * 10 + 1; // 시작 페이지 (페이징 네비 기준)
     int endPage = startPage + 10 - 1; // 끝 페이지 (페이징 네비 기준)

     if (endPage > finalPage) { // [마지막 페이지 (페이징 네비 기준) > 마지막 페이지] 보다 큰 경우
         endPage = finalPage;
     }

     this.setFirstPageNo(1); // 첫 번째 페이지 번호

     if (isNowFirst) {
         this.setPrevPageNo(1); // 이전 페이지 번호
     } else {
         this.setPrevPageNo(((pageNo - 1) < 1 ? 1 : (pageNo - 1))); // 이전 페이지 번호
     }

     this.setStartPageNo(startPage); // 시작 페이지 (페이징 네비 기준)
     this.setEndPageNo(endPage); // 끝 페이지 (페이징 네비 기준)

     if (isNowFinal) {
         this.setNextPageNo(finalPage); // 다음 페이지 번호
     } else {
         this.setNextPageNo(((pageNo + 1) > finalPage ? finalPage : (pageNo + 1))); // 다음 페이지 번호
     }

     this.setFinalPageNo(finalPage); // 마지막 페이지 번호
 }
 */
%>