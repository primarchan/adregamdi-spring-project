


/* 마이페이지 일정삭제*/
$(function() {
	$('.delete').click(function() {
		if(confirm("일정을 삭제하시겠습니까?")) {
			var plan_no = $(this).val();
			$.ajax({
				url : "/schedule/delete",
				type : "POST",
				dataType : "text",
				data : {"plan_no" : plan_no},
				success : function(data) {
					alert('일정이 삭제되었습니다!');
					location.href="/user/my_page"
				}
			});
		}
	});
});

