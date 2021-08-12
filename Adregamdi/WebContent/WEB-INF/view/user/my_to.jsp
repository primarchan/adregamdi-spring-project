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

<script>
function sub(no) {
	console.log(no);
	$.ajax({
		url : "/user/myToNotification",
		type : "POST",
		dataType : "json",
		data : {"to_no" : no},
		success : function(result) {
			for(var i = 0; i < result.length; i++) {
				var subscriptionDTO = JSON.stringify(result[i]);
				console.log(subscriptionDTO);
				var content = "<div class='card-body item' style='margin:auto; width:90%;'>" +
						      	"<div class='d-flex justify-content-between'>" +
					      		"<span><img class='profile mr-4' alt='프로필' src='${root }images/profile_black.png'>" + result[i].notifi_writer + "</span>" +
					      		"<span>" + result[i].sub_message + "<span class='ml-2' style='color:#8c8c8c;'>("+ result[i].sub_date +")</span></span>" +
					      		"<div>" +
					      			"<button class='btn btn-sm btn-danger float-right px-3' onclick='negative(" + result[i].sub_no + ")'>거절</button>" +
					      			"<button class='btn btn-sm btn-primary float-right px-3 mr-2' onclick='accept(" + subscriptionDTO + ")'>수락</button>" +
					      		"</div>" +
					      	"</div>" +
					      "</div>" +
					      "<hr class='item' style='margin:0;'>";
				$(content).appendTo('.test' + no);
			}
		}
	});
}

function negative(sub_no) {
	console.log(sub_no);
		if(confirm("동행 신청을 거절하시겠습니까?")) {
			$.ajax({
				url : "/user/subCancel",
				type : "POST",
				dataType : "text",
				data : {"sub_no" : sub_no},
				success : function(data) {
					console.log(data);
					alert('동행신청이 거절되었습니다.');
					location.href="/user/my_to"
				}
			});
		}
};	

function accept(subscriptionDTO) {
	console.log(JSON.stringify(subscriptionDTO));
		if(confirm("동행 신청을 수락하시겠습니까?")) {
			$.ajax({
				url : "/together/subAccept",
				type : "POST",
				dataType : "text",
				data : subscriptionDTO,
				success : function(data){
					console.log(data);
					if(data.trim() == 'true'){
						alert('동행신청을 수락하셨습니다.');
						location.href="/user/my_to"						
					}else{
						alert('예기치 못한 오류가 발생했습니다.');
						location.href="/user/my_to"	
					}
				}
			})
		}
};	
	



</script>

</head>
<body>


