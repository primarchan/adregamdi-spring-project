package com.adregamdi.service;

import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.adregamdi.dao.FreedomBoardDAO;
import com.adregamdi.dto.FreedomBoardDTO;
import com.adregamdi.dto.FreedomReplyDTO;
import com.adregamdi.dto.PageDTO;

@Service
public class FreedomBoardService {
	
	@Autowired
	FreedomBoardDAO freedomBoardDAO;
	
	// 한페이지당 보여주는 글의 개수
	@Value("${page.listcnt}")
	private int page_listcnt;
	
	// 한 페이지당 보여주는 페이지의 개수
	@Value("${page.pagination}")
	private int page_pagination;
	
	// 페이징 작업 게시글 목록 불러오는 함수
	public List<FreedomBoardDTO> getFreedomBoardList(int page){
		int start = (page - 1) * page_listcnt;
		RowBounds rowBounds = new RowBounds(start, page_listcnt);
		
		List<FreedomBoardDTO> contentList = freedomBoardDAO.getFreedomBoardList(rowBounds);
		return contentList;
	}
	
	// 크으... 미련하게 List<FreedomBoardDTO>로 받고 있었어.... 
	public FreedomBoardDTO getFreedomBoardContent(int content_idx) {
		FreedomBoardDTO content = freedomBoardDAO.getFreedomBoardContent(content_idx);
		return content;
	}
	
	//게시글 글제목으로 검색해서 가져오는 함수
	public List<FreedomBoardDTO> getSearchKeyObjectFreedomBoardList(String keywords, int page) {
		int start = (page - 1) * page_listcnt;
		RowBounds rowBounds = new RowBounds(start, page_listcnt);
		List<FreedomBoardDTO> contentList = freedomBoardDAO.getSearchKeyObjectFreedomBoardList(rowBounds, keywords);
		return contentList;
	}
	
	//게시글 제목 + 내용으로 검색해서 가져오는 함수
	public List<FreedomBoardDTO> getSearchKeyObejctContentFreedomBoardList(String keywords, int page) {
		int start = (page - 1) * page_listcnt;
		RowBounds rowBounds = new RowBounds(start, page_listcnt);
		List<FreedomBoardDTO> contentList = freedomBoardDAO.getSearchKeyObejctContentFreedomBoardList(rowBounds, keywords);
		return contentList;
	}
	
	//게시글 아이디로 검색해서 가져오는 함수
	public List<FreedomBoardDTO> getSearchKeyIdFreedomBoardList(String keywords, int page) {
		int start = (page - 1) * page_listcnt;
		RowBounds rowBounds = new RowBounds(start, page_listcnt);
		List<FreedomBoardDTO> contentList = freedomBoardDAO.getSearchKeyIdFreedomBoardList(rowBounds, keywords);
		return contentList;
	}
	
	public int GetFreedomBoardContentCount() {
		int contentCount = freedomBoardDAO.GetFreedomBoardContentCount();
		return contentCount;
	}
	
	//게시글 작성
	public void InsertFreedomBoardContent(FreedomBoardDTO freedomBoardDTO) {
		freedomBoardDAO.InsertFreedomBoardContent(freedomBoardDTO);
	}
	
	//게시글 수정
	public void ModifyFreedomBoardContent(FreedomBoardDTO freedomModifyDTO) {
		freedomBoardDAO.ModifyFreedomBoardContent(freedomModifyDTO);
	}
	
	//(구)게시글 삭제시 패스워드 받던 컨트롤러
	public String GetFreedomBoardPassword(int content_idx) {
		String password = freedomBoardDAO.GetFreedomBoardPassword(content_idx);
		return password;
	}
	
	//게시글 삭제
	public void FreedomBoardDeleteContent(int content_idx) {
		freedomBoardDAO.FreedomBoardDeleteContent(content_idx);
	}
	
	//페이징 관련
	public PageDTO getContentCnt(int currPage) {
		int contentCnt = freedomBoardDAO.GetFreedomBoardContentCount();
		PageDTO tumpPageDTO = new PageDTO(contentCnt, currPage, page_listcnt, page_pagination);
		return tumpPageDTO;
	}
	
	//게시글 제목으로 검색시 페이징
	public PageDTO getSearchKeyObjectCount(String keywords, int currPage) {
		int contentCnt = freedomBoardDAO.getSearchKeyObjectCount(keywords);
		PageDTO tumpPageDTO = new PageDTO(contentCnt, currPage, page_listcnt, page_pagination);
		return tumpPageDTO;
	}
	
	public int getSearchKeyObjectCnt(String keywords) {
		int contentCnt = freedomBoardDAO.getSearchKeyObjectCount(keywords);
		return contentCnt;
	}
	
	public int getSearchKeyObjectContent(String keywords) {
		int contentCnt = freedomBoardDAO.getSearchKeyObjectContent(keywords);
		return contentCnt;
	}
	
	public int getSearchKeyIdCnt(String keywords) {
		int contentCnt = freedomBoardDAO.getSearchKeyIdCnt(keywords);
		return contentCnt;
	}
	
	//게시글 제목 + 내용으로 검색시 페이징2
	public PageDTO getSearchKeyObjectContent(String keywords, int currPage) {
		int contentCnt = freedomBoardDAO.getSearchKeyObjectContent(keywords);
		PageDTO tumpPageDTO = new PageDTO(contentCnt, currPage, page_listcnt, page_pagination);
		return tumpPageDTO;
	}
	
	//게시글 아이디로 검색시 페이징
	public PageDTO getSearchKeyId(String keywords, int currPage) {
		int contentCnt = freedomBoardDAO.getSearchKeyIdCnt(keywords);
		PageDTO tumpPageDTO = new PageDTO(contentCnt, currPage, page_listcnt, page_pagination);
		return tumpPageDTO;
	}
	
	public void viewCount(int content_idx) {
		freedomBoardDAO.viewCount(content_idx);
	}
	
	//게시글 삭제시 게시글에 작성된 댓글 삭제
	public void DeleteFreedomBoardWithReply(int content_idx) {
		freedomBoardDAO.DeleteFreedomBoardWithReply(content_idx);
	}
	
	//===================================== 댓글 관련 컨트롤러 =======================
	// 댓글 리스트 불러오기
	public List<FreedomReplyDTO> getFreedomReplyList(int free_num){
		List<FreedomReplyDTO> replyList = freedomBoardDAO.getFreedomReplyList(free_num);
		return replyList;
	}
	
	//댓글 입력
	public void InsertFreedomBoardReply(FreedomReplyDTO replyWriteDTO) {
		freedomBoardDAO.InsertFreedomBoardReply(replyWriteDTO);
	}
	
	//댓글 수정
	public void ModifyFreedomBoardReply(FreedomReplyDTO replyWriteDTO) {
		freedomBoardDAO.ModifyFreedomBoardReply(replyWriteDTO);
	}
	
	//댓글 삭제
	public void DeleteFreedomBoardReply(FreedomReplyDTO replyWriteDTO) {
		freedomBoardDAO.DeleteFreedomBoardReply(replyWriteDTO);
	}
	
	//댓글 수 조회
	public int GetFreedomBoardReplyCount(int free_num) {
		int reply_count = freedomBoardDAO.GetFreedomBoardReplyCount(free_num);
		return reply_count;
	}
}
