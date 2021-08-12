package com.adregamdi.dto;

import lombok.Data;

@Data
public class VisitKoreaDTO {
	private String pageNo;
	private String addr1;
	private String areaCode;
	private String contentId;
	private String contentTypeId;
	private String firstImage2;
	private String firstImage;
	private String mapX;
	private String mapY;
	private String sigunguCode;
	private String title;
	private String overview;
	private String totalCount;
	private String numOfRow;
	private int like_cnt;
	private int review_cnt;
	
	public VisitKoreaDTO() {
		like_cnt = 0;
		review_cnt = 0;
	}
}
