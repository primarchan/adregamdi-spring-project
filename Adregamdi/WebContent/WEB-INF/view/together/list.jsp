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
    
    .table a:link { color: black; text-decoration: none;}

		.table a:visited { color: black; text-decoration: none;}

		.table a:hover { color: black; text-decoration: underline;}
    
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
	<c:import url="/WEB-INF/view/include/header.jsp"/>
	
	<div class="container" style="margin-top: 150px; margin-bottom: 150px;">
		<h3 class="BoardTitle">
			<b>같이가치</b>
		</h3>
		<hr>
		<br>
		<table class="table table-hover">
			<thead>
				<tr>
					<th class="text-center" style="width : 20%">동행 제목</th>
					<th class="text-center" style="width : 20%">동행할 장소</th>
					<th class="text-center" style="width : 12%">동행할 날짜</th>
					<th class="text-center" style="width : 8%">모집인원</th>
					<th class="text-center" style="width : 8%">작성자</th>
					<th class="text-center" style="width : 12%">작성일</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="TogetherDTO" items="${contentList}">
					<tr>
						<td class="text-left">
							<c:choose>
								<c:when test="${TogetherDTO.to_curr != TogetherDTO.to_total }">
									<span class="badge badge-pill badge-danger mr-2">모집중</span>
								</c:when>	
								<c:when test="${TogetherDTO.to_curr == TogetherDTO.to_total }">
									<span class="badge badge-pill badge-secondary mr-2">마감</span>
								</c:when>	
							</c:choose>
							<a href="${root}together/read?content_idx=${TogetherDTO.to_no}">${TogetherDTO.to_title }</a>
						</td>
						<td class="text-center">${TogetherDTO.to_place_name }</td>
						<td class="text-center">${TogetherDTO.to_meet }</td>
						<td class="text-center">${TogetherDTO.to_curr }/${TogetherDTO.to_total }</td>
						<td class="text-center">${TogetherDTO.to_writer}</td>
						<td class="text-center">${TogetherDTO.to_date }</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div class="pageNevigation" style="margin-top: 50px;">
		  <ul class="pagination justify-content-center">
				<c:choose>
					<c:when test="${pageDTO.prevPage <= 0 }">
						
					</c:when>
					<c:otherwise>
						<li class="page-item">
							<a href="${root}together/list?page=${pageDTO.prevPage}" class="page-link">이전</a>
						</li>
					</c:otherwise>
				</c:choose>
				<c:forEach var="idx" begin="${pageDTO.min}" end="${pageDTO.max}">
					<c:choose>
						<c:when test="${idx == pageDTO.currentPage}">
						<li class="page-item active">
							<a href="${root }together/list?page=${idx}" class="page-link">${idx}</a>
						</li>
						</c:when>
						<c:otherwise>
							<li class="page-item">
								<a href="${root }together/list?page=${idx}" class="page-link">${idx}</a>
							</li>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				<!-- 맨 마지막일 경우 다음페이지를 비활성화 시킴 -->
				<c:choose>
					<c:when test="${pageDTO.max >= pageDTO.pageCount }">
						
					</c:when>
					<c:otherwise>
						<li class="page-item">
							<a href="${root}together/list?page=${pageDTO.nextPage}" class="page-link">다음</a>
						</li>
					</c:otherwise>
				</c:choose>
			</ul>
		</div>
		  <div class="text-right">
		    <c:if test="${loginUserDTO.userLogin == true}">
      		  <a href="${root}together/write" class="btn btn-info">새로운 동행 만들기</a>
      		</c:if>  
    	  </div>
	 </div>
   <!-- Footer -->
	 <c:import url="/WEB-INF/view/include/footer.jsp" />
</body>
</html>
	
	