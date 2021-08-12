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
  <title>어드레 감디 | ${readContentDTO.free_title}</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>
  <link rel="stylesheet" href="${root}css/freedomBoard.css">
  <script type="text/javaScript" src="${root}js/freedomBoard.js?ver=1"></script>
  <script type="text/javaScript">
  function delContent(){
	  let result = confirm("작성한 글을 삭제 하시겠습니까?")
	  if(result == true){
		  location.href='${root}freedom/deleteProc?content_idx=${readContentDTO.free_no}';
	  }
  }
  
  function ModContent(){
	  location.href='${root}freedom/modify?content_idx=${readContentDTO.free_no}';
  }
  
  function SeeTheList(){
	  location.href="${root}freedom/list";
  }
  </script>
  <style type="text/css">
  	#btnReplySave {
  		height: 78px;
  		width: 100%;
  	}
  	
  	#reply_content {
  		width: 100%;
  	}
  </style>
</head>
<body>
	<!-- Header Import -->
	<c:import url="/WEB-INF/view/include/header.jsp" />
	
	<input type="hidden" id="content_idx" value="${content_idx }" >
	<div class="container" style="margin-top: 150px; margin-bottom: 150px;">
	<div class="card shadow">
		<div class="card-header" style="padding:30px 30px 0 30px;">
			<h3 class="InputSubject">
      		<b>${readContentDTO.free_title}</b>
    		</h3>
    		<h6 style="margin-top: 15px;">${readContentDTO.content_writer_id}&nbsp;&nbsp;&nbsp;&nbsp;${readContentDTO.content_date}</h6>
		</div>
		<div class="card-body" style="margin-top:10px; padding:40px;">
			<form class="form-horizontal" name="freedomWriteDTO" id="freedomWriteDTO" action="${root}freedom/writeProc" method="POST">
    			<input type="hidden" id="loginState" name="loginState" value="${loginUserDTO.userLogin}" />
        		<input type="hidden" id="provider" name="provider" value="${loginUserDTO.user_provider}" />
        		<input type="hidden" id="reply_count" name="reply_count" value="${readContentDTO.reply_count}"/>
    		<div class="form-group" style="margin-bottom: 30px;">
      			<div class="mb-3">
        			${readContentDTO.free_content}
      			</div>
    		</div>
    		<hr><br>
    	<div class="form-group float-right">
    	    <button type="button" class="btn btn-info" style="margin-right : 5px;" onclick="SeeTheList();">목록보기</button>
    	    <c:if test="${loginUserDTO.userLogin == true}">
              <c:if test="${ loginUserDTO.user_no == readContentDTO.free_content_writer_idx || loginUserDTO.user_provider == 0}" >
                <button type="button" class="btn btn-success" style="margin-right : 5px;" onclick="ModContent();">수정하기</button>
                <button type="button" class="btn btn-danger" style="margin-right : 5px;" onclick="delContent();">삭제하기</button>
              </c:if>
            </c:if>
    	</div>
    	</form>
		</div> 
	</div>
     
      <div class="card shadow" style="margin-top: 50px">
      	<div class="card-body" style="padding: 40px;">
		      <h6><b>댓글 등록</b></h6>
		      <hr>
		      <div class="form-group" style="padding-top : 20px;">
		        <form:form method="post" modelAttribute="replyWriteDTO" class="form-horizontal">
		        	<form:hidden path="reply_writer" id="reply_writer" value="${loginUserDTO.user_id}" />
		        	<form:hidden path="freedom_num" id="freedom_num" value="${readContentDTO.free_no}" />
		        	<div class="row" style="padding-bottom: 24px;">
			        	<div class="col-sm-11">
			        		<form:textarea path="reply_content" id="reply_content" rows="3"></form:textarea>
			        	</div>
			        	<div class="col-sm-1" style="padding: 0px;" >
			        		<form:button type="button" path="btnReplySave" id="btnReplySave" class="btn btn-primary" onclick="" >댓글등록</form:button>
			        	</div>
		        	</div>
		        </form:form> 
		        <!-- Reply List {s}-->
			 	  
					  <h6 class="border-bottom" style="padding-bottom: 16px; margin: 0px;"><b>댓글 목록 (<span id="replyCount"></span>)</b></h6>
			 	  	<div id="replyList"></div>
			 	  	<span id="noneReply"></span>
			 	  </div>
		    </div>
      </div>
   </div>
   <!-- Footer -->
	 <c:import url="/WEB-INF/view/include/footer.jsp" />
</body>
</html>