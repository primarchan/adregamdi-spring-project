function writeReview() {
	
	var contentId = $("#contentId").val();
	var content = $("#review_content").val();
	var param = {"contentId" : contentId, "content" : content};
	
	console.log("contentId : " + contentId);
	
	$.ajax({
		
		url: "/spot/write_proc",
		type: "get",
		dataType: "json",
		data: param,
		success:function(data) {
			
			console.log('댓글이 등록되었습니다 - !');
			
		}, 
		error: function(error) {
			alert('write 에러');
		}
	});
	location.reload();
}

function deleteReview(review_idx) {
	
	var review_idx = review_idx;
	var contentId = $("#hcontentId").val();
	var param = {"review_idx" : review_idx, "contentId" : contentId};
	
	$.ajax({
		
		url: "/spot/delete_proc",
		type: "get",
		dataType: "json",
		data: param,
		success:function() {
			alert("delete 완료!");
		}, 
		error: function(error) {
			alert('delete 에러');
		}
	});
	location.reload();
}