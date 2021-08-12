<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 절대 경로 설정 -->
<c:set var="root" value="${pageContext.request.contextPath }/" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 페이지</title>
<!-- Bootstrap CDN -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>
<script src="https://use.fontawesome.com/releases/v5.15.3/js/all.js"></script>

<link href="${root }css/review.css" rel="stylesheet">
<script type="text/javascript" src="${root }js/review.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9cd7ccda94b3121198366e34313ed8c0"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9cd7ccda94b3121198366e34313ed8c0&libraries=services,clusterer,drawing"></script>

</head>
<body>
	<!-- 상단 헤더 -->
	<c:import url="/WEB-INF/view/include/header.jsp" />

	<!-- 1개 클릭 시 세부사항 -->
	<div class="container bg-light" style="margin-top: 120px; margin-bottom: 150px; font-color: black;">
		<table id="table">
			<tr>
				<td class="left">
					<div class="text-center">
						<h1 class="section-heading" style="font-size: 50px;"><b>${information[1] }</b></h1>
						<h3 class="section-subheading text-muted">${information[3] } </h3>
					</div>
				</td>
				<td class="right" rowspan="3">									
					<div class="accordion" id="accordionExample">
						<div class="card">
							<div class="card-header" id="headingOne">
								<h5 class="mb-0">
									<button class="btnText btn btn-link" type="button" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
										&nbsp;&nbsp;지도보기
									</button>
								</h5>
							</div>

							<div id="collapseOne" class="collapse show" aria-labelledby="headingOne" data-parent="#accordionExample">
								<div class="card-body">
									<input type="hidden" id="mapx" value="${information[5] }" />
									<input type="hidden" id="mapy" value="${information[4] }" />
									<input type="hidden" id="printTitle" value="${information[1] }" />
									<div id="map" style="width:500px;height:400px; margin:auto;"></div>
									<script>
										var mapx = $("#mapx").val();
										var mapy = $("#mapy").val();
										var spotTitle = $("#printTitle").val();
										
										console.log("mapx" + mapx);
										console.log("mapy" + mapy);
										
										var title = $("#printTitle").val();
										
										var mapContainer = document.getElementById('map'); 	//지도를 담을 영역의 DOM 레퍼런스
										var mapOptions = { 									//지도를 생성할 때 필요한 기본 옵션
												center: new kakao.maps.LatLng(mapy, mapx), //지도의 중심좌표.
												level: 10 //지도의 레벨(확대, 축소 정도)
											};

										var map = new kakao.maps.Map(mapContainer, mapOptions); //지도 생성 및 객체 리턴
										
										// 마커가 표시될 위치
										var markerPosition  = new kakao.maps.LatLng(mapy, mapx); 

										// 마커를 생성합니다
										var marker = new kakao.maps.Marker({
										    position: markerPosition
										});
										
										// 마커가 지도 위에 표시되도록 설정합니다
										marker.setMap(map);
									</script>
								</div>
							</div>
						</div>



						<div class="card">
							<div class="card-header" id="headingTwo">
								<h5 class="mb-0">
									<button class="btnText btn btn-link collapsed" type="button" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
										&nbsp;&nbsp;여행지 설명
									</button>
								</h5>
							</div>
							<div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionExample">
								<div class="card-body">
									<div class="overview">${information[2] }</div>
								</div>
							</div>
						</div>



						<div class="card">
							<div class="card-header" id="headingThree">
								<h5 class="mb-0">
									<button class="btnText btn btn-link collapsed" type="button" data-toggle="collapse" data-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
										&nbsp;&nbsp;리뷰 (${reviewSize })
									</button>
								</h5>
							</div>
							<div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="#accordionExample">
								<div class="card-body">
									<div class="reviewPrint">
										<c:if test="${loginCheck != 0}">
											<div class="input-group" style="padding: 20px;">
												<input type="text" id="review_content"
													class="form-control search-menu" placeholder="리뷰 작성"
													style="background: #f9f9f9;"> <input type="hidden"
													id="contentId" value="${contentId }" />
												<div class="input-group-append" onClick="writeReview()">
													<span class="input-group-text" style="background: #e9e9e9;">
														<i class="fas fa-pen"></i>
													</span>
												</div>
											</div>
										</c:if>
										<div>
											<c:if test="${reviewSize != 0 }">
												<div class="card-body">
													<table class="table table-hover" id='review_list'>
														<thead>
															<tr>
																<th></th>
																<th class="text-center d-none d-md-table-cell">내용</th>
																<th class="text-center d-none d-md-table-cell">작성자</th>
																<th class="text-center d-none d-md-table-cell">작성날짜</th>
																<th style="width: 30px;"></th>
															</tr>
														</thead>
														<tbody>
															<c:forEach var="reviewDTO" items="${reviewList }">
																<input type="hidden" id="hcontentId" value="${reviewDTO.content_id }" />
																<tr>
																	<td></td>
																	<td class="text-center d-none d-md-table-cell">${reviewDTO.review_content }</td>
																	<td class="text-center d-none d-md-table-cell">${reviewDTO.user_id }</td>
																	<td class="text-center d-none d-md-table-cell">${reviewDTO.review_date }</td>
																	<td style="width: 30px;"><c:if
																			test="${loginCheck eq reviewDTO.user_no }">
																			<div style="float: left;"
																				onClick="deleteReview(${reviewDTO.review_idx})">
																				<i class="far fa-trash-alt"></i>
																			</div>
																		</c:if></td>
																</tr>
															</c:forEach>
														</tbody>
													</table>
												</div>
											</c:if>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</td>
			</tr>


			<tr>
				<td class="left text-center">
					<img class="img-fluid photo" src="${information[0] }" alt="img" />
				</td>
			</tr>


			<tr>
				<td class="left text-center">
					<ul class="plus">
						<c:choose>
							<c:when test="${contentTypeId eq 12 }">
								<li>문의 및 안내 : ${information[6] }</li>
								<br>
								<li>쉬는 날 : ${information[7] }</li>
								<br>
								<li>이용시간 : ${information[8] }</li>
								<br>
							</c:when>
							<c:when test="${contentTypeId eq 14 }">
								<li>문의 및 안내 : ${information[6] }</li>
								<br>
								<li>쉬는 날 : ${information[7] }</li>
								<br>
								<li>이용시간 : ${information[8] }</li>
								<br>
							</c:when>
							<c:when test="${contentTypeId eq 15 }">
								<li>행사 홈페이지 : ${information[6] }</li>
								<br>
								<li>연락처 : ${information[7] }</li>
								<br>
								<li>공연시간 : ${information[8] }</li>
								<br>
								<li>이용 요금 : ${information[9] }</li>
								<br>
							</c:when>
							<c:when test="${contentTypeId eq 25 }">
								<li>문의 및 안내 : ${information[6] }</li>
								<br>
								<li>코스 예상 소요시간 : ${information[7] }</li>
								<br>
								<li>코스 테마 : ${information[8] }</li>
								<br>
							</c:when>
							<c:when test="${contentTypeId eq 28 }">
								<li>문의 및 안내 : ${information[6] }</li>
								<br>
								<li>쉬는 날 : ${information[7] }</li>
								<br>
								<li>이용 요금 : ${information[8] }</li>
								<br>
								<li>이용 시간 : ${information[9] }</li>
								<br>
							</c:when>
							<c:when test="${contentTypeId eq 32 }">
								<li>문의 및 안내 : ${information[6] }</li>
								<br>
								<li>체크인 : ${information[7] }</li>
								<br>
								<li>체크아웃 : ${information[8] }</li>
								<br>
								<li>홈페이지 : ${information[9] }</li>
								<br>
								<li>예약안내 : ${information[10] }</li>
								<br>
							</c:when>
							<c:when test="${contentTypeId eq 38 }">
								<li>문의 및 안내 : ${information[6] }</li>
								<br>
								<li>영업 시간 : ${information[7] }</li>
								<br>
								<li>쉬는 날 : ${information[8] }</li>
								<br>
							</c:when>
							<c:when test="${contentTypeId eq 39 }">
								<li>문의 및 안내 : ${information[6] }</li>
								<br>
								<li>대표 메뉴 : ${information[7] }</li>
								<br>
								<li>영업 시간 : ${information[8] }</li>
								<br>
								<li>쉬는 날 : ${information[9] }</li>
								<br>
							</c:when>
						</c:choose>
					</ul>
				</td>
			</tr>
		</table>
	</div>


	<!-- 하단 -->
	<%-- <c:import url="/WEB-INF/view/include/footer.jsp" /> --%>

	<!-- Bootstrap core JS-->
	<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>