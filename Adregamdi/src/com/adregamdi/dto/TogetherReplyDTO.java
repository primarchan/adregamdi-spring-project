package com.adregamdi.dto;

import lombok.Data;

@Data
public class TogetherReplyDTO {
	
	//채팅번호
	private int reply_num;
	
	// 게시글 번호
	private int together_num;
	
	// 채팅 작성자 아이디
	private String reply_writer;
	
	// 채팅 내용
	private String reply_content;
	
	// 채팅 입력 시간
	private String reply_date;
}
