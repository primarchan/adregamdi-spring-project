$(function() {

    var sigungu = $("#sigunguCode").val();
    var contentType = $("#contentTypeId").val();
    var pNum = $('input[name=currentPage]').val();
    var currentPage = $("#currentPage").val();
    
    
    var allData = { "pageNo": pNum, "sigunguCode": sigungu, "contentTypeId": contentType, "numOfRow": 9};

    /* 검색에 필요한 변수 추가 */
    var keyword_markers=[];
    // var map = initTmap();
    var keywordParam = { "pageNo" : 1, "numOfRow" : 21, "keyword" : ""};
    var keyword_flag = false;
    
    $.ajax({
        url: "/spot/best",
        type: "get",
        dataType: "json",
        data: allData,
        success: function(data) {

        	
            // 반복함수
            $.each(data, function(key, val) {  
            	
            	$("#bestContentId" + key).html(data[key].contentId);
            	$("#bestContentTypeId" + key).html(data[key].contentTypeId);
				$("#bestPhoto" + key).attr("src", data[key].firstImage);
				$("#bestTitle" + key).text(data[key].title);
                $("#bestAddr" + key).text(data[key].addr1);
                
            });
        },
        error: function(error) {
            alert('best 페이지 에러');
        }
    });
    
    // 무조건 화면에 띄워야함.
    $.ajax({
        url: "/spot/information",
        type: "get",
        dataType: "json",
        data: allData,
        success: function(data) {
            
        	$("#total_view").show();
    		$("#search_view").hide();
        	
            // 반복함수
            $.each(data, function(key, val) {  
            	
            	$("#contentId" + key).html(data[key].contentId);
            	$("#reviewSendContentId"+key).attr("href", "review?contentId="+data[key].contentId+"&contentTypeId="+data[key].contentTypeId);
            	$("#likeCnt" +key).html(data[key].like_cnt);
            	$("#reviewCnt"+key).html(data[key].review_cnt);
            	$("#contentTypeId" + key).html(data[key].contentTypeId);
				$("#photo" + key).attr("src", data[key].firstImage);
				$("#title" + key).text(data[key].title);
                $("#addr" + key).text(data[key].addr1);
                
            });
        },
        error: function(error) {
            alert('첫 페이지 에러');
        }
    });
    
    var actionForm = $("#actionForm");

    $(".paginate_button a").on("click", function(e) {
        e.preventDefault();
        actionForm.find("input[name='currentPage']").val($(this).attr("href"));
        actionForm.submit();
    });
    
	$("#btn-search").click(function(){
		
		keywordParam.pageNo = 1;
				
		$("#total_view").hide();
		$("#search_view").show();
		$("#total_page").hide();
		
		var keyword = $("#search-field").val();
		
		if(keyword == "") {
			alert('키워드를 입력하세요');
			$("#search-field").focus();
			return false;
		}
		
		keywordParam.keyword = keyword;
		
		$.ajax({				
			url : "/spot/keyword",
			type : "get",
			dataType : "json",
			data : keywordParam,
			
			success :  function(data){				
				
				$("#search_view").empty();
				
				$.each(data, function(key, val) {  
					
					var content = '<div class="col-lg-4 col-sm-6 mb-4">'
								+'<div class="portfolio-item">'
								+'<a class="portfolio-link" data-toggle="modal"href="#portfolioModal" onclick="searchDetail('+key+');">'
								+'<div class="portfolio-hover">'
								+'<div class="portfolio-hover-content">'
								+'<i class="fas fa-plus fa-3x"></i></div></div> '
								+'<img class="img-fluid photo" id="searchPhoto" src="'+data[key].firstImage+'" alt="..."></a>'
								+'<div class="portfolio-caption"><div id="searchTitle" class="portfolio-caption-heading">'+data[key].title+'</div>'
								+'<div id="searchAddr" class="portfolio-caption-subheading text-muted">'+data[key].addr1+'</div>'
								+'<span style="display: none" id="searchContentId'+key+'">'+data[key].contentId+'</span> '
								+'<span style="display: none" id="searchContentTypeId'+key+'">'+data[key].contentTypeId+'</span>'
								+'</div></div></div>';
					
	                $("#search_view").append(content);
	            });	
			},
			error : function(error) {
				alert("keyword 실패");
			}
		}); 
	});
	

});

function detail(idx) {
	
	var contentId = $("#contentId"+idx).html();
	var contentTypeId = $("#contentTypeId"+idx).html();
	var param = {"contentId" : contentId, "contentTypeId" : contentTypeId};
	
	$.ajax({
		
		url: "/spot/details",
		type: "get",
		dataType: "json",
		data: param,
		success:function(data) {
			
			testData(data,contentTypeId, contentId);
			
		}, 
		error: function(error) {
			alert('detail 에러');
		}
	});
}

