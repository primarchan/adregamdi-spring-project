$(function() {
		
		var keywordParam = { "pageNo" : 1, "numOfRow" : 5, "keyword" : ""};
		
		$(".flatpickr").flatpickr({
			enableTime:true,
			minDate: "today",
			dateFormat: "Y-m-d H:i"			
		});
		
		
		$(".btn-search").click(function(){
			
			keywordParam.pageNo = 1;
			
			var keyword = $("#search-field").val();
			
			if(keyword == "") {
				alert('검색어를 입력해주세요!');
				$("#search-field").focus();
				return false;
			}
			
			keywordParam.keyword = keyword;		
			
			$.ajax({
				url : "/together/keyword",
				type : "get",
				dataType : "json",
				data : keywordParam,
				
				success : function(data) {
					 
					if(data.length == 0) {
						alert('검색결과가 없습니다!');
						return false;
					}
					
					$("#search_view").empty();
					$(".sidebar-menu").show();
					
					var content = '<ul class="list-group">';
					$.each(data, function(key, val) {
						
						var result = {contentId : '' + data[key].contentId, title : '' + data[key].title};
						var item = JSON.stringify(result);
						
						content = "<li class='list-group-item' style='width: 100%; border: none;'>"
									+ "<h5><b>" + data[key].title + "</b></h5>" + data[key].addr1
									+ "<a href='#' class='card-btn btn btn-dark' onclick='addSpotId(" + item + ")' style='float:right; padding: 3px 6px;'>추가하기</a>"
									+ "<hr style='margin: 26px 0 0 0;'></li>";				
						$("#search_view").append(content);
					});
					$("#search_view").append("</ul>");
				},
				
				error : function(error) {
					alert("keyword 실패 - !");
				}				
			});			
		});	
		
		
		
		
		
		// 무한 스크롤
		$('.sidebar-menu').scroll(function() {
			
			if(Math.ceil($('.sidebar-menu').scrollTop() + $('.sidebar-menu').innerHeight()) == $('.sidebar-menu')[0].scrollHeight) {
		    	
				keywordParam.pageNo++;
				
				$.ajax({
					url : "/together/keyword",
					type : "get",
					dataType : "json",
					data : keywordParam,
					
					success : function(data) {
						
						var content = '<ul class="list-group">';
						$.each(data, function(key, val) {
							
							var result = {contentId : '' + data[key].contentId, title : '' + data[key].title};
							var item = JSON.stringify(result);
							
							content = "<li class='list-group-item' style='width: 100%; border: none;'>"
										+ "<h5><b>" + data[key].title + "</b></h5>" + data[key].addr1
										+ "<a href='#' class='card-btn btn btn-dark' onclick='addSpotId(" + item + ")' style='float:right; padding: 3px 6px;'>추가하기</a>"
										+ "<hr style='margin: 26px 0 0 0;'></li>";				
							$("#search_view").append(content);
						});
						$("#search_view").append("</ul>");
					},
					
					error : function(error) {
						alert("keyword 실패 - !");
					}				
				});			
		    	
			  }
		});
	});
	
	function addSpotId(item) {
		var contentId = item.contentId;
		var title = item.title;
		
		$(".sidebar-menu").hide();
		$(".findSpot").hide();
		$("#printSpot").show();
		$("#fixedSpotTitle").attr("value", title);
		$("#fixedSpotContentId").attr("value", contentId);
		$(".calendar").show();
		$("#number").hide();
	}
	
	function modifySpot() {
		$(".sidebar-menu").show();
		$(".findSpot").show();
		$("#search_view").empty();
		$("#search-field").attr("value", "");
		$("#printSpot").hide();
		$(".calendar").hide();
		$("#number").hide();
	}
	
	function writeMeetDate() {
		var meetDate = $("#meetDate").val();
		
		if(meetDate=="") {
			alert("날짜와 시간을 입력해주세요!");
			return;
		}
		
		$("#number").show();
	}
	
	function writePersonNumber() {
		
		var contentId = $("#fixedSpotContentId").val();
		var spotTitle = $("#fixedSpotTitle").val();
		var meetDate = $("#meetDate").val();
		var personNumber = $("#personNumber").val();
		
		console.log("contentId : "+contentId);
		console.log("meetDate : "+meetDate);
		console.log("personNumber : "+personNumber);
		
		
		$("#to_place").attr("value", contentId);
		$("#to_place_name").attr("value", spotTitle);
		$("#to_meet").attr("value", meetDate);
		$("#to_total").attr("value", personNumber);
	}
	
	function formSubmit(){
			const check_title = $("#to_title").val();
		const check_content = CKEDITOR.instances.to_content.getData();
			
		if(check_title == ""){
				alert("제목을 입력해주세요 !");
				event.preventDefault();
				return;
			} else if(check_content == ""){
				alert("내용을 입력해주세요 !");
				event.preventDefault();
				return;
			} else if(check_title != "" && check_content != ""){
				$("#togetherWriteDTO").submit();
			} 
	}

	function cancelfunc(){
		const choice = confirm("작성하시는 글은 저장이 안됩니다 나가시겠습니까?");
		if(choice == true){
			location.href="${root}together/list";	
		} else {
			return;
		}		
	}
	
	function submit() {
	  $("#togetherWriteDTO").submit();
  }