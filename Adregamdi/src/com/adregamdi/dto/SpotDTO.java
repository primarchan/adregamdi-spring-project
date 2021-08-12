package com.adregamdi.dto;

import lombok.Data;

@Data
public class SpotDTO {
	
	private int like_idx;
	private String content_id;
	private int like_cnt;
	private int review_cnt;
	
	public SpotDTO() {
		like_cnt = 0;
		review_cnt = 0;
	}
}
