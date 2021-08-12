package com.adregamdi.service;

import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.adregamdi.dao.NoticeDAO;
import com.adregamdi.dto.NoticeDTO;
import com.adregamdi.dto.PageDTO;

@Service
public class NoticeService {

	@Autowired
	NoticeDAO noticeDAO;
	
	// 한페이지당 보여주는 글의 개수
	@Value("${page.listcnt}")
	private int page_listcnt;
	
	// 한 페이지당 보여주는 페이지의 개수
	@Value("${page.pagination}")
	private int page_pagination;
	
	// 공지사항 페이징 처리
	public List<NoticeDTO> getNoticeList(int page) {
		int start = (page - 1) * page_listcnt;
		RowBounds rowBounds = new RowBounds(start, page_listcnt);
		List<NoticeDTO> contentList = noticeDAO.getNoticeList(rowBounds);
		return contentList;
	}
	
	// 공지사항 이전 / 다음글
	public NoticeDTO getNextPrev(int content_idx) {
		NoticeDTO getNextPrev = noticeDAO.getNextPrev(content_idx);
		return getNextPrev;
	}
	
	// 공지사항 본문 내용
	public NoticeDTO getNoticeContent(int content_idx) {
		NoticeDTO content = noticeDAO.getNoticeContent(content_idx);
		return content;
	}
	
	// 공지사항 페이징
	public int GetNoticeContentCount() {
		int contentCount = noticeDAO.GetNoticeContentCount();
		return contentCount;
	}

	// 공지사항 글쓰기
	public void InsertNoticeContent(NoticeDTO noticeDTO) {
		noticeDAO.InsertNoticeContent(noticeDTO);
	}
    
	// 공지사항 수정
	public void ModifyNoticeContent(NoticeDTO noticeModifyDTO) {
		noticeDAO.ModifyNoticeContent(noticeModifyDTO);
	}

	// 공지사항 삭제
	public void DeleteNoticeContent(int content_idx) {
		noticeDAO.DeleteNoticeContent(content_idx);
	}
	
	// 공지사항 페이징
	public PageDTO getContentCnt(int currPage) {
		int contentCnt = noticeDAO.GetNoticeContentCount();
		PageDTO tumpPageDTO = new PageDTO(contentCnt, currPage, page_listcnt, page_pagination);
		return tumpPageDTO;
	}
	
	// 공지사항 조회수
	public void viewCount(int content_idx) {
		noticeDAO.viewCount(content_idx);
	}
	
	// 공지사항 제목으로 검색해서 가져오는 메서드
	public List<NoticeDTO> getSearchKeyObjectNoticeList(String keywords, int page) {
		int start = (page - 1) * page_listcnt;
		RowBounds rowBounds = new RowBounds(start, page_listcnt);
		List<NoticeDTO> contentList = noticeDAO.getSearchKeyObjectNoticeList(rowBounds, keywords);
		return contentList;
	}
	
	// 공지사항 제목 + 내용으로 검색해서 가져오는 메서드
	public List<NoticeDTO> getSearchKeyObejctContentNoticeList(String keywords, int page) {
		int start = (page - 1) * page_listcnt;
		RowBounds rowBounds = new RowBounds(start, page_listcnt);
		List<NoticeDTO> contentList = noticeDAO.getSearchKeyObejctContentNoticeBoardList(rowBounds, keywords);
		return contentList;
	}
	
	// 공지사항 제목으로 검색시 페이징
	public PageDTO getSearchKeyObjectCount(String keywords, int currPage) {
		int contentCnt = noticeDAO.getSearchKeyObjectCount(keywords);
		PageDTO tumpPageDTO = new PageDTO(contentCnt, currPage, page_listcnt, page_pagination);
		return tumpPageDTO;
	}
	
	
	// 공지사항 제목 + 내용으로 검색시 페이징
	public PageDTO getSearchKeyObjectContent(String keywords, int currPage) {
		int contentCnt = noticeDAO.getSearchKeyObjectContent(keywords);
		PageDTO tumpPageDTO = new PageDTO(contentCnt, currPage, page_listcnt, page_pagination);
		return tumpPageDTO;
	}
	
	// 공지사항 제목으로 검색시 게시물 개수
	public int getSearchKeyObjectCount(String keywords) {
		int contentCount = noticeDAO.getSearchKeyObjectCount(keywords);
		return contentCount;	
	}
	
	// 공지사항 제목 + 내용으로 검색시 게시물 개수
	public int getSearchKeyObjectContent(String keywords) {
		int contentCount = noticeDAO.getSearchKeyObjectContent(keywords);
		return contentCount;
	}
	

}
