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
			var schedule = [];
			var start = 9;
			var end = 10;
			var present_markers = [];
			
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
						date = firstDate;
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
			
			$("input:checkbox").on('click', function() {
				if ( $(this).prop('checked') ) {
					$('#planner-info').show();
				  $('#plan-info').hide(); 
				} else {
					$('#planner-info').hide();
				  $('#plan-info').show();
				}
			});
			
		 	$('#plan-info').find('button').click(function(){
		  	
			 	if(present_markers != "") {
	    		present_markers.forEach(function(marker) {
	    			marker.setMap(null);
	    		});
		    }
			   
			  var jsonData = [];
		    var viaData = [];
			    
		    $(this).siblings('ul').sortable().find('input[name=planData]').each(function(){
		    	jsonData.push(JSON.parse($(this).val()));
		    });
	
		    for(var i = 0; i < jsonData.length; i++) {
		    	present_markers.push(addMarker(map, jsonData[i]));
		    }
		  });
		 	
	 	  var calendarDate = allInfo[0].planDate.split('-');
		  var instance;
		  var date = allInfo[0].planDate.split('-');
		  var day = date[2] - (allInfo[0].planDay - 1);
		  
		  if($("#modify-state").val() == 'Y') {
			  instance = $("#scheduler").dxScheduler({
				  dataSource : schedule,
				  views: [{ name : "여행 일정표", type : "agenda"}],
						currentView : "여행 일정표",
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
				  views: [{ name : "여행 일정표", type : "agenda"}],
					  currentView : "여행 일정표",
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
  	
  	function addMarker(map, planInfo) {
  		
  		var marker = new Tmapv2.Marker({
  	  	position : new Tmapv2.LatLng(planInfo.mapX,planInfo.mapY),
  	    map : map,
  	    title : planInfo.title
  	  });
  		
  		return marker;
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
  	
  	.container .planner-info {
			position: relative;
		}
		
		.container .planner-info span {
			position: absolute;
			top: 0;
			left: 0;
			background: rgba(0, 0, 0, 0.5);
			color: white;
			padding: 3px 6px;
			border-radius: 3px;
		}
  	
  	.container .planner-img img{
  		margin: 13px 97px;
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
	<input type="hidden" id="planNo" value="${planDTO.plan_no }">
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
							<c:forEach items="${userPlanList }" var="UserPlanDTO" varStatus="status">
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
							</c:forEach>
						</ul>
						<button type="button" class="btn btn-primary optimize" value="optimize">위치보기</button>
					</div>			
				</c:forEach>	
			</div>
				<div id="planner-info" class="planner-info" style="display: none;">
					<span>${planTotalDate - 1 } 박 ${planTotalDate } 일</span>
					<div class="planner-img">
						<img id="img-planner" alt="" src="${planDTO.plan_img }" style="width: 139px; height: 139px">
					</div>
					<div class="form-group">
						<label for="plan_info">일정 제목</label>
						<input type="text" id="plan_title" class="form-control" name="plan_title" value="${planDTO.plan_title }" style="width: 100%; max-height: 70px;" readonly>
					</div>
					<div class="form-group">
						<label for="plan_info">일정 소개</label>
						<textarea id="plan_info" class="form-control" name="plan_info" rows="5" style="width: 100%; max-height: 70px;" readonly>${planDTO.plan_info }</textarea>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="container bottom-calendar jumbotron" style="margin-bottom: 100px;">
		<div id="scheduler">
		
		</div>
		<div class="text-right" style="color: white;">	
			<c:choose>
				<c:when test="${page == 0 }">
					<a href="${root }user/my_page" class="btn btn-primary" style="margin-top: 15px;">목록으로</a>
				</c:when>
				<c:otherwise>
					<a href="${root }schedule/list?page=${page }" class="btn btn-primary" style="margin-top: 15px;">목록으로</a>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
  
  <!-- Footer -->
  <c:import url="/WEB-INF/view/include/footer.jsp" />
</body>
</html>