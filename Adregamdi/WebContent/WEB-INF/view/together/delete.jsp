<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!-- 절대 경로 설정 -->
<c:set var="root" value="${pageContext.request.contextPath }/" />
  
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>어드레 감디 | 같이가치</title>
  <!-- Bootstrap CDN -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>

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
  </style>
  
</head>
<body>
<!-- 절대 경로 설정 -->
<c:import url="/WEB-INF/view/include/header.jsp" />
  <div class="container" style="margin-top: 100px;">
    <h3 class="InputSubject">
      <b>${togetherDeleteDTO.to_title}</b>
    </h3>
    <h5>&nbsp;&nbsp;&nbsp;&nbsp;${togetherDeleteDTO.to_date}</h5>
    <hr>
    <div class="row">
      <div class="col-sm-8">
        <div class="panel">
          <div class="panel-body">
            <form:form action="${root}together/deleteProc?content_idx=${togetherDeleteDTO.to_no}" 
            method="post" modelAttribute="tmptogetherDeleteDTO">
            	<div class="form-group row">
            	  <form:label path="to_user_pw" class="text-sm-right"><b>비밀번호</b></form:label>
            		<div class="col-sm-3">
            		  <form:password path="to_user_pw" class="form-control" />
            		</div>
            	  <button class="btn btn-danger">삭제하기</button>
            	</div>
            </form:form>
          </div>
        </div>
      </div>
    </div>
  </div>
</body>
</html>