function best_detail(idx) {
	
	var contentId = $("#bestContentId"+idx).html();
	var contentTypeId = $("#bestContentTypeId"+idx).html();
	var param = {"contentId" : contentId, "contentTypeId" : contentTypeId};
	
	console.log("idx : " + idx);
	
	$.ajax({
		
		url: "/spot/details",
		type: "get",
		dataType: "json",
		data: param,
		success:function(data) {
			
			testData(data,contentTypeId, contentId);
			
		}, 
		error: function(error) {
			alert('bestDetail 에러');
		}
	});
}

function searchDetail(idx) {
	
	var contentId = $("#searchContentId"+idx).html();
	var contentTypeId = $("#searchContentTypeId"+idx).html();
	var param = {"contentId" : contentId, "contentTypeId" : contentTypeId};
	
	$.ajax({
		
		url: "/spot/details",
		type: "get",
		dataType: "json",
		data: param,
		success:function(data) {
			
			
			testData(data,contentTypeId, contentId);
			
		}, 
		error: function(error) {
			alert('searchDetail 에러');
		}
	});
}

function testData(data, contentTypeId, contentId) {
	

	for(var i=0;i<data.length;i++){
		if(data[i] == null){
			data[i] = "";
		}
	}		
	
	$("#detailBtn").attr("href", "review?contentId="+contentId+"&contentTypeId="+contentTypeId);
	$("#modalPhoto").attr("src",data[0]);
	$("#modalTitle").text(data[1]);
	$("#modalOverview").html(data[2]);
	$(".details").empty().append("<li id='addr'>주소 : "+data[3]+"</li><br>");
	switch(contentTypeId) {
	case "12" :
		$(".details").append("<li>문의 및 안내 : "+data[6]+"</li><br>");
		$(".details").append("<li>쉬는날 : "+data[7]+"</li><br>");
		$(".details").append("<li>이용시간 : "+data[8]+"</li><br>");
		break;
	case "14" :
		$(".details").append("<li>문의 및 안내 : "+data[6]+"</li><br>");
		$(".details").append("<li>이용요금 : "+data[7]+"</li><br>");
		$(".details").append("<li>이용시간 : "+data[8]+"</li><br>");
		break;
	case "15" :
		$(".details").append("<li>행사 홈페이지 : "+data[6]+"</li><br>");
		$(".details").append("<li>연락처 : "+data[7]+"</li><br>");
		$(".details").append("<li>공연시간 : "+data[8]+"</li><br>");
		$(".details").append("<li>이용요금 : "+data[9]+"</li><br>");
		break;
	case "25" :
		$(".details").append("<li>문의 및 안내 : "+data[6]+"</li><br>");
		$(".details").append("<li>코스 예상 소요시간 : "+data[7]+"</li><br>");
		$(".details").append("<li>코스 테마 : "+data[8]+"</li><br>");
		break;
	case "28" :
		$(".details").append("<li>문의 및 안내 : "+data[6]+"</li><br>");
		$(".details").append("<li>쉬는날 : "+data[7]+"</li><br>");
		$(".details").append("<li>이용요금 : "+data[8]+"</li><br>");
		$(".details").append("<li>이용시간 : "+data[9]+"</li><br>");
		break;
	case "32" :
		$(".details").append("<li>문의 및 안내 : "+data[8]+"</li><br>");
		$(".details").append("<li>체크인 : "+data[6]+"</li><br>");
		$(".details").append("<li>체크아웃 : "+data[7]+"</li><br>");
		$(".details").append("<li>홈페이지 : "+data[9]+"</li><br>");
		$(".details").append("<li>예약안내 : "+data[10]+"</li><br>");
		break;
	case "38" :
		$(".details").append("<li>문의 및 안내 : "+data[6]+"</li><br>");
		$(".details").append("<li>영업시간 : "+data[7]+"</li><br>");
		$(".details").append("<li>쉬는날 : "+data[8]+"</li><br>");
		break;
	case "39" :
		$(".details").append("<li>문의 및 안내 : "+data[7]+"</li><br>");
		$(".details").append("<li>대표 메뉴 : "+data[6]+"</li><br>");
		$(".details").append("<li>영업시간 : "+data[8]+"</li><br>");
		$(".details").append("<li>쉬는날 : "+data[9]+"</li><br>");
		break;
	}
}

function likeProc(idx) {
	
	var contentId = $("#contentId"+idx).html();
	var param = {"contentId" : contentId};
	
	$.ajax({
		
		url: "/spot/likeProc",
		type: "get",
		dataType: "json",
		data: param,
		success:function(data) {
					
			console.log("like_btn : " + contentId) ;
			
			
		}, 
		error: function(error) {
			alert('likeProc 에러');
		}
	});
	
	location.reload();
	
}