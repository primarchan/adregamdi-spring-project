<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="root" value="${pageContext.request.contextPath }/"/>
<script type="text/javascript">
  alert('회원탈퇴가 완료되었습니다. \n언제든지 다시 놀러오세요!');
  location.href='${root}'
</script>