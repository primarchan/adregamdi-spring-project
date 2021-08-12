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
  <title>어드레 감디 | 게시글 작성</title>
  <!-- bootstrap  -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>
  <script type="text/javascript" src="${root}ckeditor/ckeditor.js"></script>
  <link rel="stylesheet" href="${root}css/freedomBoard.css">
  <script>
  	function formSubmit(){
  			const check_title = $("#free_title").val();
			const check_content = CKEDITOR.instances.free_content.getData();
  			
			if(check_title == ""){
  				alert("제목을 입력해주세요 !");
  				event.preventDefault();
  				return;
  			} else if(check_content == ""){
  				alert("내용을 입력해주세요 !");
  				event.preventDefault();
  				return;
  			} else if(check_title != "" && check_content != ""){
  				$("#freedomWriteDTO").submit();
  			} 
  	}
  
  	function cancelfunc(){
  		const choice = confirm("작성하시는 글은 저장이 안됩니다 나가시겠습니까?");
  		if(choice == true){
  			location.href="${root}freedom/list";	
  		} else {
  			return;
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
    <b>게시글 작성</b>
  </h3>
  <hr><br>
  <form class="form-horizontal" name="freedomWriteDTO" id="freedomWriteDTO" action="${root}freedom/writeProc" method="POST">
    <div class="form-group" style="margin-bottom: 30px;">
      <div class="mb-3">
        <label for="label_title" style="font-size:1.1em; margin-left: 5px; padding-bottom: 5px;"><b>제 목</b></label>
        <input class="form-control" type="text" id="free_title" name="free_title" >
      </div>
    </div>
    <div class="form-group" style="margin-bottom: 30px;">
      <div class="mb-3">
        <label for="label_content" style="font-size:1.1em; margin-left: 5px; padding-bottom: 5px;"><b>내 용</b></label>
        <textarea class="form-control" id="free_content" name="free_content"></textarea>
        <script>
        	CKEDITOR.replace('free_content',{
        		filebrowserUploadUrl : '${root}freedom/fileUpload'
        	});
        </script>
      </div>
    </div>
    <div class="form-group float-right">
      <button type="button" id="form_submit" class="btn btn-success" style="padding : 4px; margin-right : 5px;" onclick="formSubmit();">작성완료</button>
      <button type="button" id="write_cancel" class="btn btn-danger" style="padding-top : 4px; padding-bottom: 4px;" onclick="cancelfunc();">취소</button>
    </div>
  </form>
</div>
<!-- Footer -->
<c:import url="/WEB-INF/view/include/footer.jsp" />
</body>
</html>