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

<script src="https://use.fontawesome.com/releases/v5.15.3/js/all.js" ></script>

<!-- 달력 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script type="text/javascript" src="${root }js/together_write.js" ></script>
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

td {
	vertical-align: top;
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

.rowLine {
	top: 0px;
	width: 50%;
	pading: 15px;
}

.left_col {
	top: 0px;
	width: 100%;
	padding-right : 10px;
	vertical-align: center;
}


.right_col {
	float: right;
}

#search_view {
	display: flex;
	justify-content: center;
	margin: 0px 5px;	
}

.list-group-item {
	margin : 0px;
}

.sidebar-menu {
	height: 400px;
	overflow: auto;
}

</style>

</head>
<body>
	<!-- 상단 메뉴 -->
	<c:import url="/WEB-INF/view/include/header.jsp" />

	<!-- 메인 -->
	<div class="container" style="margin-top: 150px; margin-bottom: 100px;">
		<h3 class="InputSubject">
			<b>새로운 동행 만들기</b>
		</h3>
		<hr>
		<br>
		<div class="row no-gutters">
			<div class="col-md-6">
				<div class="card mr-3">
					<div class="card-body" style="padding: 20px;">
						<label for="search-field">동행할 여행지 검색</label>
						<div class="input-group findSpot" >
							<input type="text" class="form-control" id="search-field" placeholder="검색..." style="background: #f9f9f9; ">
							<div class="input-group-append btn-search">
								<span class="input-group-text" style="background: #e9e9e9;">
									<i class="fa fa-search" aria-hidden="true"></i>
								</span>
							</div>
						</div>
						<div class="sidebar-menu" style="display: none; border: 1px solid #e9e9e9; max-height: 348px;">
							<div id="search_view" class="row">			
							</div>
						</div>
						<div class="input-group" id="printSpot" style="display:none;">
							<input type="text" class="form-control" id="fixedSpotTitle" style="background: #f9f9f9; " disabled/>
							<input type="hidden" id="fixedSpotContentId">
							<div class="input-group-append">
								<a href="#" class="card-btn btn btn-dark" onclick="modifySpot()">수정하기</a>
							</div>
						</div>
						<div class="calendar" style="display:none; margin-top: 20px;">
							<label for="meetDate">동행할 일정</label>
							<div class="input-group">
								<input id="meetDate" class="form-control flatpickr flatpickr-input active" type="text" placeholder="날짜와 시간을 선택해주세요..." data-id="minMaxTime" readonly="readonly">
								<div class="input-group-append">
									<a href="#" class="card-btn btn btn-dark" onclick="writeMeetDate()" style="float:right;">일정 선택</a>
								</div>
							</div>
						</div>
						<div id="number" style="display:none; margin-top: 20px;">
							<label for="personNumber">동행할 인원</label>
							<div class="input-group">
								<select id="personNumber" class="form-control" >
									<option selected>동행할 인원을 선택해주세요...</option>
									<option value="2">2명</option>
									<option value="3">3명</option>
									<option value="4">4명</option>
								</select>
								<div class="input-group-append">	
									<a href="#" class="card-btn btn btn-dark" onclick="writePersonNumber()" style="float:right;">인원 선택</a>							
								</div>
							</div>
							<p style="color: red; margin: 10px 0 0 10px;">※ 5인 이상 집합금지 명령에 따라 인원은 최대 4인 까지 선택 가능합니다.</p>
						</div>
					</div>
				</div>
			</div>
			<div class="col-md-6">
				<div class="card">
					<div class="card-body" style="padding: 16px 20px 0;">
						<form:form action="${root}together/writeProc" method="post" modelAttribute="togetherWriteDTO">
							<form:hidden path="to_no" />
							<form:hidden path="to_place"/>
							<form:hidden path="to_place_name"/>
							<form:hidden path="to_meet"/>
							<form:hidden path="to_total"/>
							<div class="form-group">
								<form:label path="to_title">동행 이름</form:label>
								<form:input path="to_title" class="form-control" />
								<form:errors path="to_title" style="color:red;" />
							</div>
							<div class="form-group">
								<form:label path="to_content">동행 내용</form:label>
								<form:textarea path="to_content" class="form-control" rows="10"
									style="resize:none" />
								<form:errors path="to_content" style="color:red;" />
							</div>
							<div class="form-group">
								<div class="col-sm-15 text-right">
									<form:button class="btn btn-success" style="margin-right: 5px;">작성완료</form:button>
									<a href="${root}together/list" class="btn btn-danger">취소</a>
								</div>
							</div>
						</form:form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Footer -->
	<c:import url="/WEB-INF/view/include/footer.jsp" />
</body>
</html>