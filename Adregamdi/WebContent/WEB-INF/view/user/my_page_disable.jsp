<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var='root' value="${pageContext.request.contextPath }/" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>어드레 감디 | 마이페이지</title>

<!-- Font Awesome CDN -->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.3/css/all.css" integrity="sha384-SZXxX4whJ79/gErwcOYf+zWLeJdY/qpuqC4cAa9rOGUstPomtqpuNWT9wdPEn2fk" crossorigin="anonymous">

<!-- Bootstrap CDN -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>


<!-- CSS import -->
<link href="${root }css/user.css" rel="stylesheet" type="text/css">


<script type="text/javascript">
/* 마이페이지 일정삭제*/
$(function() {
	$('.delete').click(function() {
		if(confirm("일정을 삭제하시겠습니까?")) {
			var plan_no = $(this).val();
			$.ajax({
				url : "/schedule/delete",
				type : "POST",
				dataType : "text",
				data : {"plan_no" : plan_no},
				success : function(data) {
					alert('일정이 삭제되었습니다!');
					location.href="/user/my_page_disable"
				}
			});
		}
	});
});
</script>



</head>
<body>


<!-- 상단 -->
<c:import url="/WEB-INF/view/include/header.jsp" />



	<div class="container my-top">
		<h3 class="BoardTitle mb-4">
			<b>마이페이지</b>
		</h3>

		<div class="card">
			<div class="card-header my-card-header">
				<a href="${root }user/modify" class="float-right btn btn-success" style="padding: 3px 10px;">회원정보</a>
				<ul class="nav nav-tabs card-header-tabs">
					<li class="nav-item"><a class="nav-link" href="${root }user/my_to">동행찾기&nbsp
						<c:if test="${myToCount ne '0' }">
							<span class="badge badge-secondary"> ${myToCount }</span>
						</c:if>
					</a></li>
					<li class="nav-item"><a class="nav-link" href="${root }user/my_page">공유일정&nbsp
						<c:if test="${myPublicCount != '0' }">
							<span class="badge badge-secondary"> ${myPublicCount }</span>
						</c:if>
					</a></li>
					<li class="nav-item"><a class="nav-link active" href="${root }user/my_page_disable">숨긴일정&nbsp
						<c:if test="${myPrivatCount != '0' }">
							<span class="badge badge-success"> ${myPrivatCount }</span>
						</c:if>
					</a></li>
				</ul>
			</div>
			<div class="row mx-3 my-3 .content-box_disable">
				<c:choose>	
				
					<c:when test="${myPrivatCount eq '0' }">
						<div class="col-sm-12 text-center">
						<div class="jumbotron jumbotron-fluid bg-white" style="padding:2rem 0; margin-bottom:-20px;">
						  <div class="container">
						    <h1 class="display-5">나의 숨긴일정이 비어있습니다...<i class="far fa-sad-tear"></i></h1>
						    <p class="lead">아래 버튼을 눌러 나만의 특별한 제주도 여행을 스케줄링하고 다른 사람들과 공유하세요!</p>
						  </div>
						</div>
							<a class="btn btn-outline-success btn-lg mb-5" href="${root }schedule/list?page=1">나만의 일정 만들기</a>
						</div>
					</c:when>
				
					<c:otherwise>
						<c:forEach var="planDTO" items="${myPlan }" >
							<c:if test="${planDTO.plan_private eq 'Y' }">
								<div class="col-sm-3">
									<div class="card mb-3 card_hover">
										<span class="term">${planDTO.plan_term - 1 } 박 ${planDTO.plan_term } 일</span>
										<span class="lock"><i class="fas fa-lock"></i></span>
											<a href="${root }schedule/read?page=0&plan_no=${planDTO.plan_no }">
												<img src="${planDTO.plan_img }" class="card-img-top" height="120" alt="일정보기">
											</a>
										<div class="card-body" style="padding: 15px;">
											<a href="${root }schedule/read?page=0&plan_no=${planDTO.plan_no }">
												<span class="card-title lead ellipsis">${planDTO.plan_title }</span> 
												<span class="card-text ellipsis" style="margin-bottom: 12px;">${planDTO.plan_info }</span>
											</a>
											<ul class="btn-group my-btn-group">
												<li style="display: table-cell; border-right: 1px solid #EFEFEF;">
													<a href="${root }schedule/writeDetail?purpose=modify&plan_no=${planDTO.plan_no }" style="color: green;">
														<i class="far fa-edit"></i> 수정하기
													</a>
												</li>
												<li style="display: table-cell;">
													<button class="delete my-btn-del" value="${planDTO.plan_no }">
														<a href="#" style="color: red;"><i class="fas fa-trash-alt"></i> 삭제하기</a>
													</button>
												</li>
											</ul>
										</div>
									</div>
								</div>
							</c:if>
						</c:forEach>
					</c:otherwise>
				</c:choose>

			</div>
		</div>
	</div>



<!-- 하단 -->
<c:import url="/WEB-INF/view/include/footer.jsp" />


</body>
</html>