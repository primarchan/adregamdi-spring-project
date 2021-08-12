<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="root" value="${pageContext.request.contextPath }/" />
<script>
  alert('이미 회원가입된 사용자 입니다. \n (네이버를 통한 회원가입 여부 확인요망)')
  location.href = '${root}user/login'
</script>