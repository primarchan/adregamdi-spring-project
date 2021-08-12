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
	<!-- FontAwesome -->
	<link href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" rel="stylesheet">
	<!-- T Map API -->
	<script	src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=l7xxdc109d32e488487dbf0e29b9dfcf1a59"></script>
	<script type="text/javascript">
		
		var infoWindow;
		var infoWindows = [];
		var count = 0;
	
		$(function() {
			
			var param = {pageNo: 1, numOfRow: 5};
			var keywordParam =  {pageNo : 1, numOfRow : 5, keyword : ""};
			var main_markers = [];
			var present_markers = [];
			var keyword_markers = [];
			var map = initTmap();
			var category = 0;
			var plan_data=[];

			// 사이드바
			$("input:checkbox").on('click', function() {
				if ( $(this).prop('checked') ) {
					$('.sidebar-wrapper').css("transform", "translateX(-100%)"); 
				} else {
					$('.sidebar-wrapper').css("transform", "translateX(0)"); 
				}
			});
			
			// 첫 데이터 불러오기
			$.ajax({
			    url : "/schedule/information",
			    type : "get",
			    dataType : "json",
			    data : param,
			    success : function(data) {
			      main_markers = setListItems(data, main_markers, map, param.pageNo);
			      present_markers = main_markers;
			    }
			});
			
			// 무한 스크롤
			$('.sidebar-menu').scroll(function() {
			  if(Math.ceil($('.sidebar-menu').scrollTop() + $('.sidebar-menu').innerHeight()) == $('.sidebar-menu')[0].scrollHeight) {
		    	if(category == 0) {
				  	param.pageNo++;
		      	main_markers = callAjaxMain(param, main_markers, map);
		      	present_markers = main_markers;
		    	}
		    	if(category == 2) {
		    		keywordParam.pageNo++;
		    		keyword_markers = callAjaxKeyword(keywordParam, keyword_markers);
		    		present_markers = keyword_markers;
		    	}
			  }
			});
			
			// 키워드 검색
			$('#search').click(function() {
				category = 2;
				keywordParam.pageNo = 1;
				
				$('.keyword-ul').remove();
				
				if(keyword_markers != false) {
					keyword_markers = [];
				}
				
				if(present_markers != false) {
					deleteMarkers(present_markers);
				}
				
				$('#main').attr("disabled", false);
				$("#result").attr("disabled",true);
				$("#result").attr("disabled",false);
				$("#ul-main").hide();
				$("#ul-result").show();
				
				var keyword = $('#search-field').val();
				
				if(keyword == "") {
					alert('검색어를 입력해주세요!');
					$('#search-field').focus();
					return false;
				}
				
				keywordParam.keyword = keyword;
				
				$.ajax({
					url : "/schedule/keyword",
					type : "get",
					dataType : "json",
					data : keywordParam,
					success : function(data) {
						if(data.length == 0) {
							alert("검색된 결과가 없습니다.");
						} else {
							keyword_markers = keywordItems(data, keyword_markers, map, keywordParam.pageNo);
							present_markers = keyword_markers;
						}
					}
				});
			});
			// 추천 관광지 탭 클릭
			$('#main').click(function() {
				category = 0;
				$('#main').attr("disabled", true);
				$("#result").attr("disabled",false);
				$('#myPlan').attr("disabled", false);
				if(present_markers != false) {
					deleteMarkers(present_markers);
				}
				$("#ul-main").show();
				$("#ul-result").hide();
				$("#ul-myPlan").hide();
				present_markers = main_markers;
				for(var i = 0; i < main_markers.length; i++) {
					main_markers[i].setMap(map);
				}
			});
			// 검색 결과 탭 클릭
			$('#result').click(function() {
				category = 2;
				$('#main').attr("disabled", false);
				$("#result").attr("disabled",true);
				$('#myPlan').attr("disabled", false);
				if(present_markers != false) {
					deleteMarkers(present_markers);
				}
				$("#ul-main").hide();
				$("#ul-result").show();
				$("#ul-myPlan").hide();
				present_markers = keyword_markers;
				for(var i=0; i < keyword_markers.length; i++) {
					keyword_markers[i].setMap(map);
				}
			});
			// 내 여행 탭 클릭
			$('#myPlan').click(function() {
				category = 3;
				$('#main').attr("disabled", false);
				$("#result").attr("disabled",false);
				$('#myPlan').attr("disabled", true);
				if(present_markers != false) {
					deleteMarkers(present_markers);
				}
				$("#ul-main").hide();
				$("#ul-result").hide();
				$("#ul-myPlan").show();
			});
			// 저장 버튼
			$('#save_btn').click(function() {
				$('.position-data').each(function(){
					plan_data.push(JSON.parse($(this).val()));
				});
				var frmData = {'data' : plan_data};
				if(frmData.data != '') {
					var planForm = document.getElementById("planForm");
					var input = document.createElement('input');
					input.setAttribute("type","hidden");
					input.setAttribute("name","planData");
					input.setAttribute("value",JSON.stringify(frmData));
					planForm.appendChild(input);
					planForm.submit();
				} else {
					alert("저장된 여행지가 없습니다.")
				}
			});
		});
		
		// function 01 : setListItems(data, markers, map, pageNo)
		function setListItems(data, markers, map, pageNo) {
	    
			var positions = [];
	    
			$.each(data, function(i, result) {
	      var overview = result.overview.replace(/'/g, "");
	      var position = { 
	    		  title : result.title,
	          lonlat : new Tmapv2.LatLng(result.mapY, result.mapX),
	          addr : result.addr1,
	          overview : overview,
	          img : result.firstImage2,
	          contentId : result.contentId,
	          contentTypeId : result.contentTypeId
	      };
	      var content = '<li class="reco-ul">' +
	                    	'<hr>' +
	                    	'<div class="row spot_info' + pageNo + '">' +
	                      	'<div class="col-lg-5">' +
	                        	'<img class="img-responsive" style="cursor: pointer;" src="' + result.firstImage2 + '"alt="" width="135" height="90">' +
	                        '</div>' +
	                        '<div class="col-lg-7">' +
	                        	'<h6>' + result.title + '</h6>' +
	                          '<p>' + result.addr1 + '</p>' +
	                        '</div>' +
	                     	'</div>' +
	                  	'</li>';
	      
	      positions.push(position);
	      
	      $('#imgForm').append(content);
	    });
	    
	    $('.spot_info' + pageNo).each(function(i) {
    		
	    	var lonlat = positions[i].lonlat;
        var title  = positions[i].title;
        
        if(positions[i].addr == null) {
          positions[i].addr = "주소 없음";
        }
        
        // Tmap API 'Marker' Method (마커 생성)
        var marker = new Tmapv2.Marker({
          position : lonlat,
          map : map,
          title: title,
          visible: false
        });
        
        positions[i].no = count;
        infoWindows.push(infoWindow);
        console.log(infoWindows);
        
        markerClick(map, marker, lonlat, title, positions[i], positions[i].no);
        
        $(this).click(function(){
        	for(var i = 0; i < markers.length; i++) {
        		markers[i].setVisible(false);
        	}
          marker.setVisible(true); 
          // 지도 위치 재설정
          map.setCenter(new Tmapv2.LatLng(lonlat.lat(), lonlat.lng() - 0.15));
        });
        
        markers.push(marker);
        count++
      });
	    return markers;
  	} // function 01 : setListItems(data, markers, map, pageNo)
 		
  	// function 02 : initTmap()
		function initTmap() {
			// Tmap API 'Map' Method (지도 생성)
			var map = new Tmapv2.Map("tmap_api", { 
				center : new Tmapv2.LatLng(33.387292, 126.427416),
			  width : "100%",
			  height : "82vh",
			  zoom : 11,
			  zIndexInfoWindow : 999
			});
			return map;
		} // function 02 : initTmap()
		
		// function 03 : callAjaxMain(param, main_markers, map)
		function callAjaxMain(param, main_markers, map){			
	    $.ajax({
	      url : "/schedule/information",
	      type : "get",
	      dataType: "json",
	      data : param,
	      success : function(data) {
	        if(data.length == 0) {
	          alert('더 이상 표시할 내용이 없습니다.');
	        } 
	        if(data.length != 0) {
	          main_markers = setListItems(data, main_markers, map, param.pageNo);
	        }
	      }
	    });
		  return main_markers;
		} // function 03 : callAjaxMain(param, main_markers, map)
		
		// function 04 : markerClick(map, marker, lonlat, title, position)
		function markerClick(map, marker, lonlat, title, position, no) {
	    
			if(position.overview == null) {
	      position.overview = "";
	    }
			
	    marker.addListener("click", function(event) {
	    	var content = "<div style='position: static; display: flex; flex-direction: column; font-size: 14px; border-radius: 10px; top: 410px; left : 800px; width : 250px; background: #FFFFFF 0% 0% no-repeat padding-box;'>" +
									    	"<div class='img-box' style='position: relative; width: 100%; height: 150px; border-radius: 10px 10px 0 0 ;'>" +
									    		"<img src='" + position.img + "' style='width: 100%; height: 150px;'>" +
					      		  	"</div>" +
									    	"<div class='info-box' style='padding: 10px;'>" +
									    		"<p style='margin-bottom: 7px; overflow: hidden;'><span class='tit' style=' font-size: 16px; font-weight: bold;'>"+ title +"</span></p>" +
									    		"<ul class='ul-info' style='list-style: none; padding: 0px;'>" +
									    			"<li class='li-addr' style='padding-left: 5px; margin-bottom: 5px;'>" +
									    				"<p class='new-addr'><i class='fas fa-map-marker-alt' style='padding-right: 3%'></i>" + position.addr + "</p>" +
									    			"</li>" +
									    			"<li class='li-overview' style='padding-left: 5px;'>" +
									    				"<p class='overview' style='overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 4; -webkit-box-orient: vertical;'><i class='fas fa-sticky-note' style='padding-right: 3%'></i>" + position.overview + "</p>" +
									    			"</li>" +
									    		"</ul>"+
									    		"<ul class='btn-group' style='display: table; padding: 10px 0; width: 100%; border-radius: 3px; height: 30px; border: 1px solid #EFEFEF; margin: 10px 0 0 0; text-align: center;'>"+
								      			"<li style='display: table-cell; vertical-align: middle; width: 50%; height: 100%; border-right: 1px solid #EFEFEF;'>" +
								      				"<a href='javascript:void(0)' id='detail" + no + "' style='text-decoration: none;'><i class='fas fa-1x fa-info-circle'></i> 자세히 보기</a>" + 
								      			"</li>" +
								      			"<li style='display: table-cell; vertical-align: middle; width: 50%; height: 100%; border-right: 1px solid #EFEFEF;'>";
		    if($.isNumeric(position.liIndex)){
		       content = content + "<a href='javascript:void(0)' id='addList" + no + "' style='text-decoration: none;'><i class='fas fa-1x fa-trash'></i> 삭제하기</a>" +
		                        "</li>" +
		                      "</ul>" +
		                    "</div>" +
		                    "<a href='javascript:void(0)' onclick='onClose(" + no + ")' class='btn-close' style='position: absolute; top: 10px; right: 10px; display: block; width: 15px; height: 15px;'><i class='fas fa-times' style='color:white;'></i></a>" +
		                  "</div>";
		       
		    } else {
		       content = content + "<a href='javascript:void(0)' id='addList" + no + "' style='text-decoration: none;'><i class='fas fa-1x fa-plus-circle'></i> 추가하기</a>" +
		                        "</li>" +
		                      "</ul>" +
		                    "</div>" +
		                    "<a href='javascript:void(0)' onclick='onClose(" + no + ")' class='btn-close' style='position: absolute; top: 10px; right: 10px; display: block; width: 15px; height: 15px;'><i class='fas fa-times' style='color:white;'></i></a>" +
		                  "</div>";
		    }
		   	console.log(infoWindows[no]);
		    if(infoWindows[no] == null) {
			    // Tmap API 'InfoWindow' Method (팝업 생성)
		      infoWindows[no] = new Tmapv2.InfoWindow({
		        position : new Tmapv2.LatLng(lonlat.lat(), lonlat.lng()),
		        content : content,
		        border : '0px solid #FF0000',
		        type : 2,
		        map : map,
		        visible : true
		      });
		    } else {
		    	infoWindows[no].setVisible(true);
		    }
				
	   		// 지도 위치 재설정
	      map.setCenter(new Tmapv2.LatLng(lonlat.lat() - 0.11, lonlat.lng() - 0.055));	      
	 			
	      if(position.contentId != null) {
					$("#detail" + no).click(function() {
						detailModal(position.contentId, position.contentTypeId);
						$("#title-Guide").html(title);
					});
				}
	      
	      $("#addList" + no).unbind("click").bind("click", function() {
	    	  var diffrentTitle = true;
	    	  
	    	  $('.plan_title').each(function(i) {
	    		  if($(this).text() == title) {
	    		  	diffrentTitle = false;
	    		  	if(confirm("이미 추가했습니다. \n삭제하시겠습니까?")) {
	    		  		marker.setMap(null);
	    		  		$('.day' + position.planDay + '-' + position.liIndex).remove();
	      				position.liIndex = "false";
	      				delete position['positionDate'];
	    		  	}
	    		  	return false;
	    	  	}
	    	  });
	    	  if(diffrentTitle == true) {
	    		  addModal(position, map, marker);
	    	  }
	    	  infoWindows[no].setVisible(false);
	      });
	  	});
		}
		
		// function 04 : detailModal(contentId, contentTypeId)
		function detailModal(contentId, contentTypeId) {
			
			if($(".contentId").val() == null) {
				$("#modalForm").append("<input id='modal-contentId' class='contentId' type='hidden' name='contentId' value="+contentId+">");
			}
			
			if($(".contentTypeId").val() == null) {
				$("#modalForm").append("<input id='modal-contentTypeId' class='contentTypeId' type='hidden' name='contentTypeId' value="+contentTypeId+">");
			}
			
			$("#modalForm").submit();
			
			$("#modal-Guide").modal();
		} // function 04 : detailModal(contentId, contentTypeId)
		
		// function 05 : addModal(position, map, marker)
		function addModal(position, map, marker) {
			
			$("#addModal").modal("show");
			
			$("#spot_title").val(position.title);
					
			$(".confirm").unbind("click").bind("click", function(){
				
				var dayNum = $("#day").val();
				var liIndex = $('.sub-plan' + $('#day').val()).find('li').length + 1;
				var content = $('<li class="list_add_content day' + dayNum + '-' + liIndex +'">' + 
													'<hr>' + 
													'<div class="row testRemove">' +
														'<div class="col-lg-5" style="background-color : #f5f5f5">' + 
															'<img class="img-responsive" class="plan_photo" style="cursor: pointer;" src="' + position.img + '" alt="" width="135" height="90">' + 
														'</div>' + 
														'<div class="col-lg-7" style="background-color : #f5f5f5">' + 
															'<h5 class="plan_title">' + position.title + '</h5>' +
															'<h6 class="plan_addr">'+ position.addr + '</h6>' + 
															'<span style="float: right;"><i class="fas fa-1x fa-trash"></i></span>' + 
														'</div>' + 
													'</div>' + 
												'</li>');
				
				content.appendTo($('#day' + $('#day').val() + ' .sub-plan' + $('#day').val()));
				
				$('.day' + dayNum + '-' + liIndex + ' span').click(function(){
					marker.setMap(null);
					$('.day' + position.planDay + '-' + position.liIndex).remove();
					position.liIndex = "false";
					delete position['positionData'];
					alert("삭제했습니다.");
				});
				
				$('#addModal').modal('hide');
				var strArr = $('#plan_date').val();
				var startDate = new Date(parseInt(strArr.substr(0, 4)), parseInt(strArr.substr(5, 2)) - 1, parseInt(strArr.substr(8, 2)));
				startDate.setDate(startDate.getDate() + ($('#day').val() - 1));
				var month = ((startDate.getMonth() + 1) < 10 ? '0' : '') + (startDate.getMonth() + 1);
				var day = (startDate.getDate() < 10 ? '0' : '') + startDate.getDate();
				var split_date = startDate.getFullYear() + "-" + month + "-" + day;
				
				position.planDate = split_date;
				position.planDay = $('#day').val();
				position.planTotalDate = $('#plan_term').val();
				position.planno = $('#planNo').val();
				position.liIndex = liIndex;
				var marker = new Tmapv2.Marker({
					position : new Tmapv2.LatLng(position.lonlat.lat(), position.lonlat.lng()),
					icon : "http://tmapapis.sktelecom.com/upload/tmap/marker/pin_r_m_p.png",
					map : map,
					title : "[" + position.planDay + "일차]" + position.title
				});
				
				markerClick(map, marker, position.lonlat, position.title, position);
				
				var position_data = JSON.stringify(position);
				position.positionData = position_data;
				
				var input = $("<input type='hidden' class='position-data day" + dayNum + "-" + liIndex + "' value='" + position_data + "'>");
				input.appendTo($("#day" + $("#day").val() + " .sub-plan" + $("#day").val()));
				$("#addModal").modal("hide");
			});
		} // function 05 : addModal(position, map, marker)
		
		// function 06 : deleteMarkers(markers)
		function deleteMarkers(markers) {
			for(var i = 0; i < markers.length; i++) {
				markers[i].setMap(null);
			}
		} // function 06 : deleteMarkers(markers)
		 
		// function 07 : onClose(popup)
		function onClose(no) {
			if($(".contentId").val() != null) {
				$(".contentId").remove();
			}
			
			if($(".contentTypeId").val() != null) {
				$(".contentTypeId").remove();
			}
			infoWindows[no].setVisible(false);
		} // function 07 : onClose(popup)
		
		// function 08 : keywordItems(data, markers, map, pageNo)
		function keywordItems(data, markers, map, pageNo) {
			var positions = [];
			$.each(data, function(i, result) {
				var position = { 
			    		  title : result.title,
			          lonlat : new Tmapv2.LatLng(result.mapY, result.mapX),
			          addr : result.addr1,
			          overview : result.overview,
			          img : result.firstImage2,
			          contentId : result.contentId,
			          contentTypeId : result.contentTypeId
			      };
				
				var content = '<li class="keyword-ul">' +
					             	'<hr>' +
					             	'<div class="row keyword_info' + pageNo + '">' +
					               	'<div class="col-lg-5">' +
					                 	'<img class="img-responsive" style="cursor: pointer;" src="' + result.firstImage2 + '"alt="" width="135" height="90">' +
					                 '</div>' +
					                 '<div class="col-lg-7">' +
					                 	'<h6>' + result.title + '</h6>' +
					                   '<p>' + result.addr1 + '</p>' +
					                 '</div>' +
					              	'</div>' +
					           	'</li>';
					      
				positions.push(position);
				$('#keywordForm').append(content);
			});
			
			$('.keyword_info' + pageNo).each(function(i) {
				var lonlat = positions[i].lonlat;
				var title = positions[i].title;
				if(positions[i].addr == null) {
					positions[i].addr = "주소 없음";
				}
				// Tmap API 'Marker' Method (마커 생성)
        var marker = new Tmapv2.Marker({
          position : lonlat,
          map : map,
          title: title,
          visible: false
        });
        
        markerClick(map, marker, lonlat, title, positions[i]);
        
        $(this).click(function(){
        	for(var i = 0; i < markers.length; i++) {
        		markers[i].setVisible(false);
        	}
          marker.setVisible(true); 
          // 지도 위치 재설정
          map.setCenter(new Tmapv2.LatLng(lonlat.lat(), lonlat.lng() - 0.15));
        });
        
        markers.push(marker);
      });
	    return markers;
		} // function 08 : keywordItems(data, markers, map, pageNo)
		
		// function 09 : callAjaxKeyword(keywordParam,keyword_markers,map)
		function callAjaxKeyword(keywordParam, keyword_markers, map) {
			$.ajax({	
				url : "/schedule/keyword",
				type : "get",
				dataType : "json",
				data : keywordParam,
				success : function(data) {
					if(data.length == 0) {
				          alert('더 이상 표시할 내용이 없습니다.');
				        } 
					if(data.length != 0) {
						keyword_markers = keywordItems(data, keyword_markers, map, keywordParam.pageNo)
					}
				}
			});
			return keyword_markers;
		} // function 09 : callAjaxKeyword(keywordParam,keyword_markers,map)
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
    
    .page-wrapper {
      height: 100vh;
    }
    
    .page-header {
      height: 86px;
    }
    
    .page-main {
      height: 82vh;
    }
    
    .page-footer {
    	position: relative;
      height: 6vh;
      background: #f5f5f5;
    }
    
    .page-footer span {
    	position: absolute;
    	top: 12px;
    	right: 145px;
    	font-size: 14px;
    	font-weight: bold;
    	color: #737373;

    }
    
    .page-footer input {
    	display: none;
    }
    
    .page-footer label {
    	display: inline-block;
    	width: 40px;
    	height: 24px;
    	cursor: pointer;
    	position: absolute;
    	top: 10px;
    	right: 100px;
    	background: #ccc;
    	border-radius: 12px;
    }
    
    .page-footer label::before {
    	content: '';
    	display: block;
    	width: 16px;
    	height: 16px;
    	left: 4px;
    	bottom: 4px;
    	position: absolute;
    	background: white;
    	transition: 0.3s;
    	border-radius: 8px;
    }
    
    .page-footer input:checked + label {
    	background: #2196f3;
    }
    
    .page-footer input:checked + label:before {
    	transform: translateX(16px);
    }
    
    .page-footer .btn {
    	position: absolute;
    	top: 7px;
    	right: 20px;
    	height: 30px;
    	line-height: 18px;
    	background: #258fff;
    	font-weight: 700;
    }
    
    .sidebar-wrapper {
      position: absolute;
      width: 25%;
      height: 82vh;
      max-height: 82vh;
      background: #258fff;
      z-index: 1;
      border-radius: 0 10px 0px 0px;
      transition: 0.3s;
    }

    .sidebar-wrapper ul {
      list-style: none;
      padding: 0;
      margin: 0;
    }

    .sidebar-wrapper a {
      text-decoration: none;
    }

    .sidebar-wrapper .sidebar-header {
      padding: 9px 0 0 0;
      color: #f5f5f5;;
    }
    
    .sidebar-wrapper .sidebar-search > div {
      padding: 10px;
    }
    
    .sidebar-wrapper .sidebar-menu {
      width: 100%;
      height: 487px;
      background: #f5f5f5;
      overflow: auto;
    }
		
		.sidebar-wrapper .sidebar-menu h6 {
			font-weight: bold;
			font-size: 14px;
		}
		
		.sidebar-wrapper .sidebar-menu p {
			font-size: 14px;
		}
		
		.sidebar-wrapper .sidebar-menu hr {
			margin: 8px 0;
		}
				
    .sidebar-wrapper .sidebar-menu .header-menu span {
      font-weight: bold;
      font-size: 16px;
      display: inline-block;
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
	<!-- Model Value -->
	<input type="hidden" id="plan_term"  value="${plan_term }">
	<input type="hidden" id="plan_title" value="${plan_title}">
	<input type="hidden" id="plan_date"  value="${plan_date }">
	<input type="hidden" id="planNo"     value="${plan_no }">
	<input type="hidden" id="user_no"    value="${loginUserDTO.user_no }" >
	
	<!-- Header -->
  <c:import url="/WEB-INF/view/include/header.jsp"/>
  
  <!-- Main -->
  <div class="page-wrapper">
    <div class="page-header"></div>
    <div class="page-main" id="tmap_api">
      <!-- SideBar -->
      <div class="sidebar-wrapper">
        <div class="sidebar-header">
          <button type="button" id="main" class="btn btn-link" style="color: #f9f9f9; text-decoration: none;" onclick="">추천 여행지</button>
					<button type="button" id="result" class="btn btn-link" style="color: #f9f9f9; text-decoration: none;" onclick="" disabled>검색 결과</button>
					<button type="button" id="myPlan" class="btn btn-link" style="color: #f9f9f9; text-decoration: none;" onclick="">내 여행</button>
        </div>
        <div class="sidebar-search">
          <div class="input-group">
            <input type="text" id="search-field" class="form-control search-menu" placeholder="검색어를 입력하세요...">
            <div class="input-group-append">
              <span id="search" class="input-group-text">
                <i class="fa fa-search"></i>
              </span>
            </div>
          </div>
        </div>
        <div class="sidebar-menu">
          <!-- 기본 -->
          <ul id="ul-main" style="padding: 10px 20px;">
            <li class="header-menu">
            	<span>추천 여행지 리스트</span>
            </li>
						<form action="" method="get" name="imgForm" id="imgForm">
						
						</form>
          </ul>
          <!-- 검색 -->
          <ul id="ul-result" style="display: none; padding: 10px 20px">
            <li class="header-menu">
              <span>검색 결과</span>
            </li>
            <form method="get" name="keywordForm" id="keywordForm">
            
            </form>
          </ul>
          <!-- 내 여행 -->
         <ul id="ul-myPlan" data-role="listview" style="display: none; padding: 10px 20px">
	          <li class="header-menu">
	          	<span>내 여행</span>
	          </li>
						<form method="GET" name="myPlanForm" id="myPlanForm">
						   <c:forEach var="i" begin="1" end="${plan_term }">
						      <li class="sidebar-dropdown" id="day${i }">
						            <a href="javascript:void(0)">
						              <span>${i }일차</span>
						            </a>
						            <div class="sidebar-submenu" style="background: #f5f5f5;">
						              <ul class="sub-plan${i }">
						              
						              </ul>
						            </div>
						       </li>
						   </c:forEach>
						</form>
					</ul>
        </div>
      </div>
    </div>
    <div class="page-footer">
    	<form action="${root }schedule/write_proc" method="get">
    		<span>지도 켜기</span>
    		<input type="checkbox" id="switch">
    		<label for="switch"></label>
      	<button id="save_btn" type="button" class="btn btn-primary">저장</button>
      </form>
    </div>
  </div>
  
  <form id="planForm" name="planForm" action="/schedule/write_proc" method="POST"></form>
  
  <!-- Modal -->
	  <!-- Detail Modal -->
	  <form id="modalForm" target="guide" method="get" action="${root }schedule/guide"></form>
	  
	  <div id="modal-Guide" class="modal fade" style="display: none;"  tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false">
			<div class="modal-dialog modal-lg" style="height: 98%">
				<div class="modal-content" style="height: 95%; border-radius: 0px;">
					<div class="modal-header">
						<h5 class="modal-title" id="title-Guide" style="font-weight: bold;"></h5>
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					</div>
					<div class="modal-body" style="height: 94%; padding: 0px;">
						<iframe name="guide" id="if_guidebook"  width="100%" height="100%" src="${root }schedule/guide" style="border: none;"></iframe>
					</div>
				</div>
			</div>
		</div>
		
		<!-- AddList Modal -->
		<div id="addModal" class="modal fade" tabindex="-1" style="display: none;" role="dialog"	aria-labelledby="myModalLabel"  aria-hidden="false">
		<div class="modal-dialog modal-md" style="width: ;">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="myModalLabel">${plan_title }</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="form-group">
						<input type="text" id="spot_title" class="form-control" name="spot_title" readonly>
					</div>
					<div class="form-group">
						<select id="day" class="form-control" name="days" required>
							<option value="1" selected>1일차</option>
							<c:forEach var="i" begin="2" end="${plan_term }">
								<option value="${i }">${i }일차</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="modal-footer">
					<button class="btn btn-primary confirm" type="button" id="confirm">추가</button>
					<button class="btn btn-danger" type="button" data-dismiss="modal">취소</button>
				</div>
			</div>
		</div>
	</div>

</body>
</html>