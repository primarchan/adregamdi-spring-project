<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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
	<!-- FontAwesome -->
	<link href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" rel="stylesheet">
	<script type="text/javascript">
		$(function() {
			var contentId = $("#contentId").val();
			var contentTypeId = $("#contentTypeId").val();
			var info_data = [];
			var param = {"contentId" : contentId, "contentTypeId" : contentTypeId};
			firstAjax(param, contentTypeId);
		});
		
		function firstAjax(param, contentTypeId) {
			$.ajax({
				url : "/schedule/detail",
				type : "get",
				dataType : "json",
				data : param,
				success : function(data) {
					insertData(data, contentTypeId);
				}
			});
		}
		
		function insertData(data, contentTypeId) {
			for(var i = 0; i < data.length; i++) {
				if(data[i] == null) {
					data[i] = "";
				}
			}
			$("#main-img").attr("src",data[0]);
			$(".title").text(data[1]);
			$("#overview").html(data[2]);
			$(".address").html("<i class='fas fa-map-pin mr-2'></i> " + data[3]);
			switch(contentTypeId) {
				case "12" :
					$(".details").append("<p style='margin-bottom: 3px;'><i class='fas fa-1x fa-info-circle mr-2'></i> 문의 및 안내</p><p class='ml-3 mb-3'>"+data[6]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='far fa-1x fa-calendar-alt mr-2'></i> 쉬는날</p><p class='ml-3 mb-3'>"+data[7]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='far fa-1x fa-clock mr-2'></i> 이용시간</p><p class='ml-3 mb-3'>"+data[8]+"</p>");
					break;
				case "14" :
					$(".details").append("<p style='margin-bottom: 3px;'><i class='fas fa-1x fa-info-circle mr-2'></i>문의 및 안내</p><p class='ml-3 mb-3'>"+data[6]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='fas fa-1x fa-won-sign mr-2'></i> 이용요금</p><p class='ml-3 mb-3'>"+data[7]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='far fa-1x fa-clock mr-2'> 이용시간</p><p class='ml-3 mb-3'>"+data[8]+"</p>");
					break;
				case "15" :
					$(".details").append("<p style='margin-bottom: 3px;'><i class='fas fa-1x fa-info-circle mr-2'></i>행사 홈페이지</p><p class='ml-3 mb-3'>"+data[6]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='fas fa-1x fa-phone-alt mr-2'></i> 연락처</p><p class='ml-3 mb-3'>"+data[7]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='far fa-1x fa-clock mr-2'> 공연시간</p><p class='ml-3 mb-3'>"+data[8]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='fas fa-1x fa-won-sign mr-2'></i>이용요금</p><p class='ml-3 mb-3'>"+data[9]+"</p>");//여기까지
					break;
				case "25" :
					$(".details").append("<p style='margin-bottom: 3px;'><i class='fas fa-1x fa-info-circle mr-2'></i>문의 및 안내</p><p class='ml-3 mb-3'>"+data[6]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='far fa-1x fa-clock mr-2'> 코스 예상 소요시간</p><p class='ml-3 mb-3'>"+data[7]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='far fa-1x fa-question-circle mr-2'></i> 코스 테마</p><p class='ml-3 mb-3'>"+data[8]+"</p>");
					break;
				case "28" :
					$(".details").append("<p style='margin-bottom: 3px;'><i class='fas fa-1x fa-info-circle mr-2'></i> 문의 및 안내</p><p class='ml-3 mb-3'>"+data[6]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='far fa-1x fa-calendar-alt mr-2'></i> 쉬는날</p><p class='ml-3 mb-3'>"+data[7]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='fas fa-1x fa-won-sign mr-2'></i> 이용요금</p><p class='ml-3 mb-3'>"+data[8]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='far fa-1x fa-clock mr-2'> 이용시간</p><p class='ml-3 mb-3'>"+data[9]+"</p>");
					break;
				case "32" :
					$(".details").append("<p style='margin-bottom: 3px;'><i class='fas fa-1x fa-info-circle mr-2'></i> 문의 및 안내</p><p class='ml-3 mb-3'>"+data[8]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='far fa-1x fa-clock mr-2'> 체크인</p><p class='ml-3 mb-3'>"+data[6]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='far fa-1x fa-clock mr-2'> 체크아웃</p><p class='ml-3 mb-3'>"+data[7]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='fas fa-1x fa-link mr-2'></i> 홈페이지</p><p class='ml-3 mb-3'>"+data[9]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='far fa-1x fa-question-circle mr-2'></i> 예약안내</p><p class='ml-3 mb-3'>"+data[10]+"</p>");
					break;
				case "38" :
					$(".details").append("<p style='margin-bottom: 3px;'><i class='fas fa-1x fa-info-circle mr-2'></i> 문의 및 안내</p><p class='ml-3 mb-3'>"+data[6]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='far fa-1x fa-clock mr-2'> 영업시간</p><p class='ml-3 mb-3'>"+data[7]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='far fa-1x fa-calendar-alt mr-2'></i>쉬는날</p><p class='ml-3 mb-3'>"+data[8]+"</p>");
					break;
				case "39" :
					$(".details").append("<p style='margin-bottom: 3px;'><i class='fas fa-1x fa-info-circle mr-2'></i> 문의 및 안내</p><p class='ml-3 mb-3'>"+data[7]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='fas fa-1x fa-utensils mr-2'></i> 대표 메뉴</p><p class='ml-3 mb-3'>"+data[6]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='far fa-1x fa-clock mr-2'> 영업시간</p><p class='ml-3 mb-3'>"+data[8]+"</p>");
					$(".details").append("<p style='margin-bottom: 3px;'><i class='far fa-1x fa-calendar-alt mr-2'></i> 쉬는날</p><p class='ml-3 mb-3'>"+data[9]+"</p>");
					break;
			}
		}
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
  
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }
  
  section {
    margin : 10px 0 0;
    padding-top : 10px;
    padding-bottom : 25px;
    background : #FEFEFE;
  }
  
  .wrapping {
    position: relative;
      width: 100%;
      min-height: 100%;
  }
  
  .inner_wrap {
      position: relative;
      width: 100%;
      height: 100%;
      overflow: visible;
      margin: 0 auto;
  }
  
  .inner_wrap .details p{
      margin: 0;
  }
  
  .banner {
      margin: 50px 0 0;
      padding: 0 0 25px;
      border-bottom: none;
  }
  
  main {
      margin: 0;
      padding: 0;
      background : #F0f0f0;.
  }
  
  .banner .photo {
      position: relative;
      width: 100%;
      padding-top: 54%;
      overflow: hidden;
  }
  
  img.fw {
      position: absolute;
      width: 100%;
      height: auto;
      top: -100%;
      right: -100%;
      bottom: -100%;
      left: -100%;
      margin: auto;
  }
  
  .banner .info {
    position: relative;
    padding: 20px 20px 0;
  }
  
  .titleArea {
  	position: relative;
  }  
  
  .titleArea .address {
  	padding: 20px 30px;;
  	border: 3px solid #F0f0f0;
  	border-radius: 10px;
  }  
	
	.overview {
		padding: 5px;
	}
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
  <title>Document</title>
</head>
<body>
	<input type="hidden" name="contentId" id="contentId" value="${contentId }">
	<input type="hidden" name="contentTypeId" id="contentTypeId" value="${contentTypeId }">
	
	<div class="wrapping">
		<main>
			<section class="banner" style="margin-top: 0px; padding-top: 0px;">
				<div class="inner_wrap">
					<div class="photo">
						<img class="fw lazyloaded" id="main-img" src="">
					</div>
					<!--Main Info-->
					<div class="info">
						<div class="titleArea">
							<h5 style="font-weight: bold;" class="address"></h5>
						</div>
						<div class="overview">
							<p id="overview"></p>
						</div>
					</div>
				</div>
			</section>
			
			<section class="stu_section stu_exp_list stu_clearfix" style="padding: 20px;">
				<div class="inner_wrap">
					<div style="padding-left: 20px; padding-right: 20px" class="details">

					</div>
				</div>
			</section>
		</main>
	</div>
</body>
</html>