<!-- 상단 -->
<c:import url="/WEB-INF/view/include/header.jsp"/>



	<div class="container my-top">
		<h3 class="BoardTitle mb-4">
			<b>마이페이지</b>
		</h3>

		<div class="card">
			<div class="card-header my-card-header">
				<a href="${root }user/modify" class="float-right btn btn-success" style="padding: 3px 10px;">회원정보</a>
				<ul class="nav nav-tabs card-header-tabs">
					<li class="nav-item"><a class="nav-link active" href="${root }user/my_to">동행찾기&nbsp
						<c:if test="${myToCount ne '0' }">
							<span class="badge badge-success"> ${myToCount }</span>
						</c:if>
					</a></li>
					<li class="nav-item"><a class="nav-link" href="${root }user/my_page">공유일정&nbsp
						<c:if test="${myPublicCount ne '0' }">
							<span class="badge badge-secondary"> ${myPublicCount }</span>
						</c:if>
					</a></li>
					<li class="nav-item"><a class="nav-link" href="${root }user/my_page_disable">숨긴일정&nbsp 
						<c:if test="${myPrivatCount ne '0' }">
							<span class="badge badge-secondary"> ${myPrivatCount }</span>
						</c:if>
					</a></li>
				</ul>
			</div>

 			<c:choose>
	 			<c:when test="${myToCount eq '0' && mySub eq null }">	
					<div class="row mx-3 my-3">
						<div class="col-sm-12 text-center">
						<div class="jumbotron jumbotron-fluid bg-white" style="padding:2rem 0; margin-bottom:-20px;">
						  <div class="container">
						    <h1 class="display-5">새로운 동행을 찾아보세요!<i class="fas fa-user-friends ml-2"></i></h1>
						    <p class="lead">아래 버튼을 눌러 아름다운 제주여행을 함께할 동행을 찾아보세요!</p>
						  </div>
						</div>
							<a class="btn btn-outline-success btn-lg mb-5" href="${root }together/list">동행 찾기</a>
						</div>
					</div>
				</c:when>
					
					
				<c:otherwise>			
					<div class="row mx-5 my-4">
					<div class="accordion col-sm-12" id="accordionExample">
					<c:if test="${myToCount ne '0' }">
						<div class="mb-2"><i class="fas fa-pencil-alt mr-1"></i>내가만든 동행</div>
					</c:if>
					<c:forEach var="togetherDTO" items="${myTo }" >
						<div class="card px-0 mb-3 shadow-sm rounded">
						    <div class="card-header p-2" id="headingOne">
						      <h2 class="mb-0">
						        <button class="btn btn-link" value="${togetherDTO.to_no }" type="button" data-toggle="collapse" data-target="#${togetherDTO.to_no }" onmousedown="sub(${togetherDTO.to_no }); this.onmousedown=null;"  style="color:black; text-decoration:none; width:91%;">
						          <span class="card_hover d-flex justify-content-between">
							        <span>
							          <li class="mr-2">${togetherDTO.to_title } <span class="ml-2" style="color:#868e96;">[ ${togetherDTO.to_place_name } ]</span>
							          	<c:if test="${togetherDTO.status != 0 && togetherDTO.to_curr < togetherDTO.to_total }">
							          		<span class="ml-2 text-danger"><i class="far fa-comment-dots"></i></span>
							          	</c:if>
							          </li>
						          	</span>
						          	<span>
						          	<c:choose>
						          	  <c:when test="${togetherDTO.to_curr ne togetherDTO.to_total }">
								          <span class="badge badge-pill badge-danger mr-1">&nbsp모집중&nbsp</span>
							          </c:when>
						          	  <c:when test="${togetherDTO.to_curr >= togetherDTO.to_total }">
								          <span class="badge badge-pill badge-secondary mr-1">&nbsp마감&nbsp</span>
							          </c:when>
						          	</c:choose>
							          <span class="badge badge-pill badge-secondary px-2 mr-3"> ${togetherDTO.to_curr } / ${togetherDTO.to_total } </span>
							        </span>
						          </span>
						        </button>
						        <button class="btn btn-sm btn-info float-right mt-1 mr-2"><a href="${root }together/read?content_idx=${togetherDTO.to_no }" class="text-white">게시판으로</a></button>
						      </h2>
						    </div>
							
							<c:choose>
								<c:when test="${togetherDTO.to_curr < togetherDTO.to_total }">
							    	<c:choose>
							    		<c:when test="${togetherDTO.status == 0 }">
							    			<div id="${togetherDTO.to_no }" class="collapse">
												<div class="row mx-5 my-4">
													<div class="col-sm-12 text-center">
														<div class="jumbotron jumbotron-fluid bg-white"
															style="padding: 2rem 0; margin-bottom: -20px;">
															<div class="container">
																<h1 class="display-5">
																	<i class="far fa-paper-plane mr-2"></i>도착한 동행 신청이
																	없습니다..
																</h1>
																<p class="lead">기다리시면 마음이 맞는 새로운 동행자가 나타날 거예요!</p>
															</div>
														</div>
													</div>
												</div>
											</div>
							    		</c:when>
							    		<c:otherwise>
										   	<div id="${togetherDTO.to_no }" class="collapse test${togetherDTO.to_no }">
										
								    		</div>
							    		</c:otherwise>
							    	</c:choose>
							    </c:when>
							    <c:when test="${togetherDTO.to_curr == togetherDTO.to_total  }">
							    <div id="${togetherDTO.to_no }" class="collapse">
							    	<div class="row mx-5 my-4">
										<div class="col-sm-12 text-center">
										<div class="jumbotron jumbotron-fluid bg-white" style="padding:2rem 0; margin-bottom:-20px;">
										  <div class="container">
										    <h1 class="display-5"><i class="fas fa-child mr-2"></i>동행 인원이 가득 찼습니다.</h1>
				    					    <p class="lead">새로운 동행 신청을 받으려면 동행 인원을 조정하세요.</p>
									      </div>
										</div>
										</div>
									</div>
								</div>
							    </c:when>
							    <c:when test="${togetherDTO.status eq 0 }">
 									<div id="${togetherDTO.to_no }" class="collapse">
								    	<div class="row mx-5 my-4">
											<div class="col-sm-12 text-center">
											<div class="jumbotron jumbotron-fluid bg-white" style="padding:2rem 0; margin-bottom:-20px;">
											  <div class="container">
											    <h1 class="display-5"><i class="far fa-paper-plane mr-2"></i>도착한 동행 신청이 없습니다..</h1>
					    					    <p class="lead">기다리시면 마음이 맞는 새로운 동행자가 나타날 거예요!</p>
										      </div>
											</div>
											</div>
										</div>
									</div>
							    </c:when>
						    </c:choose>
						  </div>		  
					
					</c:forEach>
					</div>
						<c:if test="${mySub ne null }">
							<div class="accordion col-sm-12" id="accordionExample">
							<div class="my-2"><i class="far fa-paper-plane mr-1"></i>신청한 동행</div>
							<c:forEach var="togetherDTO" items="${mySub }" >
								<div class="card px-0 mb-3 shadow-sm rounded">
								    <div class="card-header p-2" id="headingOne" style="background-color:rgba(255,220,163,0.3);">
								      <h2 class="mb-0">
								        <button class="btn btn-link" value="${togetherDTO.to_no }" type="button" data-toggle="collapse" data-target="#${togetherDTO.to_no }" style="color:black; text-decoration:none; width:91%;">
								         <a href="${root }together/read?content_idx=${togetherDTO.to_no }">
								          <span class="card_hover d-flex justify-content-between">
									        <span>
									          <li class="mr-2">${togetherDTO.to_title } <span class="ml-2" style="color:#868e96;">[ ${togetherDTO.to_place_name } ]</span></li>
								          	</span>
								          	<span>
								          	<c:choose>
								          	  <c:when test="${togetherDTO.status eq 0 }">
										          <span class="badge px-2 py-1 badge-secondary mr-1">&nbsp신청대기&nbsp</span>
									          </c:when>
								          	  <c:when test="${togetherDTO.status eq 1 }">
										          <span class="badge px-2 py-1 badge-pill badge-success mr-1">&nbsp참가승인&nbsp</span>
									          </c:when>
								          	</c:choose>
									          <span class="badge badge-pill badge-secondary px-2 mr-3"> ${togetherDTO.to_curr } / ${togetherDTO.to_total } </span>
									        </span>
								          </span>
								          </a>
								        </button>
								        <button class="btn btn-sm btn-info float-right mt-1 mr-2"><a href="${root }together/read?content_idx=${togetherDTO.to_no }" class="text-white">게시판으로</a></button>
								      </h2>
								    </div>
						 		</div>
						 	</c:forEach>
						 	</div>
						</c:if>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
  

<!-- 하단 -->
<c:import url="/WEB-INF/view/include/footer.jsp" />


</body>
</html>