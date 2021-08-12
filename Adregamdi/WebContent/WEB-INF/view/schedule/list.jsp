<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:url var="root" value="${pageContext.request.contextPath }/" />
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!-- Bootstrap CDN -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>
	<!-- flatpickr -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
	<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
	<!-- FontAwesome -->
	<link href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" rel="stylesheet">
	<script>
		$(function() {
			$('#newPlan').click(function(){
				if($('#user_no').val() == 0) {
					alert('로그인을 하셔야 글쓰기가 가능합니다.');
					location.href = '${root }user/login'
				}
				$('#newPlanModal').modal("show");
			});
			
			$("#plan_date").flatpickr({
				mode: "range",
			  minDate: "today",
			  inline: true,
			  static : true
			});
			
			$("input:checkbox").on('click', function() {
				if ( $(this).prop('checked') ) {
					$('#plan_private').val('Y');
				} else {
					$('#plan_private').val('N');
				}
			});
			
			$("#submit").click(function(){
				if($("#plan_title").val() == '' || $("#plan_date").val() == '') {
			  	alert("내용을 입력해주세요!");
			    $("#plan_title").focus();
			  } else {
				  var term = 0;
			  	var date = $("#plan_date").val();
			    var startDate = new Date(parseInt(date.substr(0,4)), parseInt(date.substr(5,2))-1, parseInt(date.substr(8,2)));
			    if(date.length > 10) {
			    	var endDate = new Date(parseInt(date.substr(14,4)), parseInt(date.substr(19,2))-1, parseInt(date.substr(22,2)));
			      term = (endDate.getTime() - startDate.getTime()) / (1000*60*60*24)+1;
			    } else {
			    	term = 1;
			    }
			  	document.getElementById("plan_term").value= term;
			  	$("#writeNewPlan").submit();
			  }
			});
		});
	</script>
	<style>
		@font-face {
	    font-family: 'Bazzi';
	    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_20-04@2.1/Bazzi.woff') format('woff');
	    font-weight: normal;
	    font-style: normal;
		}
		
  	body {
      font-family: 'Bazzi';
    }
		
		.card-header {
			padding : 20px;
		}
		
		.card-header p{
			margin : 0;
		}
		
		.card_hover {
			position: relative;
		}
		
		.card_hover span {
			position: absolute;
			top: 0;
			left: 0;
			background: rgba(0, 0, 0, 0.5);
			color: white;
			padding: 3px 6px;
			border-radius: 3px;
		}
		
		.card_hover .ellipsis {
			white-space: normal;
			display: -webkit-box;
			-webkit-line-clamp: 1;
			-webkit-box-orient: vertical;
			overflow: hidden;
		}
		
		.modal-footer {
			position: relative;
		}
		.modal-footer input {
    	display: none;
    }
  	
  	.modal-footer label {
    	display: inline-block;
    	width: 98px;
    	height: 38px;
    	padding: 0;
    	margin: 0;
    	text-align: center;
    	cursor: pointer;
    	position: absolute;
    	top: 16px;
    	left: 12px;
    	border-radius: 38px;
    	background: #3cf065;
    }
    
    .modal-footer label::before {
    	content: '';
    	font-size: 16px;
    	display: block;
    	width: 45px;
    	height: 30px;
    	position: absolute;
    	top: 4px;
    	left: 4px;
    	background: #ffffff;
    	line-height: 32px;
    	border-radius: 32px;
    	transition: 0.3s;
    	z-index: 999;
    }
   	
    .modal-footer input:checked + label:before {
    	transform: translateX(45px);
    }
    
    .modal-footer input:checked + label {
    	background: #dc3545;
    }
  	
  	.modal-footer .first {
  		position: absolute;
  		top: 7px;
  		left: 10px;
  		color: #ffffff;
  	}
  	
  	.modal-footer .second {
  		position: absolute;
  		top: 7px;
  		left: 58px;
  		color: #ffffff;
  	}
	</style>
	<title>Document</title>
