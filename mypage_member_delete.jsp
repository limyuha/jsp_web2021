<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<p>회원 탈퇴 안내<spen class="spenred">*<spen></p>
<form action="action/member_delete.jsp" method="post">
	<div class="mypage_member_dlt">
		<textarea name = "delete_content" readonly>
[회원탈퇴 약관]

회원탈퇴 신청 전 안내 사항을 확인 해 주세요.
회원탈퇴를 신청하시면 현재 로그인 된 아이디는 사용하실 수 없습니다.
회원탈퇴를 하더라도, 서비스 약관 및 개인정보 취급방침 동의하에 따라 일정 기간동안 회원 개인정보를 보관합니다.

- 장바구니 정보
- 소비자 불만 또는 처리 과정에 관한 기록
- 게시판 작성 및 사용후기에 관한 기록

※ 상세한 내용은 사이트 내 개인정보 취급방침을 참고 해 주세요.

회원탈퇴 신청 전 안내 사항을 확인 해 주세요.
회원탈퇴를 신청하시면 현재 로그인 된 아이디는 사용하실 수 없습니다.
회원탈퇴를 하더라도, 서비스 약관 및 개인정보 취급방침 동의하에 따라 일정 기간동안 회원 개인정보를 보관합니다.

- 장바구니 정보
- 소비자 불만 또는 처리 과정에 관한 기록
- 게시판 작성 및 사용후기에 관한 기록

※ 상세한 내용은 사이트 내 개인정보 취급방침을 참고 해 주세요.
		</textarea>
	</div>
	
	<div class="checkbox">
		<input type="checkbox" name="check" value="check_on"/>
		<spen class="check_content">회원 탈퇴 안내에 동의합니다.<spen class="spenred">*</spen></spen>
	</div>
	
	<button type="submit" class="member_delete_btn">탈퇴하기</button>
</form>