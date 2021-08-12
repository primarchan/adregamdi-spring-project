<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="root" value="${pageContext.request.contextPath }/" />
<style>
  .navbar a {
     font-size: 25px;
     color:black;
  }
  
  a:hover{
  	text-decoration: none;
    color:orange;
  }
  
  .wrapper {
     position: relative;
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

      <nav class="navbar navbar-expand-md navbar-white fixed-top bg-white shadow sm" style="padding: 8px 30px;">
         <a href="${root }" class="navbar-brand pr-5"><img src="${root }images/logo.png" style="height: 60px"></a>
         <div id="navMenu" class="collapse navbar-collapse">
            <ul class="navbar-nav">
               <li class="nav-item mr-3"><a class="nav-link" href="${root }spot/main">여행지</a></li>
               <li class="nav-item mr-3"><a class="nav-link" href="${root }schedule/list?page=1">여행일정</a></li>
               <li class="nav-item mr-3"><a class="nav-link" href="${root }together/list">같이가치</a></li>
               <li class="nav-item mr-3"><a class="nav-link" href="${root }freedom/list">자유게시판</a></li>
               <li class="nav-item mr-3"><a class="nav-link" href="${root }notice/list">공지사항</a></li>
            </ul>
          <ul class="navbar-nav ml-auto">
            <c:choose>
              <c:when test="${loginUserDTO.userLogin == true }">
                <li class="nav-item"><a href="${root }user/my_to"
                  class="nav-link">마이페이지</a></li>
                <li class="nav-item"><a href="${root }user/logout"
                  class="nav-link">로그아웃</a></li>
              </c:when>
              <c:otherwise>       
                <li class="nav-item"><a href="${root }user/login"
                  class="nav-link">로그인</a></li>
                <li class="nav-item"><a href="${root }user/join"
                  class="nav-link">회원가입</a></li>
              </c:otherwise>    
            </c:choose>
          </ul>
         </div>
      </nav>
