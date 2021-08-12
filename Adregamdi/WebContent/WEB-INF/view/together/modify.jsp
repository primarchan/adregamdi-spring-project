<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!-- 절대 경로 설정 -->
<c:set var="root" value="${pageContext.request.contextPath }/" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>어드레 감디 | 같이가치</title>
<!-- Bootstrap CDN -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>

<!-- 달력 -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

<script>
	$(function() {
		
		$(".flatpickr").flatpickr({
			enableTime:true,
			minDate: "today",
			dateFormat: "Y-m-d H:i"			
		});		
		
		
	});
	
  	function submit() {
	  $("#togetherWriteDTO").submit();
  	}
  </script>

<style>
@font-face {
	font-family: 'Bazzi';
	src:
		url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_20-04@2.1/Bazzi.woff')
		format('woff');
	font-weight: normal;
	font-style: normal;
}

body {
	font-family: 'Bazzi';
}

::-webkit-scrollbar {
	width: 5px;
	height: 7px;
}

::-webkit-scrollbar-button {
	width: 0px;
	height: 0px;
}

::-webkit-scrollbar-thumb {
	background: #525965;
	border: none;
}
</style>

</head>
<body>
	<!-- 상단 메뉴 -->
	<c:import url="/WEB-INF/view/include/header.jsp" />

	<!-- 메인 -->
	<div class="container" style="margin-top: 150px; margin-bottom: 150px;">
		<h3 class="InputSubject">
			<b>글 수정</b>
		</h3>
		<hr>
		<br>

		<form:form action="${root}together/modifyProc" method="post" modelAttribute="togetherModifyDTO" class="form-horizontal">
			<form:hidden path="to_no" />
			<div class="form-group">
				<form:label path="to_title">제목</form:label>
				<form:input path="to_title" class="form-control" />
				<form:errors path="to_title" style="color:red;" />
			</div>
			<div class="form-group">
				<form:label path="to_content">공고문</form:label>
				<form:textarea path="to_content" class="form-control" rows="10"
					style="resize:none" />
				<form:errors path="to_content" style="color:red;" />
			</div>
			<div class="form-group">
				<form:label path="to_place_name">여행지</form:label>
				<input id="to_place_name" class="form-control" value="${togetherModifyDTO.to_place_name }" disabled></input>
				<form:hidden path="to_place"/>
				<form:hidden path="to_place_name"/>
			</div>
			<div class="form-group">
				<form:label path="to_meet">여행날짜</form:label>
				<form:input path="to_meet" class="form-control flatpickr flatpickr-input active" type="text" placeholder="Select Date.." data-id="minMaxTime" readonly="readonly"/>
			</div>
			<div class="form-group">
				<form:label path="to_total">모집인원</form:label>
				<form:select path="to_total" class="form-control" >
					<form:option value="${togetherModifyDTO.to_total }">${togetherModifyDTO.to_total }명</form:option>
					<c:if test="${togetherModifyDTO.to_total == 2 }">
						<form:option value="3">3명</form:option>
                        <form:option value="4">4명</form:option>
					</c:if>
					<c:if test="${togetherModifyDTO.to_total == 3 }">
						<form:option value="2">2명</form:option>
                        <form:option value="4">4명</form:option>
					</c:if>
					<c:if test="${togetherModifyDTO.to_total == 4 }">
						<form:option value="2">2명</form:option>
                        <form:option value="3">3명</form:option>
					</c:if>
				</form:select>
				<p style="color: red; margin: 10px 0 0 10px;">※ 5인 이상 집합금지 명령에 따라 인원은 최대 4인 까지 선택 가능합니다.</p>                  
			</div>
			<div class="form-group">
				<div class="col-sm-15 text-right">
					<form:button class="btn btn-success" style="margin-right : 5px;">수정완료</form:button>
					<a href="${root}together/list" class="btn btn-danger">취소</a>
				</div>
			</div>
		</form:form>

	</div>
	<!-- Footer -->
	<c:import url="/WEB-INF/view/include/footer.jsp" />
</body>
</html>