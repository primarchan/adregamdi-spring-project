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
<title>어드레 감디 | 회원탈퇴</title>

<!-- Font Awesome CDN -->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.3/css/all.css" integrity="sha384-SZXxX4whJ79/gErwcOYf+zWLeJdY/qpuqC4cAa9rOGUstPomtqpuNWT9wdPEn2fk" crossorigin="anonymous">

<!-- Bootstrap CDN -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>

<!-- CSS import -->
<link href="${root }css/user.css" rel="stylesheet" type="text/css">


</head>
<body>



<div class="container my-top">
		<div class="row">
			<div class="col-sm-3"></div>
			<div class="col-sm-6">
				<div class="card shadow">
					<header class="card-header">
						<a href="${root }user/modify" class="float-right btn btn-outline-success btn-sm mt-2">이전으로</a>
						<h4 class="card-title mt-2 warning-color">회원탈퇴</h4>
					</header>
					<div class="card-body back-color">
						<p class="text-danger text-center pb-2"># 회원탈퇴 후 모든 정보는 복구가 어렵습니다.</p>
						
						<form:form action='${root }user/delete_proc' method='post' modelAttribute="deleteUserDTO">
							
							<c:if test="${loginUserDTO.user_provider ne 2 }">
								<div class="form-group">
									<div class="input-group">
										<div class="input-group-prepend">
											<span class="input-group-text"><i class="fas fa-user"></i></span>
										</div>
										<form:input path="user_id" class='form-control' placeholder="ID" />
									</div>
								</div>
								<div class="form-group">
									<div class="input-group">
										<div class="input-group-prepend">
											<span class="input-group-text"><i class="fas fa-key"></i></span>
										</div>
										<form:password path="user_pw" class='form-control' placeholder="비밀번호" />
									</div>
									<form:errors path='user_pw' class="small warning-color" />
								</div>
							</c:if>
							
							<c:if test="${loginUserDTO.user_provider eq 2 }">
								<div class="form-group">
									<div class="input-group">
										<div class="input-group-prepend">
											<span class="input-group-text"><i class="fas fa-at"></i></span>
										</div>
										<form:input path="user_email" class='form-control' placeholder="useremail@email.com" />
									</div>
								</div>
								<div class="form-group">
									<div class="input-group">
										<div class="input-group-prepend">
											<span class="input-group-text"><i class="fas fa-mobile-alt"></i></span>
										</div>
										<form:input path="user_phone" class='form-control' placeholder="연락처" />
									</div>
									<form:errors path='user_phone' class="small warning-color" />
								</div>
							</c:if>
							
							
							<div class="form-group">
								<div class="text-right">
									<form:button class='btn btn-danger'>회원탈퇴</form:button>
								</div>
							</div>

						</form:form>
					</div>
				</div>
			</div>
			<div class="col-sm-3"></div>
		</div>
	</div>



</body>
</html>