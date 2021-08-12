package com.adregamdi.dto;

import lombok.Data;

@Data
public class FreedomBoardDTO {
	//게시글 번호
	private int free_no;
	
	//게시글 작성자 번호
	private int free_content_writer_idx;
	
	//게시글 작성자 아이디
	private String content_writer_id;
	
	//게시글 제목
	private String free_title;
	
	//게시글 조회수
	private int free_cnt;
	
	//게시글 작성일
	private String content_date;
	
	//게시글 내용
	private String free_content;
	
	//작성자 비밀번호
	private String free_user_pw;
	
	//해당 게시글에 달린 댓글 갯수
	private int reply_count;
}