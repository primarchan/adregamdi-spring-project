<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 절대 경로 설정 -->
<c:set var="root" value="${pageContext.request.contextPath }/" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지역별 관광지</title>

<!-- Bootstrap CDN -->
<link rel="stylesheet"	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
<script	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>

<script type="text/javascript" src="${root }js/spot.js" ></script>

<!-- x 아이콘 -->
<link rel="icon" type="image/x-icon"  />
<script src="https://use.fontawesome.com/releases/v5.15.3/js/all.js" ></script>

<link href="${root }css/spot.css" rel="stylesheet">
<link rel="stylesheet" href="${root }css/styles.css">

</head>

<body>
	<!-- 상단 메뉴바  -->
	<c:import url="/WEB-INF/view/include/header.jsp" />

	<!-- Top 3 출력 -->
	<section class="page-section bg-light" id="portfolio">		
		<div class="container"
			style="margin-top: 150px; margin-bottom: 150px;">
			<div class="text-center">
				<h2 class="section-heading text-uppercase">제주 지역 탐방 - BEST 3</h2>
				<h3 class="section-subheading text-muted">제주도는 제주시, 서귀포시로 크게 나뉠
					수 있습니다. 각 지역의 Top3 유명지를 소개합니다.</h3>
			</div>
			<div id="best_view" class="row">
				<c:forEach var="i" begin="0" end="2" >
					<div class="col-lg-4 col-sm-6 mb-4">
						<div class="portfolio-item">
							<a class="portfolio-link" data-toggle="modal" href="#portfolioModal" onclick="best_detail(${i});">
								<div class="portfolio-hover">
									<div class="portfolio-hover-content">
										<i class="fas fa-plus fa-3x"></i>
									</div>
								</div> 
								<img class="img-fluid photo" id="bestPhoto${i}" src="" alt="...">
							</a>
							<div class="portfolio-caption">
								<div style="font-color:blue;">
									<i class="far fa-hand-point-right" style="color: blue;"></i>
										 Top ${i+1 }
								</div>
								<div id="bestTitle${i}" class="portfolio-caption-heading"></div>
								<div id="bestAddr${i}"
									class="portfolio-caption-subheading text-muted"></div>
								<span style="display:none" id="bestContentId${i }" ></span>
								<span style="display:none" id="bestContentTypeId${i }" ></span>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>
		</div>


		<hr style="width: 80%;">

		<!-- 전체 여행지 보기 -->
		<input type="hidden" id="pageMaker" value="${pageMaker }"> 
		<input type="hidden" id="sigunguCode" value="${sigunguCode }"> 
		<input type="hidden" id="contentTypeId" value="${contentTypeId }">
		<input type="hidden" id="currentPage" value="${pageMaker.currentPage }">
		<div class="container" style="margin-top: 100px;">
			<div class="text-center">
				<h2 class="section-heading text-uppercase">제주 모든 여행지를 한눈에...</h2>
				<h3 class="section-subheading text-muted">수많은 제주의 아름다운 여행지를 취향에
					맞게 선택해보자. 368개의 크고 작은 오름을 비롯하여 눈 돌리면 어디에서나 마주치는 한라산 그리고 푸른 바다…. 제주의
					보석 같은 여행지가 여러분의 선택을 기다린다.</h3>
			</div>


			<!-- 검색 -->
			<div class="input-group" style="background: #258fff;">
				<input type="text" class="form-control search-menu"
					id="search-field" placeholder="검색..." style="background: #f9f9f9;">
				<div class="input-group-append" id="btn-search">
					<!-- 여기에요 여기!! -->
					<span class="input-group-text" style="background: #e9e9e9;">
						<i class="fa fa-search" aria-hidden="true"></i>
					</span>
				</div>
			</div>

			<br> <br>


			<!-- 전체 내용 출력 -->
			<div id="total_view" class="row">
				<c:forEach var="i" begin="0" end="8" >
					<div class="col-lg-4 col-sm-6 mb-4">
						<div class="portfolio-item">
							<a class="portfolio-link" data-toggle="modal" href="#portfolioModal" onclick="detail(${i});">
								<div class="portfolio-hover">
									<div class="portfolio-hover-content">
										<i class="fas fa-plus fa-3x"></i>
									</div>
								</div> 
								<img class="img-fluid photo" id="photo${i}" src="" alt="...">
							</a>
							<div class="portfolio-caption">
								<div id="title${i}" class="portfolio-caption-heading ellipsis"></div>
								<div id="addr${i}"
									class="portfolio-caption-subheading text-muted"></div>
								
								<span style="display:none" id="contentId${i }" ></span>
								<span style="display:none" id="contentTypeId${i }" ></span>
							</div>
							<div class="icon_outside" >
		                        <div id="like-btn" class="icon" style="margin-right: 60px;">
		                             <a  id="likeSendContentId${i }" onClick="likeProc(${i })" >
		                             	<i class="far fa-thumbs-up aTagSet" style="font-size:30px;"></i>
		                             </a>
		                             <!-- <a href="#"><i class="fas fa-thumbs-up" style="font-size:30px;"></i></a> -->
		                             <span style="font-size: 10px;">좋아요</span>
		                             <span id="likeCnt${ i }" style="font-size: 10px;"></span><br>
		                         </div>
		                         <div class="icon">
		                             <a id="reviewSendContentId${i }" href="">
		                             	<i class="far fa-file-alt" style="font-size:30px;"></i>
		                             </a>
		                             <span style="font-size: 10px;">리뷰</span>        
		                             <span id="reviewCnt${i }" style="font-size: 10px;" ></span><br>
		                         </div>
		                     </div>
						</div>
					</div>
				</c:forEach>
			</div>

			<!-- 검색어를 통한 결과값 출력 -->
			<div id="search_view" class="row">			
			</div>


			<!-- 페이지 처리 -->
			<div id="total_page" class="row text-center"
				style="margin: 1rem auto; padding-right: 5%; padding-left: 5%">
				<div class="col-sm-12">
					<ul class="pagination" id="pagination-demo">
						<c:if test="${pageMaker.prev }">
							<li class="paginate_button previous">
								<a href="${pageMaker.min -1 }">&laquo;</a>
							</li>
						</c:if>
						<c:forEach var="num" begin="${pageMaker.min }" end="${pageMaker.max }">
							<li class="paginate_button ${pageMaker.currentPage == num ? 'active':'' }">
								<a href="${num }"><button class="pageBtn" style="outline:0; border:0; background-color: transparent !important; font-size:13px;">${num}</button> </a>
							</li>
						</c:forEach>
						<c:if test="${pageMaker.next }">
							<li class="paginate_button next"><a
								href="${pageMaker.max +1 }">&raquo;</a></li>
						</c:if>
					</ul>
				</div>
				<form id='actionForm' action="/spot/main" method='get'>
					<input type='hidden' name='currentPage' value='${pageMaker.currentPage }'> 
					<input type="hidden" name="sigunguCode" id="sigu" value="${sigunguCode }" /> 
					<input type="hidden" name="contentTypeId" id="cont" value="${contentTypeId }" />
				</form>
			</div>
			
			
		</div>
	</section>




	<!-- 1개 클릭 시 세부사항 -->
	<div class="portfolio-modal modal fade center" id="portfolioModal"
		tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="close-modal" data-dismiss="modal">
					<img src="${root }images/spot/close-icon.svg" alt="Close modal" />
				</div>
				<div class="container">
					<div class="row justify-content-center">
						<div class="col-lg-8">
							<div class="modal-body">
								<h2 id="modalTitle"></h2>
								<p id="modalAddr" class="item-intro text-muted"></p>
								<img id="modalPhoto" class="img-fluid d-block mx-auto" src=""
									alt="..." />
								<!-- <p id="modalOverview"></p> -->
								<ul class="details">
								</ul>
								<a id="detailBtn" class="btn btn-info" type="button" href="">
									<i class="far fa-file-alt"></i> 자세히 보기
								</a>
								<button class="btn btn-primary" data-dismiss="modal" type="button">
									<i class="fas fa-times mr-1"></i> 닫기
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 하단 -->
	<c:import url="/WEB-INF/view/include/footer.jsp" />

	<!-- Bootstrap core JS-->
	<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>