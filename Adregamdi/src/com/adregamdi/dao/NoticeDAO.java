package com.adregamdi.dao;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.adregamdi.dto.NoticeDTO;
import com.adregamdi.dto.UserDTO;
import com.adregamdi.mapper.NoticeMapper;

@Repository
public class NoticeDAO {

	@Autowired
	NoticeMapper noticeMapper;

	@Resource(name = "loginUserDTO")
	private UserDTO loginUserDTO;
    
	// 공지사항 목록
	public List<NoticeDTO> getNoticeList(RowBounds rowBounds) {
		List<NoticeDTO> contentList = noticeMapper.getNoticeList(rowBounds);
		return contentList;
	}
	
	// 공지사항 이전 / 다음글
	public NoticeDTO getNextPrev(int content_idx) {
		NoticeDTO getNextPrev = noticeMapper.getNextPrev(content_idx);
		return getNextPrev;
	}
	
    // 공지사항 본문 내용
	public NoticeDTO getNoticeContent(int content_idx) {
		NoticeDTO content = noticeMapper.getNoticeContent(content_idx);
		return content;
	}
	
	// 공지사항 페이징
	public int GetNoticeContentCount() {
		int contentCount = noticeMapper.GetNoticeContentCount();
		return contentCount;
	}
	
	// 공지사항 글쓰기
	public void InsertNoticeContent(NoticeDTO noticeDTO) {
		noticeDTO.setNotice_user_no(loginUserDTO.getUser_no());
		noticeMapper.InsertNoticeContent(noticeDTO);
	}

	// 공지사항 수정
	public void ModifyNoticeContent(NoticeDTO noticeModifyDTO) {
		noticeMapper.modifyNoticeContent(noticeModifyDTO);
	}

	// 공지사항 삭제
	public void DeleteNoticeContent(int content_idx) {
		noticeMapper.deleteNoticeContent(content_idx);
	}
	
	// 공지사항 조회수
	public void viewCount(int content_idx) {
		noticeMapper.viewCount(content_idx);
	}
	
	// 공지사항 제목으로 검색해서 가져오는 메서드
	public List<NoticeDTO> getSearchKeyObjectNoticeList(RowBounds rowBounds, String keywords){
		List<NoticeDTO> contentList = noticeMapper.getSearchKeyObejctNoticeList(rowBounds, keywords);
		return contentList;
	}
	
	// 공지사항 제목 + 내용으로 검색해서 가져오는 공지사항
	public List<NoticeDTO> getSearchKeyObejctContentNoticeBoardList(RowBounds rowBounds, String keywords){
		List<NoticeDTO> contentList = noticeMapper.getSearchKeyObejctContentNoticeList(rowBounds, keywords);
		return contentList;
	}
	
	// 공지사항 제목으로 검색한 갯수
	public int getSearchKeyObjectCount(String keywords) {
		int contentCount = noticeMapper.getSearchKeyObjectCount(keywords);
		return contentCount;
	}
	
	// 공지사항 제목 + 내용으로 검색한 갯수
	public int getSearchKeyObjectContent(String keywords) {
		int contentCount = noticeMapper.getSearchKeyObjectContent(keywords);
		return contentCount;
	}

	
}
