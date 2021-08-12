<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value="${pageContext.request.contextPath }/" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>어드레 감디 | 로그인</title>

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

<div class="login-img">
	<div class="container h-100 d-flex align-items-center">
		<div class="row w-100">
			<div class="col-sm-6">
				<div class="card back-color">
					<div class="card-body">
						<c:if test="${param.fail eq 'true'}">
							<div class="alert alert-danger">
								<h4>로그인 실패!</h4>
								<p>아이디 비밀번호를 확인해주세요.</p>
							</div>
						</c:if>
						<div class="text-center">
							<a href="${root}"><img class="mb-4" src="${root }images/logo.png" height="75"></a>
						</div>
						<form:form action="${root }user/login_proc" method="post"
							modelAttribute="tmpLoginUserDTO">
							<div class="form-group">
								<div class="input-group">
                        			<div class="input-group-prepend">
                         				<span class="input-group-text"><i class="fas fa-user"></i></span>
                        			</div>
									<form:input path="user_id" class="form-control" placeholder="ID" name="user_id"/>
                     			 </div>
								<form:errors path="user_id" class="small warning-color" />
							</div>
							<div class="form-group">
								<div class="input-group">
                        			<div class="input-group-prepend">
                         				<span class="input-group-text"><i class="fas fa-key"></i></span>
                        			</div>
									<form:password path="user_pw" class="form-control" placeholder="비밀번호" />
                     			 </div>
								<form:errors path="user_pw" class="small warning-color" />
							</div>
							<div class="form-group text-center" style="padding-top: 20px">
								<form:button class="btn btn-info btn-sm btn-block">로그인</form:button>
								<a href="${root }user/join" class="btn btn-success btn-sm btn-block">회원가입</a>
							</div>
								<hr>
							<div class="form-group text-right">	
								<a href="${root}user/naver_login"><img width="120" height="40" src="http://static.nid.naver.com/oauth/small_g_in.PNG"/></a>
							</div>
						</form:form>
					</div>
				</div>
			</div>
			<div class="col-sm-6"></div>
		</div>
	</div>
</div>
	
	
	
</body>
</html>