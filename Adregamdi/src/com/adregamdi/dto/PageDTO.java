package com.adregamdi.dto;

import lombok.Getter;

@Getter
public class PageDTO {
	
	// 최소 페이지 번호
	private int min;
	
	// 최대 페이지 번호
	private int max;
	
	// 이전 버튼 누르면 이동하는 페이지 번호
	private int prevPage;
	
	// 다음 버튼 누르면 이동하는 페이지 번호
	private int nextPage;
	
	// 전체 페이지 개수
	private int pageCount;
	
	// 전체 게시글의 개수 - 추가 
	private int total;
	
	// 현재 페이지 번호
	private int currentPage;
	
	private boolean prev, next;
	
	// contentCnt : 전체 게시글의 개수
	// contentPageCnt : 페이지당 게시글의 개수
	// pagination : 페이지 버튼의 개수
	public  PageDTO(int contentCnt, int currentPage, int contentPageCnt, int pagination) {
		
		// 현재 페이지 번호
		this.currentPage = currentPage;
		
		// 전체 페이지 번호
		pageCount = contentCnt / contentPageCnt;
	
		if(contentCnt % contentPageCnt > 0) {
			pageCount++;
		}
		
		min = ((currentPage-1) / pagination) * pagination + 1;
		max = min + pagination - 1;
		
		if(max > pageCount) {
			max = pageCount;
		}
		
		prevPage = min - 1;
		nextPage = max + 1;
		
		if(nextPage > pageCount) {
			nextPage = pageCount;
		}
	}
	
	//				현재 페이지 번호	전체 개수		페이지당 게시글 개수
	public PageDTO(String currentPage, int total, int contentPageCnt) {
		this.currentPage = Integer.parseInt(currentPage);
		this.total = total;
		
		this.max = (int)(Math.ceil((this.currentPage*1.0)/contentPageCnt))*contentPageCnt;
		this.min = this.max - (contentPageCnt - 1);
		
		int realEnd = (int)(Math.ceil((total*1.0)/contentPageCnt));
		
		if(realEnd < this.max) {
			this.max = realEnd;
		}
		
		this.prev = this.min > 1;
		this.next = this.max < realEnd;
	}
}
