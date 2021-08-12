package com.adregamdi.dao;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.adregamdi.dto.FreedomBoardDTO;
import com.adregamdi.dto.FreedomReplyDTO;
import com.adregamdi.dto.UserDTO;
import com.adregamdi.mapper.FreedomBoardMapper;

@Repository
public class FreedomBoardDAO {
	
	@Autowired
	FreedomBoardMapper freedomBoardMapper;
	
	@Resource(name="loginUserDTO")
	private UserDTO loginUserDTO;
	
	//게시글 목록 가져오는 함수
	public List<FreedomBoardDTO> getFreedomBoardList(RowBounds rowBounds) {
		List<FreedomBoardDTO> contentList = freedomBoardMapper.getFreedomBoardList(rowBounds);
		return contentList;
	}
	
	//게시글 글제목으로 검색해서 가져오는 함수
	public List<FreedomBoardDTO> getSearchKeyObjectFreedomBoardList(RowBounds rowBounds, String keywords){
		List<FreedomBoardDTO> contentList = freedomBoardMapper.getSearchKeyObjectFreedomBoardList(rowBounds, keywords);
		return contentList;
	}
	
	//게시글 제목 + 내용으로 검색해서 가져오는 함수
	public List<FreedomBoardDTO> getSearchKeyObejctContentFreedomBoardList(RowBounds rowBounds, String keywords){
		List<FreedomBoardDTO> contentList = freedomBoardMapper.getSearchKeyObejctContentFreedomBoardList(rowBounds, keywords);
		return contentList;
	}
	
	//게시글 아이디로 검색해서 가져오는 함수
	public List<FreedomBoardDTO> getSearchKeyIdFreedomBoardList(RowBounds rowBounds, String keywords){
		List<FreedomBoardDTO> contentList = freedomBoardMapper.getSearchKeyIdFreedomBoardList(rowBounds, keywords);
		return contentList;
	}
	
	//게시글 내용 가져오는 함수
	public FreedomBoardDTO getFreedomBoardContent(int content_idx) {
		FreedomBoardDTO content = freedomBoardMapper.getFreedomBoardContent(content_idx);
		return content;
	}
	
	//페이징 처리를 위한 게시글 카운트 가져오는 함수
	public int GetFreedomBoardContentCount() {
		int contentCount = freedomBoardMapper.GetFreedomBoardContentCount();
		return contentCount;
	}
	
	//게시판 제목으로 검색한 카운트
	public int getSearchKeyObjectCount(String keywords) {
		int contentCount = freedomBoardMapper.getSearchKeyObjectCount(keywords);
		return contentCount;
	}
	
	//게시판 제목 + 내용으로 검색한 카운트
	public int getSearchKeyObjectContent(String keywords) {
		int contentCount = freedomBoardMapper.getSearchKeyObjectContent(keywords);
		return contentCount;
	}
	
	//게시판 아이디로 검색한 카운트
	public int getSearchKeyIdCnt(String keywords) {
		int contentCount = freedomBoardMapper.getSearchKeyIdCount(keywords);
		return contentCount;
	}
	
	//게시판 글 작성 DAO
	public void InsertFreedomBoardContent(FreedomBoardDTO freedomBoardDTO) {
		freedomBoardDTO.setFree_content_writer_idx(loginUserDTO.getUser_no());
		freedomBoardMapper.InsertFreedomBoardContent(freedomBoardDTO);
	}
	
	//게시판 글 조회 DAO
	public void ModifyFreedomBoardContent(FreedomBoardDTO freedomModifyDTO) {
		freedomBoardMapper.modifyFreedomBoardContent(freedomModifyDTO);
	}
	
	//(구) 게시판 글삭제 기능 (패스워드 입력 받음 현재 사용 안함)
	public String GetFreedomBoardPassword(int content_idx) {
		String password = freedomBoardMapper.GetFreedomBoardPassword(content_idx);
		return password;
	}
	
	//게시판 글 삭제 DAO
	public void FreedomBoardDeleteContent(int content_idx) {
		freedomBoardMapper.FreedomBoardDeleteContent(content_idx);
	}
	
	//게시판 조회수 증가
	public void viewCount(int content_idx) {
		freedomBoardMapper.viewCount(content_idx);
	}
	
	//게시글 삭제시 게시글에 작성된 댓글 삭제
	public void DeleteFreedomBoardWithReply(int content_idx) {
		freedomBoardMapper.DeleteFreedomBoardWithReply(content_idx);
	}
	
	// ============================================ 댓글 관련 컨트롤러 ==========================
	// 댓글 리스트 불러오기
	public List<FreedomReplyDTO> getFreedomReplyList(int free_num) {
		List<FreedomReplyDTO> replyList = freedomBoardMapper.getFreedomReplyList(free_num);
		return replyList;
	}
	
	//댓글 입력
	public void InsertFreedomBoardReply(FreedomReplyDTO replyWriteDTO) {
		freedomBoardMapper.InsertFreedomBoardReply(replyWriteDTO);
	}
	
	//댓글 수정
	public void ModifyFreedomBoardReply(FreedomReplyDTO replyWriteDTO) {
		freedomBoardMapper.ModifyFreedomBoardReply(replyWriteDTO);
	}
	
	//댓글 삭제
	public void DeleteFreedomBoardReply(FreedomReplyDTO replyWriteDTO) {
		freedomBoardMapper.DeleteFreedomBoardReply(replyWriteDTO);
	}
	
	//댓글 수 조회
	public int GetFreedomBoardReplyCount(int free_num) {
		int replyCount = freedomBoardMapper.GetFreedomBoardReplyCount(free_num);
		return replyCount;
	}
}
