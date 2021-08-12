package com.adregamdi.dto;

import lombok.Data;

@Data
public class FreedomReplyDTO {
	//댓글 번호
	private int reply_num;
	
	//댓글이 달린 게시글 번호
	private int freedom_num;
	
	//댓글의 작성자 아이디
	private String reply_writer;
	
	//댓글의 내용
	private String reply_content;
	
	//댓글이 작성된 날짜
	private String reply_date;
}
