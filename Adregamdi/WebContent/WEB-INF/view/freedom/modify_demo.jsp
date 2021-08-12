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
  <title>어드레 감디 | 게시글 수정</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>
  <script type="text/javascript" src="${root}ckeditor/ckeditor.js"></script>
  <link rel="stylesheet" href="${root}css/freedomBoard.css">
   <script>
	 function submit(){
		 $("#freedomModifyDTO").submit();
	 }
	 
	 function cancelModi(){
		 let result = confirm("수정중인 사항은 저장되지 않습니다 그래도 나가시겠습니까?");
		 if(result == true){
			 location.href="${root}freedom/read?content_idx=${freedomModifyDTO.free_no}"; 
		 }
	 }
	 
	 CKEDITOR.config.height = 350;
  </script>
</head>
<body>
<!-- Header Import -->
<c:import url="/WEB-INF/view/include/header.jsp" />
  <div class="container" style="margin-top: 150px; margin-bottom: 150px;">
  <h3 class="InputSubject">
    <b>게시글 수정</b>
  </h3>
  <hr><br>
   <form class="form-horizontal" name="freedomModifyProcDTO" id="freedomModifyProcDTO" action="${root}freedom/modifyProc" method="POST">
    <div class="form-group" style="margin-bottom: 30px;">
      <div class="mb-3">
        <label for="free_title" style="font-size:1.1em; margin-left: 5px; padding-bottom: 5px;"><b>제 목</b></label>
        <input class="form-control" type="text" id="free_title" name="free_title" value="${freedomModifyDTO.free_title}">
        <input class="form-control" type="text" id="free_no" name="free_no" value="${freedomModifyDTO.free_no }" style="display:none;">
      </div>
    </div>
    <div class="form-group" style="margin-bottom: 30px;">
      <div class="mb-3">
        <label for="free_content" style="font-size:1.1em; margin-left: 5px; padding-bottom: 5px;"><b>내 용</b></label>
        <textarea class="form-control" id="free_content" name="free_content">${freedomModifyDTO.free_content}</textarea>
        <script>
        	CKEDITOR.replace('free_content',{
        		filebrowserUploadUrl : '${root}freedom/fileUpload'
        	});
        </script>
      </div>
    </div>
    <div class="form-group float-right">
      <button class="btn btn-success" style="padding : 4px; margin-right : 5px;" id="submit" onClick="submit();">수정완료</button>
      <button type="button" class="btn btn-danger" style="padding-top : 4px; padding-bottom: 4px;" id="cancel" onClick="cancelModi();">취소</button>
    </div>
  </form>
  </div>
  <!-- Footer -->
	<c:import url="/WEB-INF/view/include/footer.jsp" />
</body>
</html>