</head>
<body>
	<!-- Header -->
  <c:import url="/WEB-INF/view/include/header.jsp"/>
  
  <!-- Main -->
		
		<!-- Content -->
		<div class="container" style="margin-top:150px; margin-bottom:150px"> 
			<div class="card shadow">
			  
			  <div class="card-header">
			  	<h3>여행 일정 공유</h3>
			  	<p>나만의 여행 일정을 만들고 공유해보세요!</p>
			  </div>
			 	
			 	<div class="card-body">
				  <div class="row mx-3 my-3 content-box">
						<c:forEach var="planDTO" items="${planList }" >
								<div class="col-sm-3">
									<div class="card mb-3 card_hover">
										<span>${planDTO.plan_term - 1 } 박 ${planDTO.plan_term } 일</span>
										<c:choose>
											<c:when test="${planDTO.plan_img ne null }">
												<img src="${planDTO.plan_img }" class="card-img-top" height="120" alt="일정보기">
											</c:when>
											<c:when test="${planDTO.plan_img eq null }">
												<img src="${root }images/schedule/thumbnail.jpg" class="card-img-top" height="120" alt="일정으로">
											</c:when>
										</c:choose>
										<div class="card-body" style="padding: 15px;">
											<p class="card-title lead ellipsis">${planDTO.plan_title }</p>
											<p class="card-text ellipsis">${planDTO.plan_info }</p>
											<ul class="btn-group" style="display: table; margin: 0; padding: 10px 0; width: 100%; border-radius: 5px; border: 1px solid #EFEFEF;  text-align: center; list-style: none;">
												<li style="display: table-cell;">
													<a href="${root }schedule/read?page=${pageDTO.currentPage }&plan_no=${planDTO.plan_no }"><i class='fas fa-1x fa-info-circle'></i> 자세히보기</a>
												</li>
											</ul>
										</div>
									</div>
								</div>
						</c:forEach>
					</div> 
				  
					<div class="d-none d-md-block" style="margin-top:20px;">
				 		<ul class="pagination justify-content-center">
				  		<c:if test="${pageDTO.prevPage!=0 }">
				  			<li class="page-item"><a class="page-link" href="${root }schedule/list?page=${pageDTO.prevPage}">이전</a></li>
				  		</c:if>
				  		<c:forEach var="idx" begin="${pageDTO.min }" end="${pageDTO.max }">
				  			<c:choose>
				  				<c:when test="${pageDTO.currentPage==idx }">	
				  					<li class="page-item active"><a class="page-link" href="${root }schedule/list?page=${idx }">${idx }</a></li>
				  				</c:when>
				  				<c:otherwise>
				  					<li class="page-item"><a class="page-link" href="${root }schedule/list?page=${idx }">${idx }</a></li>
				  				</c:otherwise>
				  			</c:choose>
				  		</c:forEach>
				  		<c:if test="${pageDTO.nextPage!=pageDTO.pageCount && pageDTO.pageCount > 10}">
				  			<li class="page-item"><a class="page-link" href="${root }schedule/list?page=${pageDTO.nextPage}">다음</a></li>
				  		</c:if>
				  	</ul>
					</div>
				  
				  <div class="text-right" style="margin-top:20px;">
				  	<button class="btn btn-primary" id="newPlan">여행 일정 만들기</button>
				  </div>
			  </div>
			  
		  </div>
	  </div>
  	
  	<!-- Modal -->
	  <div class="modal" id="newPlanModal">
	  	<div class="modal-dialog" style="width:342px;">
	  		<div class="modal-content">
	  			<div class="modal-header">
	  				<h4>새로운 일정 만들기</h4>
	  				<button type="button" class="close" data-dismiss="modal" aria-label="close">×</button>
	  			</div>
	  			<form id="writeNewPlan" action="${root }schedule/write" method="post">
	  				<div class="modal-body">
	  					<input type="hidden" id="user_no" name="user_no" value="${loginUserDTO.user_no }" >
	  					<input type="hidden" id="plan_term" name="plan_term">
	  					<input type="hidden" name="plan_info" value="내용을 입력해주세요.">
	  					<input type="hidden" id="plan_private" name="plan_private" value="N">
	  					<input type="hidden" name="plan_img" value="/images/schedule/thumbnail.jpg">
	  					<div class="form-group">
	  						<label for="plan_title">일정 제목</label>
	  						<input type="text" class="form-control" id="plan_title" name="plan_title" style="width:100%">
	  					</div>
	  					<div class="form-group">
	  						<label for="plan-date">여행 기간</label>
	  						<input type="text" class="form-control" id="plan_date" name="plan_date" style="width:100%" readonly>
	  					</div>
	  				</div>
	  			</form>
	  			<div class="modal-footer">
	  				<input type="checkbox" id="switch">
	  				
		    		<label for="switch">
		    			<span class="first">비공개</span>
		    			<span class="second">공개</span>
		    		</label>
	  				<button class="btn btn-primary" type="button" id="submit">만들기</button>
	          <button class="btn btn-danger" type="button" data-dismiss="modal">취소</button>
	  			</div>
	  		</div>
	  	</div>
	  </div>
	  
  <!-- Footer -->
  <c:import url="/WEB-INF/view/include/footer.jsp" />
  
</body>
</html>