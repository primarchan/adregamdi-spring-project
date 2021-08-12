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
  <title>어드레 감디 | 같이가치</title>
  <!-- Font Awesome CDN -->
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.3/css/all.css" integrity="sha384-SZXxX4whJ79/gErwcOYf+zWLeJdY/qpuqC4cAa9rOGUstPomtqpuNWT9wdPEn2fk" crossorigin="anonymous">

	<!-- Bootstrap CDN -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>
  <script>
  function login() {
	  alert('로그인 페이지로 이동합니다!');
	  location.href="${root }user/login";
  }
  
  function subscription() {
	  var to_no = $('#to_no').val();
	  var to_writer_no = $('#to_writer_no').val();
	  var sub_writer = $('#sub_writer').val();
	  var sub_message = $('#sub_message').val();
	  var param = {"to_no" : to_no, "to_writer_no" : to_writer_no, "sub_writer" : sub_writer, "sub_message" : sub_message };

	  $.ajax({
		  url : "/together/subcription",
		  type : "post",
		  dataType : "json",
		  data : param,
		  success : function(data) {
			  if(data == 0) {
				  alert('이미 동행을 신청하셨습니다.');
				  $("#before").hide();
				  $("#after").show();
			  }
			  if(data == 1) {
				  alert('동행 신청이 완료되었습니다.');
				  $("#before").hide();
				  $("#after").show();
			  }
		  }
	  })
  }
  
  function userMinus(user_no) {
	  
	  var to_no = $('#to_no').val();
	  var param = {"sub_writer" : user_no, "to_no" : to_no};
	  
		$.ajax({
			url: "/together/userMinus",
			type: "post",
			dataType: "json",
			data: param,
			success: function(data) {
				if(data) {
					alert('해당 참가자의 동행 탈퇴 처리가 완료되었습니다!');
				}
			}
		});
	}
  
  $(function() {
		
	  var confirmSub = $('#confirmSub').val();
		
	  if(confirmSub > 0) {
			$("#before").hide();
			$("#after").show();
		}
		
	  $("#message").keyup(function(e){if(e.keyCode == 13)  writeText(); });
	 	  
	  var together_num = $("#to_no").val();
	  var login_id = $("#login_id").val();
	  var allData = {"together_num" : together_num};
	
	  $.ajax({
	        url: "/together/getMessage",
	        type: "get",
	        dataType: "json",
	        data: allData,	        
	        
	        success: function(data) {
				
	        	$.each(data, function(key, val) {  
	        		console.log ("login_id : "+ login_id);
					
	        		if(login_id != data[key].reply_writer){
	        			console.log(login_id != data[key].reply_writer);
	        			var content = '<div class="myself">'
		        			+'<img style="width: 32px; height: 32px; border-radius: 32px;" src="/images/profile_black.png" >'
		        			+'<div class="box">'
		        			+'<p class="writer">' + data[key].reply_writer + '</p>'
		        			+'<p class="message">'+data[key].reply_content+'</p>'
		        			+'</div>'
		        			+'</div>';	
	        		}
	        		if(login_id == data[key].reply_writer) {
	        			console.log(data[key].reply_writer);
	        			var content =
	        				'<div class="myself-right">'
		        			+'<p class="message">'+data[key].reply_content+'</p>'
		        			+'</div>';
	        		}
					
	                $("#chat").append(content);
	            });	
	        	
	        },
	        error: function(error) {
	            //alert('message 에러');
	        }
	    });
  });
  
  function writeText() {
	
	var together_num = $("#to_no").val();
	var reply_writer = $("#login_id").val();
	var reply_content = $("#message").val();
	
	console.log("together_num : "+together_num);
	console.log("reply_writer : "+reply_writer);
	console.log("reply_content : "+reply_content);
	
	var allData = { "together_num": together_num, "reply_writer": reply_writer, "reply_content": reply_content};
	
	$.ajax({
        url: "/together/writeMessage",
        type: "get",
        dataType: "json",
        data: allData,
        
        
        success: function() {

        	alert('message 입력 완료 - !');
        },
        error: function(error) {
            //alert('message 에러');
        }
    });
	location.reload();
	 
  }
    
  function detail() {
		
		var contentId = $("#contentId").val();
		var contentTypeId = $("#contentTypeId").val();
		var param = {"contentId" : contentId, "contentTypeId" : contentTypeId};
		
		$.ajax({
			url : "/spot/details",
			type : "get",
			dataType : "json",
			data : param,
			success :function(data) {
				addModal(data, contentTypeId, contentId);
			}
		});
		
		$('#portfolioModal').modal("show");
	}
  
  function addModal(data, contentTypeId, contentId) {
		
		for(var i = 0; i < data.length; i++) {
			if(data[i] == null){
				data[i] = "";
			}
		}		
		
		$("#modalPhoto").attr("src",data[0]);
		$("#modalTitle").text(data[1]);
		$("#modalOverview").html(data[2]);
		$("#modalAddr").html(data[3]);
		$(".details").empty();
		
		switch(contentTypeId) {
		case "12" :
			$(".details").append("<li>문의 및 안내 : "+data[6]+"</li>");
			$(".details").append("<li>쉬는날 : "+data[7]+"</li>");
			$(".details").append("<li>이용시간 : "+data[8]+"</li>");
			break;
		case "14" :
			$(".details").append("<li>문의 및 안내 : "+data[6]+"</li>");
			$(".details").append("<li>이용요금 : "+data[7]+"</li>");
			$(".details").append("<li>이용시간 : "+data[8]+"</li>");
			break;
		case "15" :
			$(".details").append("<li>행사 홈페이지 : "+data[6]+"</li>");
			$(".details").append("<li>연락처 : "+data[7]+"</li>");
			$(".details").append("<li>공연시간 : "+data[8]+"</li>");
			$(".details").append("<li>이용요금 : "+data[9]+"</li>");
			break;
		case "25" :
			$(".details").append("<li>문의 및 안내 : "+data[6]+"</li>");
			$(".details").append("<li>코스 예상 소요시간 : "+data[7]+"</li>");
			$(".details").append("<li>코스 테마 : "+data[8]+"</li>");
			break;
		case "28" :
			$(".details").append("<li>문의 및 안내 : "+data[6]+"</li>");
			$(".details").append("<li>쉬는날 : "+data[7]+"</li>");
			$(".details").append("<li>이용요금 : "+data[8]+"</li>");
			$(".details").append("<li>이용시간 : "+data[9]+"</li>");
			break;
		case "32" :
			$(".details").append("<li>문의 및 안내 : "+data[8]+"</li>");
			$(".details").append("<li>체크인 : "+data[6]+"</li>");
			$(".details").append("<li>체크아웃 : "+data[7]+"</li>");
			$(".details").append("<li>홈페이지 : "+data[9]+"</li>");
			$(".details").append("<li>예약안내 : "+data[10]+"</li>");
			break;
		case "38" :
			$(".details").append("<li>문의 및 안내 : "+data[6]+"</li>");
			$(".details").append("<li>영업시간 : "+data[7]+"</li>");
			$(".details").append("<li>쉬는날 : "+data[8]+"</li>");
			break;
		case "39" :
			$(".details").append("<li>문의 및 안내 : "+data[7]+"</li>");
			$(".details").append("<li>대표 메뉴 : "+data[6]+"</li>");
			$(".details").append("<li>영업시간 : "+data[8]+"</li>");
			$(".details").append("<li>쉬는날 : "+data[9]+"</li>");
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
    
    #btnReplySave {
  		width: 100%;
  	}
  	
  	#reply_content {
  		width: 100%;
  	}
		.card-header {
			position: relative;
		}
		.card-header .detail {
			position: absolute;
			top: 11px;
			right: 20px;
			color: #8c8c8c;
		}
		
		.card-body {
			overflow: auto;
		}
  	.card-body .card-text {
			white-space: normal;
			display: -webkit-box;
			-webkit-line-clamp: 2;
			-webkit-box-orient: vertical;
			overflow: hidden;
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
		

    .card-body .myself {
    	position: relative;
    	display : inline-block;
    	width: 100%;
    	margin-bottom: 5px;        	
    }
    
    .card-body .myself-right {
    	position: relative;
    	display : inline-block;
    	width: 100%;
    	margin-bottom: 10px;
    }
    
    .card-body .myself .box {
    	float:left;
    	max-width: 75%;
    }
    
    .card-body .myself .box .writer {
    	font-size: 12px;
    	margin: 0;
    }
    
    .card-body .myself .message {
    	display: inline-block;
    	margin-bottom: 0px;
    	vertical-align : middle;
    	background-color : white;
    	padding: 5px;
    	border-radius: 5px;    
    }
    
    .card-body .myself-right .message {
    	position: relative;
    	display: inline-block;
    	float: right;
    	margin-bottom : 0px;
    	vertical-align : middle;
    	max-width: 70%;
    	background-color :#ffff1e;
    	padding: 5px;
    	border-radius: 5px;      	
    }       

    
    .card-body img {
    	float:left;
    	margin: 5px 5px 0 0;
    }
    
    .chat {
    	display: flex;
    	overflow: hidden;
    }
  </style>  
</head>
<body>
	<!-- Model -->
	<input type="hidden" name="to_writer" id="to_writer" value="${togetherDTO.to_writer }"/>
	<input type="hidden" name="login_id" id="login_id" value="${loginUserDTO.user_id }"/>
	<input type="hidden" name="to_no" id="to_no" value="${togetherDTO.to_no }">
	<input type="hidden" name="to_writer_no" id="to_writer_no" value="${togetherDTO.to_writer_no }">
	<input type="hidden" name="sub_writer" id="sub_writer" value="${loginUserDTO.user_no }">
	<input type="hidden" name="confirmSub" id="confirmSub" value="${confirmSub }">
	<!-- Header Import -->
	<c:import url="/WEB-INF/view/include/header.jsp" />
	
	<!-- Main -->
	<div class="container" style="margin-top: 150px; margin-bottom: 150px;">
	  <h3 class="BoardTitle">
	     <b>${togetherDTO.to_title }</b>
	  </h3>
	  <h6 style="margin-top: 15px">${togetherDTO.to_writer }&nbsp;&nbsp;&nbsp;&nbsp;${togetherDTO.to_date}</h6>
    <hr>
    <br>
    <div class="row no-gutters">
    	<div class="col-md-7">
       	<div class="card mr-3">
	        <div class="card-header">
	          <h6 class="card-title" style="padding: 0; margin: 0;">${place.title }</h6>
	          <span class="detail"><a href="#" onclick="detail();" style="color: #8c8c8c;">+ 더 보기</a></span>
	        </div>
	        <div class="row no-gutters">
	          <div class="col-md-4">
	          	<img alt="" src="${place.firstImage2 }" style="width: 100%;">
	          </div>
	          <div class="col-md-8">
	            <div class="card-body" style="padding: 12px;">
	              <p class="card-text" style="margin-bottom: 8px;">${place.addr1 }</p>
	              <p class="card-text" style="margin-bottom: 8px;">${place.overview }</p>
	              <input type="hidden" id="contentId" value="${place.contentId }">
	              <input type="hidden" id="contentTypeId" value="${place.contentTypeId }">
	            </div>
	          </div>
	        </div>
	      </div>
		    <div class="card mt-3 mr-3" style="padding: 20px;">
		      <div id="planner-info">
		        <div class="form-group">
		          <label for="plan_info">동행할 일정</label>
		          <input type="text" id="plan_title" class="form-control" name="plan_title" value="${togetherDTO.to_meet }" style="width: 100%; max-height: 70px;" disabled>
		        </div>
		        <div class="form-group">
		          <label for="plan_info">동행 내용</label>
		          <textarea id="plan_info" class="form-control" name="plan_info" rows="5" style="width: 100%; max-height: 70px;" disabled>${togetherDTO.to_content }</textarea>
		        </div>
		      </div>
		    </div>
		    <c:choose>
			   	<c:when test="${loginUserDTO.user_no == 0 }">
			   		<div class="card mt-3 mr-3">
				      <div class="card-body" style="padding: 20px;">
			      		<label for="sub_message">동행 신청</label>
				        <div class="input-group">
		              <input type="text" class="form-control" id="sub_message" name="sub_message" value="동행 신청은 로그인 후에 가능합니다..." disabled>
		              <div class="input-group-append">
			            	<a class="btn btn-primary" style="color: white;" onclick="login();">신청</a>
		            	</div>
		            </div>
				      </div>
				   	</div>
			   	</c:when>
			   	<c:when test="${(chatroomDTO.to_writer_no == loginUserDTO.user_no || chatroomDTO.user1 == loginUserDTO.user_no || chatroomDTO.user2 == loginUserDTO.user_no || chatroomDTO.user2 == loginUserDTO.user_no) && loginUserDTO.user_no != 0}">
			   		<div class="card mt-3 mr-3">
				      <div class="card-body" style="padding: 20px;">
				      	<label>동행 참가자 목록</label>
								<table class="table table-hover">
									<thead>
										<tr style="text-align: center;">
											<th scope="col" style="width: 20%;">번호</th>
											<th scope="col" style="width: 40%;">아이디</th>
											<th scope="col" style="width: 40%;">관리</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${userList }" var="userDTO" varStatus="status">
											<tr style="text-align: center;">
												<c:choose>
													<c:when test="${status.index == 0 }">
														<td><i class="fas fa-crown"></i></td>
													</c:when>
													<c:otherwise>
														<td>${status.index }</td>
													</c:otherwise>
												</c:choose>
												<td>${userDTO.user_id }</td>
												<c:choose>
													<c:when test="${status.index == 0 }">
														<td>-</td>
													</c:when>
													<c:otherwise>
														<c:choose>
															<c:when test="${chatroomDTO.to_writer_no == loginUserDTO.user_no }">
																<td>
																	<a href="#" onclick="userMinus(${userDTO.user_no })" style="color: red;"><i class="fas fa-user-minus"></i></a>
																</td>
															</c:when>
															<c:otherwise>
																<td>-</td>
															</c:otherwise>
														</c:choose>
													</c:otherwise>
												</c:choose>
											</tr>
										</c:forEach>
									</tbody>
								</table>
				      </div>
				   	</div>
			   	</c:when>
			   	<c:otherwise>
				    <div class="card mt-3 mr-3">
				      <div id="before" class="card-body" style="padding: 20px;">
			      		<label for="sub_message">동행 신청</label>
				        <div class="input-group">
		              <input type="text" class="form-control" id="sub_message" name="sub_message" placeholder="자신을 간단하게 소개해주세요...">
		              <div class="input-group-append">
			            	<button type="button" id="btnReplySave" class="btn btn-primary" onclick="subscription()">신청</button>
		            	</div>
		            </div>
				      </div>
				      <div id="after" class="card-body" style="padding: 20px; display: none;">
				      	<label for="sub_message">동행 신청</label>
				      	<h5 style="text-align: center; margin-top: 8px; color: #8c8c8c;"><i class="fas fa-exclamation-circle"></i> 이미 신청이 완료된 동행입니다...</h5>
				      </div>
				   	</div>
			   	</c:otherwise>
		   	</c:choose>
	  	</div>
      <div class="col-md-5 ">
        <div class="card" >
          <div class="card-header">
          	<h6 class="card-title" style="padding: 0; margin: 0;">채팅<span class="badge badge-secondary ml-2">${togetherDTO.to_curr } / ${togetherDTO.to_total }</span></h6>
          </div>
          <c:choose>
          	<c:when test="${(chatroomDTO.to_writer_no == loginUserDTO.user_no || chatroomDTO.user1 == loginUserDTO.user_no || chatroomDTO.user2 == loginUserDTO.user_no || chatroomDTO.user2 == loginUserDTO.user_no) && loginUserDTO.user_no != 0}">
			        <div class="card-body" style="height:500px; padding: 10px; background-color: #9bbbd4;">
			        	<div id="chat">
			        	</div>
			        </div>
			        <div class="card-footer" >
				        <div class="input-group">
				        	<input type="text" class="form-control" id="message" name="message" placeholder="입력...." >
				          <div class="input-group-append">
				          	<button type="button" id="btnReplySave" class="btn btn-primary" onclick="writeText()">입력</button>
				          </div>
				        </div>
			        </div>
		        </c:when>
		        <c:otherwise>
		        	<div class="card-body" style="height:500px; padding: 10px; background-color: #f5f5f5;">
			        	<h5 style="text-align: center; margin: 228px 0;">동행 신청이 수락된 후에 이용가능합니다...<i class="far fa-sad-tear"></i></h5>
			        </div>
			        <div class="card-footer" >
				        <div class="input-group">
				        	<input type="text" class="form-control" id="message" name="message" placeholder="동행 신청이 수락된 후에 이용가능합니다..." disabled>
				          <div class="input-group-append">
				          	<button type="button" id="btnReplySave" class="btn btn-primary" onclick="login()">입력</button>
				          </div>
				        </div>
			        </div>
		        </c:otherwise>
	        </c:choose>
      	</div>
    	</div>
   	</div>
   	<div class="form-group float-right" style="margin-top : 25px;">
   		<c:choose>
   			<c:when test="${chatroomDTO.to_writer_no == loginUserDTO.user_no}">
   				<a href="${root }together/list" class="btn btn-info" style="margin-right : 5px;">목록보기</a>
   				<a href="${root }together/modify?content_idx=${togetherDTO.to_no }" class="btn btn-success" style="margin-right : 5px;">수정하기</a>
   			</c:when>
   			<c:otherwise>
   				<a href="${root }together/list" class="btn btn-info" style="margin-right : 5px;">목록보기</a>
   			</c:otherwise>
   		</c:choose>
    </div>
 	</div>
     
  <!-- Modal -->
  <div class="portfolio-modal modal fade center" id="portfolioModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
	 				<h4 id="modalTitle" style="margin: 0;"></h4>
	 				<button type="button" class="close" data-dismiss="modal" aria-label="close">×</button>
	 			</div>
				<div class="container">
					<div class="modal-body">
						<img id="modalPhoto" class="img-fluid d-block mx-auto" src="" alt="..." />
						<h5 id="modalAddr" class="item-intro" style="margin: 20px 0;"></h5>
						<ul class="details" style="border: 3px solid #f5f5f5; border-radius: 10px; padding: 15px; margin: 0; list-style: none;">
						</ul>
						<div id="modalOverview" style="margin: 20px 0;">
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
  
  <!-- Footer -->
	<c:import url="/WEB-INF/view/include/footer.jsp" />
</body>
</html>