<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="root" value="${pageContext.request.contextPath }/"/>
<script type="text/javascript">
  alert('아이디와 비밀번호를 다시 확인해주세요.');
  location.href='${root}user/delete'
</script>