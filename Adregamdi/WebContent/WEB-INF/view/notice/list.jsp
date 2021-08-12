<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:url var="root" value="${pageContext.request.contextPath }/" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>어드레감디 | 공지사항</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>

<!-- Font Awesome CDN -->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.3/css/all.css" 
integrity="sha384-SZXxX4whJ79/gErwcOYf+zWLeJdY/qpuqC4cAa9rOGUstPomtqpuNWT9wdPEn2fk" 
crossorigin="anonymous">

<!-- CSS import -->
<link href="${root }css/notice.css" rel="stylesheet" type="text/css">
<script type="text/javaScript">
	function WriteDoc(){
		location.href='${root}notice/write';
	}
	
	//검색 호출 자바스크립트
	function SearchBoard(){
		let searchTypeVal=$('#searchType').val(); 
		let keywordVal = $('#keywords').val(); // alert(keywordVal);
		if(keywordVal == ""){
			alert("검색어를 입력해주세요!");
		} else {
			location.href="${root}notice/listSearch?searchType=" + searchTypeVal + "&keywords=" + keywordVal;
		}
	}
</script>
</head>
<body>
	<!-- Header Import -->
	<c:import url="/WEB-INF/view/include/header.jsp" />
	<!-- 공지사항 리스트 -->
	<div class="container" style="margin-top: 150px; margin-bottom: 150px">
		<h3 class="BoardTitle">
			<b>공지사항</b>
		</h3>
		<hr>
		<!-- 검색 폼 -->
		<nav class="navbar navbar-light bg-light" style="margin-top:-5px;">
		 <c:if test="${search_done == 1}">
		  키워드&nbsp;:&nbsp;${keyword} 검색 결과&nbsp; - &nbsp; 총 &nbsp;${search_res_count} &nbsp; 개 입니다.
		 </c:if>
		  <a class="navbar-brand"></a>
		  <form class="form-inline">
		    <select id="searchType" class="form-control" style="margin-right:8px;">
		    	<option id="object" value="object">제목</option>
		    	<option id="objcon" value="objcon">제목 + 내용</option>
		    </select>
		    <input class="form-control mr-sm-2" id="keywords" name="keywords" type="text" aria-label="Search" onKeypress="javascript:if(event.keyCode==13){SearchBoard();event.preventDefault();}">
		    <button type="button" class="btn btn-secondary" onClick="SearchBoard();">
		    	<i class="fas fa-search"></i>
		    </button>
		  </form>
		</nav>
		<table class="table table-hover">
			<thead>
				<tr>
					<th class="text-center" style="width: 8%">글번호</th>
					<th class="text-center" style="width: 55%">글제목</th>
					<th class="text-center" style="width: 10%">작성자</th>
					<th class="text-center" style="width: 8%">조회수</th>
					<th class="text-center" style="width: 15%">작성날짜</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="NoticeDTO" items="${contentList}">
					<tr>
						<td class="text-center">${NoticeDTO.notice_rownum }</td>
						<td class="text-center">
							<a style="color: black;" href="${root}notice/read?content_idx=${NoticeDTO.notice_no}">${NoticeDTO.notice_title }</a>
						</td>
						<td class="text-center">${NoticeDTO.content_notice_user_no }</td>
						<td class="text-center">${NoticeDTO.notice_cnt }</td>
						<td class="text-center">${NoticeDTO.notice_date }</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<!-- 페이징 처리 -->
		<div class="pageNevigation" style="margin-top: 50px;">
			<ul class="pagination justify-content-center">
				<c:choose>
			      <c:when test="${search_done == 1}">
			       <c:choose>
			         <c:when test="${pageDTO.prevPage <= 0 }"></c:when>
			         <c:otherwise>
						<li class="page-item"><a href="${root}notice/listSearch?keywords=${keyword}&searchType=${searchType}&page=${pageDTO.prevPage}" class="page-link">이전</a></li>
					</c:otherwise>
			       </c:choose>
			      </c:when>
			      <c:otherwise>
			       <c:choose>
			        <c:when test="${pageDTO.prevPage <= 0 }"></c:when>
					<c:otherwise>
						<li class="page-item"><a href="${root}notice/list?page=${pageDTO.prevPage}" class="page-link">이전</a></li>
					</c:otherwise>
				   </c:choose>
			      </c:otherwise>
			    </c:choose>
			    <c:forEach var="idx" begin="${pageDTO.min}" end="${pageDTO.max}">
			      <c:choose>
			        <c:when test="${search_done == 1}">
			          <c:choose>
			            <c:when test="${idx == pageDTO.currentPage}">
			              <li class="page-item active"><a href="${root }notice/listSearch?keywords=${keyword}&searchType=${searchType}&page=${idx}" class="page-link">${idx}</a></li>
			            </c:when>
			            <c:otherwise>
						  <li class="page-item"><a href="${root }notice/listSearch?keywords=${keyword}&searchType=${searchType}&page=${idx}" class="page-link">${idx}</a></li>
						</c:otherwise>
			          </c:choose>
			        </c:when>
			        <c:otherwise>
			           <c:choose>
			             <c:when test="${idx == pageDTO.currentPage}">
			               <li class="page-item active"><a href="${root }notice/list?page=${idx}" class="page-link">${idx}</a></li>
			             </c:when>
			             <c:otherwise>
			               <li class="page-item"><a href="${root }notice/list?page=${idx}" class="page-link">${idx}</a></li>
			             </c:otherwise>
			           </c:choose>
			        </c:otherwise>
			      </c:choose>
			    </c:forEach>
			    <c:choose>
			      <c:when test="${search_done == 1}">
			        <c:choose>
			          <c:when test="${pageDTO.max >= pageDTO.pageCount }"></c:when>
			          <c:otherwise>
			            <li class="page-item"><a href="${root}notice/listSearch?keywords=${keyword}&searchType=${searchType}&page=${pageDTO.nextPage}" class="page-link">다음</a></li>
			          </c:otherwise>
			        </c:choose>
			      </c:when>
			      <c:otherwise>
			        <c:choose>
			          <c:when test="${pageDTO.max >= pageDTO.pageCount }"></c:when>
			          <c:otherwise>
						<li class="page-item"><a href="${root}notice/list?page=${pageDTO.nextPage}" class="page-link">다음</a></li>
					  </c:otherwise>  
			        </c:choose>
			      </c:otherwise>
			    </c:choose>
			</ul>
		</div>
		<div class="text-right">
			<c:if test="${loginUserDTO.userLogin == true && loginUserDTO.user_provider == 0}">
				<!-- user_provider == 0 일 때 글쓰기 버튼 노출 -->
				<a href="${root}notice/write" class="btn btn-info" style="color: white">글 쓰 기</a>
			</c:if>
		</div>
	</div>
	<!-- Footer -->
	<c:import url="/WEB-INF/view/include/footer.jsp" />
</body>
</html>