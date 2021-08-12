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
  <!-- DevExtreme -->
  <script type="text/javascript" src="https://cdn3.devexpress.com/jslib/20.2.7/js/dx.all.js"></script>
	<link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/20.1.7/css/dx.common.css" />
	<link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/20.1.7/css/dx.softblue.css" /> 
  <!-- JQuery UI -->
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js" type="text/javascript"></script>
  <title>Document</title>
  <script type="text/javascript">
  	$(function() {
			
  		var map = initTmap();
			var allInfo = [];
			var planTitle = $('#plan-title').text();
			var planNo = $('#planNo').val();
			var user_no = $('#user_no').val();
			var start = 9;
			var end = 10;
			var schedule = [];
			var present_markers = [];
			var present_polylines = [];
			
			$('#plan-info').find('ul').find('input').each(function(){
				allInfo.push(JSON.parse($(this).val()));
			});
			
			var firstDate = allInfo[0].planDate.split('-');
			
			for(var i = 0; i < allInfo.length; i++) {
				var data = {};
				var date;
				
				data.text = allInfo[i].title;
				data.is_insertAfter = allInfo[i].is_insertAfter;
				
				if(allInfo[i].startDate =="" || allInfo[i].endDate=="") {
					date = allInfo[i].planDate.split('-');
					if(firstDate[0] != date[0] || firstDate[1] != date[1] || firstDate[2] != date[2]) {
						firstDate = date;
						start = 9;
						end = 10;
					}
					data.startDate =  new Date(date[0], (date[1]-1), date[2], start, 00);
					data.endDate = new Date(date[0], (date[1]-1), date[2], end, 00);
					start += 2;
					end += 2;
					schedule.push(data);
				} else {
					date = allInfo[i].startDate.split('-');
					data.startDate = new Date(date[0], (date[1]-1), date[2], date[3], date[4]);
					date = allInfo[i].endDate.split('-');
					data.endDate = new Date(date[0], (date[1]-1), date[2], date[3], date[4]);
					data.description = allInfo[i].descript;
					schedule.push(data);
				}
			}

			$('.dx-tab').on("click", function() {
				
				var type = $(this).find('span.dx-tab-text').text();
				
				if(type == 'agenda') {
					$('.dx-scheduler-navigator').css('visibility : visible;');
				} else {
					$('.dx-scheduler-navigator').css('visibility : hidden;');
				}
			});
			
			$('#btn-modify').click(function() {
				$('#ModifyForm').submit();
			});
			
			$("input:checkbox").on('click', function() {
				if ( $(this).prop('checked') ) {
					$('#planner-info').show();
				  $('#plan-info').hide(); 
				} else {
					$('#planner-info').hide();
				  $('#plan-info').show();
				}
			});
		  
		  $("input[name='upload_img']").change(function() {
			  
			  var form = new FormData(document.getElementById('upload-form'));
			  
			  $.ajax({
	        url : "/schedule/upload",
	        type : "post",
	        enctype : 'multipart/form-data',
	        processData : false,
	        contentType : false,
	        dataType : 'json',
	        data : form,
	        success : function(data) {
	        	$("#img-planner").attr("src", data.plan_img);
	        }
			  });
		  });
		  
		  $('#modify-planner').on('click', function() {
				$.ajax({
	      	url : "/schedule/update",
	      	type : "post",
	      	dataType : "text",
	      	data : {"plan_no" : $('#plan_no').val(), "plan_title" : $('#plan_title').val(), "plan_info" : $('#plan_info').val()},
	      	success : function(data) {
	      		if(data == "true") {
	      			alert('수정이 완료되었습니다.');
	      			location.reload();
	      		}
	      	}
				});
		  });
		  
		  $('#plan-info').find('ul').each(function() {
			  $(this).sortable();
			  $(this).disableSelection();
			});
		  
		  $('#plan-info').find('button').click(function(){
		  	
			  if(present_markers != "") {
	    		present_markers.forEach(function(marker) {
	    			marker.setMap(null);
	    		});
		    }
		    
			  if(present_polylines != "") {
		    	present_polylines.forEach(function(line) {
		    		line.setMap(null);
	    		});    
		    }
		    
			  var jsonData = [];
		    var viaData = [];
		    var result = $(this).siblings('ul').sortable('toArray');
		    
		    $(this).siblings('ul').sortable().find('input[name=planData]').each(function(){
		    	jsonData.push(JSON.parse($(this).val()));
		    });

		    if(jsonData.length > 2) {
		    	present_markers.push(addMarker(map, "start", jsonData[0]));
	        for(var i = 1; i < jsonData.length - 1; i++) {
	        	present_markers.push(addMarker(map, "pass", jsonData[i]));
	          viaData.push(jsonData[i]);
	        }
	        present_markers.push(addMarker(map, "end", jsonData[jsonData.length - 1]));
	        present_polylines = testAPI(map, jsonData[0], jsonData[jsonData.length - 1], viaData);
		    } else {
		      alert('출발지와 목적지 사이에 경유지가 한개 이상 있어야 합니다.');
		    }
		  });
		  
		  var calendarDate = allInfo[0].planDate.split('-');
		  var instance;
		  var date = allInfo[0].planDate.split('-');
		  var day = date[2] - (allInfo[0].planDay - 1);
		  
		  if($("#modify-state").val() == 'Y') {
			  instance = $("#scheduler").dxScheduler({
				  dataSource : schedule,
				  views: [
					  { name : "travelDay", type : "day", intervalCount : allInfo[0].planTotalDate, startDate : new Date(date[0], date[1], day)},
					  { name : "agenda", type : "agenda"}],
						currentView : "travelDay",
						currentDate : new Date(calendarDate[0], (calendarDate[1]-1), calendarDate[2]),
						startDayHour : 9,
						showAllDayPanel : false,
						height : 600,
						onAppointmentDeleting : function(e) {
								e.cancel = new $.Deferred();
							if(e.appointmentData.is_insertAfter == 'N') {
								e.cancel.resolve(true);
				      } else {
				        e.cancel.resolve(false);
				      }
				    },
				    editing: {
            	allowDeleting:false
            },
				    onAppointmentFormOpening: function(e) {
              e.popup.option('showTitle', true);
              e.popup.option('title', e.appointmentData.text ? e.appointmentData.text : 'Create a new appointment');
              const form = e.form;
              let formItems = form.option("items");
              if(e.appointmentData.is_insertAfter == 'N') {
                 formItems[0].items[0].visible = false;
              } else {
                 formItems[0].items[0].visible = true;
              }
              form.option("items", formItems); 
            },
            onAppointmentAdded: function(e) { }
			  }).dxScheduler("instance");
		  } else {
			  instance = $("#scheduler").dxScheduler({
				  dataSource : schedule,
				  views: [
					  { name : "travelDay", type : "day", intervalCount : allInfo[0].planTotalDate, startDate : new Date(date[0], date[1] - 1, day)},
					  { name : "agenda", type : "agenda"}],
					  currentView : "travelDay",
					  currentDate : new Date(date[0], date[1]-1, day),
					  startDayHour: 9,
					  onAppointmentDeleting : function(e) {
							e.cancel = new $.Deferred();
							if(e.appointmentData.is_insertAfter == 'N') {
									e.cancel.resolve(true);
					    } else {
					        e.cancel.resolve(false);
					    }
					  },
					  editing: {
            	allowDeleting:false
            },
            onAppointmentFormOpening: function(e) {
              e.popup.option('showTitle', true);
              e.popup.option('title', e.appointmentData.text ? e.appointmentData.text : 'Create a new appointment');
              const form = e.form;
              let formItems = form.option("items");
              if(e.appointmentData.is_insertAfter == 'N') {
                 formItems[0].items[0].visible = false;
              } else {
                 formItems[0].items[0].visible = true;
              }
              form.option("items", formItems); 
            },
            onAppointmentAdded: function(e) { }
			  }).dxScheduler("instance");
		  }
		  
		  $("#btn-save").click(function() {
				
			  var instances = instance.getDataSource().items();
				var finalData = [];
				var buffer;
	
				for(var i = 0; i < instances.length; i++) {
					var flag = false;
					var planDay = 1;
					buffer = {};
					for(var j = 0; j < allInfo.length; j++) {
						if(allInfo[j].title == instances[i].text) {
							buffer.planNo = planNo;
							buffer.user_no = user_no;
							buffer.title = allInfo[j].title;
							var date = instances[i].startDate;
							buffer.startDate = date.getFullYear() + "-" + ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1) + "-" + (date.getDate() < 10 ? '0' : '') + date.getDate() + "-" + (date.getHours() < 10 ? '0' : '') + date.getHours() + "-" + (date.getMinutes() < 10 ? '0' : '') + date.getMinutes();
							date = instances[i].endDate;
							buffer.endDate = date.getFullYear() + "-" + ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1) + "-" + (date.getDate() < 10 ? '0' : '') + date.getDate() + "-" + (date.getHours() < 10 ? '0' : '') + date.getHours() + "-" + (date.getMinutes() < 10 ? '0' : '') + date.getMinutes();
							if(instances[i].description != "") {
								buffer.description = instances[i].description;
							} else {
								buffer.description = "";
							}
							buffer.planTitle = planTitle
							buffer.planDate = date.getFullYear() + "-" + ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1) + "-" + (date.getDate() < 10 ? '0' : '') + date.getDate();
							buffer.planDay = calcPlanDay(allInfo[0].planDate, buffer.planDate, allInfo[0].planDay);
							buffer.planTotalDate = allInfo[j].planTotalDate;
				      buffer.is_insertAfter = allInfo[j].is_insertAfter;
				      finalData.push(buffer);
				      flag = true;
						}
					}
					if(!flag) {
						buffer.planNo = planNo;
						buffer.user_no = user_no;
				    buffer.title = instances[i].text;
				    var date = instances[i].startDate;
				    buffer.startDate = date.getFullYear() + "-" + ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1) + "-" + (date.getDate() < 10 ? '0' : '') + date.getDate() + "-" + (date.getHours() < 10 ? '0' : '') + date.getHours() + "-" + (date.getMinutes() < 10 ? '0' : '') + date.getMinutes();
						date = instances[i].endDate;
						buffer.endDate = date.getFullYear() + "-" + ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1) + "-" + (date.getDate() < 10 ? '0' : '') + date.getDate() + "-" + (date.getHours() < 10 ? '0' : '') + date.getHours() + "-" + (date.getMinutes() < 10 ? '0' : '') + date.getMinutes();
						if(instances[i].description != "") {
							buffer.description = instances[i].description;
						} else {
							buffer.description = "";
						}
						buffer.planTitle = planTitle
						buffer.planDate = date.getFullYear() + "-" + ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1) + "-" + (date.getDate() < 10 ? '0' : '') + date.getDate();
						buffer.planDay = calcPlanDay(allInfo[0].planDate, buffer.planDate, allInfo[0].planDay);
					  buffer.planTotalDate = allInfo[0].planTotalDate;
				    buffer.planTitle = planTitle;
				    buffer.is_insertAfter = 'Y';
				    finalData.push(buffer);
					}
				}
				sendSchedule(finalData);
		  });
		});
  	
  	function initTmap() {
  	  
  		var map = new Tmapv2.Map("tmap_api", {
  	     center: new Tmapv2.LatLng(33.38260485180545, 126.57321166992229),
  	     width: "100%", 
  	     height: "400px",
  	     zoom: 10
  	  });
  	  
  	  return map;
  	}
  	
  	function sendSchedule(finalData) {
  		
  		var frmData = {"data" : finalData};
  	  
  		$("#schedule-plan").val(JSON.stringify(frmData));
  	  $("#scheduleForm").submit();
  	}
  	
  	function addMarker(map, status, planInfo) {
  		  		
  		switch (status) {
  	  	case "start":
  	    imgURL = 'http://tmapapis.sktelecom.com/upload/tmap/marker/pin_r_m_s.png';
  	    break;
  	  	case "pass":
  	    imgURL = 'http://tmapapis.sktelecom.com/upload/tmap/marker/pin_b_m_p.png';
  	    break;
  	  	case "end":
  	    imgURL = 'http://tmapapis.sktelecom.com/upload/tmap/marker/pin_r_m_e.png';
  	    break;
  	  };
  	  
  		var marker = new Tmapv2.Marker({
  	  	position : new Tmapv2.LatLng(planInfo.mapX,planInfo.mapY),
  	    icon : imgURL,
  	    map : map,
  	    title : planInfo.title
  	  });
  		
  		return marker;
		}
  	
  	function testAPI(map, startInfo, endInfo, viaInfo) {
  		var line_arr = [];
			var headers = [];
			var realTime = getRealTime();
			var viaPoints = [];
			let today = new Date();
			for(var i = 0; i < viaInfo.length; i++) {
				
				var viaPoint = {};
				
				viaPoint.viaPointId = "경유지" + (i + 1);
			  viaPoint.viaPointName = viaInfo[i].title;
			  viaPoint.viaX = viaInfo[i].mapY;
			  viaPoint.viaY = viaInfo[i].mapX;
			  viaPoints.push(viaPoint);
			}
			headers["appKey"] = "l7xxdc109d32e488487dbf0e29b9dfcf1a59";
			
			$.ajax({
		    type : "POST",
		    headers : headers,
		    url : "https://apis.openapi.sk.com/tmap/routes/routeOptimization10?version=1&format=json",
		    async : false,
		    contentType : "application/json",
		    data : JSON.stringify({
		    	"reqCoordType": "WGS84GEO",
				  "resCoordType" : "WGS84GEO",
		    	"startName": startInfo.title,
		      "startX": startInfo.mapY,
		      "startY": startInfo.mapX,
		      "startTime": realTime,
		      "endName": endInfo.title,
		      "endX": endInfo.mapY,
		      "endY": endInfo.mapX,
		      "searchOption" : "0",
		      "viaPoints": viaPoints
		    }),
		    success : function(response) {
		    	var resultData = response.properties;
		      var resultFeatures = response.features;
		      var tDistance = "총 거리 : " + (resultData.totalDistance/1000).toFixed(1) + "km,  ";
		      var tTime = "총 시간 : " + Math.round((resultData.totalTime/60)) + "분  <br />";
		      var routeName = "최적 경로 : " + (resultFeatures[0].properties.viaPointName).substring(4, ((resultFeatures[0].properties.viaPointName).length)) + " -> ";
		      
		      for(var i = 0; i < resultFeatures.length; i++) {
		    	  var geometry = resultFeatures[i].geometry;
		        var properties = resultFeatures[i].properties;
		        var polyline;
		        
		        console.log(geometry);
		        
		        drawInfoArr = [];
		       
		        if(geometry.type == 'LineString') {
		        	
		        	for(var j = 0; j < geometry.coordinates.length; j++) {
		        		
		        		var point = new Tmapv2.LatLng(geometry.coordinates[j][1], geometry.coordinates[j][0]);
		        		
		        		drawInfoArr.push(point);
		        	}
			        polyline = new Tmapv2.Polyline({
			        	path : drawInfoArr,
			        	strokeColor : "#FF0000",
		            strokeWeight : 6,
		            map : map
			        });
		        
		        	line_arr.push(polyline);
		        
		       	 	routeName += (properties.viaPointName).substring(4, ((properties.viaPointName).length)) + " -> ";
						}
		      }
		      routeName = routeName.substring(0, (routeName.length - 4));
		      $('#result').html(tDistance + tTime + routeName);
		    }
		  });
			
			return line_arr;
		}
  	
  	function getRealTime() {
  	  
  		var today = new Date();
  	  var year = today.getFullYear();
  	  var month = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
  	  var date = (today.getDate() < 10 ? '0' : '') + today.getDate();
  	  var hour = (today.getHours() < 10 ? '0' :'') + today.getHours();
  	  var min = (today.getMinutes() < 10 ? '0' : '') + today.getMinutes();
  	  var realTime = year + month + date + hour + min;
  	  
  	  return realTime;
  	}

  	function calcPlanDay(allInfoStartDay, instanceStartDay, allInfoPlanDay) {
  	 
	  	var stDate = new Date(parseInt(allInfoStartDay.substr(0, 4)), parseInt(allInfoStartDay.substr(5, 2)) - 1, parseInt(allInfoStartDay.substr(8, 2)));
	 	  var endDate = new Date(parseInt(instanceStartDay.substr(0, 4)), parseInt(instanceStartDay.substr(5, 2)) - 1, parseInt(instanceStartDay.substr(8, 2)));
	 	  var flag = stDate <= endDate;
	 	  var result = 0;
	 	  
	 	  if(flag) {
	 	    
	 		  var btMs = endDate.getTime() - stDate.getTime();
	 	    
	 		  btDay = btMs / (1000 * 60 * 60 * 24);
	 		  result = btDay + parseInt(allInfoPlanDay);
	 	  } else {
	 	    
	 		  var btMs = stDate.getTime() - endDate.getTime();
	 	    
	 		  btDay = btMs / (1000 * 60 * 60 * 24);
	 		  result = parseInt(allInfoPlanDay) - btDay;
	 	  }
	 	  return result;
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
  	
  	.bottom-calendar { 
  		overflow: hidden;
  		height: auto;
  		padding: 24px 32px 16px 32px; 
  	}

		.right-planlist { 
			background : white;
			overflow-y: hidden;
			overflow: auto;
			height: 400px;
			padding: 15px; 
		}
		
		ul { 
			list-style: none;
			padding: 0;
			margin: 0;
		}
		
		.right-planlist li { 
			border : none;
		}
		
  	.container .header {
  		position: relative;
  	}
  	
  	.container .result {
  		margin: 0;
  	}
  	.container .tab {
			position: absolute;
			top: 0px;
			right: 204px;  	
  	}
  	
  	.container .plan-item {
  		position: relative;
  		margin-bottom: 16px;
  	}
  	
  	.container .plan-item h5 {
  		margin: 0;
  	}
  	
  	.container .plan-item button {
  		position: absolute;
  		top: 0px;
  		right: 0px;
  		padding: 2px 7px;
  	}
  	
  	.container .plan-item hr {
  		margin: 12px 0;
  	}
  	
  	.container .tab input {
    	display: none;
    }
  	
  	.container .tab label {
    	display: inline-block;
    	width: 150px;
    	height: 37px;
    	padding: 0;
    	margin: 0;
    	text-align: center;
    	cursor: pointer;
    	position: relative;
    	background: #ccc;
    }
    
    .container .tab label::before {
    	content: '세부 일정';
    	font-size: 16px;
    	display: block;
    	width: 75px;
    	height: 37px;
    	position: absolute;
    	background: white;
    	line-height: 37px;
    	transition: 0.3s;
    	z-index: 999;
    }
   	
    .container .tab input:checked + label:before {
    	transform: translateX(75px);
    	content: '일정 정보';
    }
  	
  	.container .tab .first {
  		position: absolute;
  		top: 6px;
  		left: 13px;
  		color: #efefef;
  	}
  	
  	.container .tab .second {
  		position: absolute;
  		top: 6px;
  		left: 88px;
  		color: #efefef;
  	}
  	
  	.container .planner-img img{
  		margin: 20px 97px;
  		border-radius: 50%;
  	}
  	
  	.container ::-webkit-scrollbar {
      width: 5px;
      height: 7px;
    }

    .container ::-webkit-scrollbar-button {
      width: 0px;
      height: 0px;
    }

    .container ::-webkit-scrollbar-thumb {
      background: #525965;
      border: none;
    }
  </style>
</head>
<body>
	<!-- Header -->
  <c:import url="/WEB-INF/view/include/header.jsp"/>
  
  <!-- Main -->
	<input type="hidden" id="planNo" value="${plan_no }">
	<input type="hidden" id="user_no" value="${loginUserDTO.user_no }">
	<div class="container jumbotron" style="margin-top: 120px; padding: 24px 32px 32px;">
		<div class="header">
			<h4 id="plan-title">${planDTO.plan_title }</h4>
			<div class="tab">
				<input type="checkbox" id="switch">
    		<label for="switch">
    			<span class="first">세부 일정</span>
    			<span class="second">일정 정보</span>
    		</label>
			</div>
		</div>
		<div class="row">
			<div class="col-md-8">
				<div id="tmap_api" style="width: 90%"></div>
			</div>
			<div class="col-md-4 right-planlist">
				<div id="plan-info">
					<c:forEach begin="1" end="${planTotalDate }" var="i">
						<div class="plan-item">
							<h5>Day ${i }</h5>
							<hr>
							<ul id="day${i }">
								<c:set var="day" value="${i }"/>
								<c:forEach items="${planList }" var="UserPlanDTO" varStatus="status">
									<c:if test="${UserPlanDTO.planDay == day}">
										<li class="ui-state-default" id='${status.index }'>
											<div class="row">
												<input type="hidden" name="planData" value='${UserPlanDTO }'>
												<div class="col-lg-4">
													<img class="img-responsive" id="r_photo${status.index }" onclick="" style="cursor: pointer;" src="${UserPlanDTO.img_src }" alt=""  width="100" height="75">
												</div>
												<div class="col-lg-8">
													<span id="r_title${status.index }" style="font-size: 12pt;">${UserPlanDTO.title }</span><br>
													<span id="r_addr${status.index }" style="font-size: 10pt;">${UserPlanDTO.addr }</span>
												</div>
											</div>
											<hr>
										</li>
									</c:if>
									<c:if test="${UserPlanDTO.is_insertAfter eq 'Y'}">
										<input type="hidden" name="scheduleData" value='${list }'>
									</c:if>
								</c:forEach>
							</ul>
							<button type="button" class="btn btn-primary optimize" value="optimize">최적화</button>
						</div>			
					</c:forEach>	
				</div>
				<div id="planner-info" style="display: none;">
					<div class="planner-img" style="padding-bottom: 10px;">
						<img id="img-planner" alt="" src="${planDTO.plan_img }" style="width: 139px; height: 139px">
					</div>
					<form id="upload-form" method="post" action="" enctype="multipart/from-data">
						<div class="form-group">	
							<input type="file" style="padding: 5px;" id="upload_img" class="form-control" name="upload_img">
							<input type="hidden" id="plan_no" name="plan_no" value="${plan_no }">
						</div>
					</form>
					<div class="form-group">
						<label for="plan_info">일정 제목</label>
						<input type="text" id="plan_title" class="form-control" name="plan_title" value="${planDTO.plan_title }" style="width: 100%; max-height: 70px;">
					</div>
					<div class="form-group">
						<label for="plan_info">일정 소개</label>
						<textarea id="plan_info" class="form-control" name="plan_info" rows="5" style="width: 100%; max-height: 70px;">${planDTO.plan_info }</textarea>
					</div>
					<button id="modify-planner" class="btn btn-primary" type="button" style="padding: 2px 7px; margin-left: 270px;">일정 수정</button>
				</div>
			</div>
		</div>
		<div>
			<p id="result" class="result"></p>
		</div>
	</div>
	<div class="container bottom-calendar jumbotron" style="margin-bottom: 100px;">
		<div id="scheduler">
		
		</div>
		<c:if test="${isModify == 'N'}">
			<div id="btn-save">
				<button type="button" id="btn-save" class="btn btn-primary" style="margin-top: 16px; float: right">저장</button>
			</div>
		</c:if>
		<c:if test="${isModify == 'Y'}">
			<div id="btn-modify">
				<button type="button" id="btn-modify" class="btn btn-success" style="margin-top: 16px; float: right">수정</button>
			</div>
		</c:if>
	</div>
	<form action="/schedule/writeDetail_proc" method="post" id="scheduleForm">
		<input type="hidden" id="schedule-plan" name="schedule" value="">
	</form>
	<form action="/schedule/modify" method="get" id="ModifyForm">
		<input type="hidden" id="planNo" name="plan_no" value="${plan_no }">
	</form>	
	
	<!-- Footer -->
  <c:import url="/WEB-INF/view/include/footer.jsp" />
</body>
</html>