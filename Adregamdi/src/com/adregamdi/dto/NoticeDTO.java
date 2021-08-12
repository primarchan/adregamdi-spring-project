package com.adregamdi.dto;

import lombok.Data;

@Data
public class NoticeDTO {
	private int notice_rownum;
	private int notice_no;
	private int notice_user_no;
	private String content_notice_user_no;
	private String notice_title;
	private int notice_cnt;
	private String notice_date;
	private String notice_content;
	
	private int next_no;
	private String next_title;
	
	private int pre_no;
	private String pre_title;
	
}
