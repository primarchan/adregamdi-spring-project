package com.adregamdi.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.apache.ibatis.session.RowBounds;

import com.adregamdi.dto.FreedomBoardDTO;
import com.adregamdi.dto.FreedomReplyDTO;

public interface FreedomBoardMapper {
	//게시글 목록 불러오기
	@Select("SELECT F.FREE_NO, U.USER_ID CONTENT_WRITER_ID, F.FREE_TITLE, F.FREE_CNT, " +
			"TO_CHAR(F.FREE_DATE, 'YYYY-MM-DD HH24:MI:SS') CONTENT_DATE, " + 
			"(SELECT COUNT(*) FROM FREEDOMREPLY R WHERE F.FREE_NO = R.FREEDOM_NUM) REPLY_COUNT " + 
			"FROM FREEDOMBOARD F, USER_INFO U " +
			"WHERE F.FREE_WRITER = U.USER_NO " + 
			"ORDER BY F.FREE_NO DESC ")
	List<FreedomBoardDTO> getFreedomBoardList(RowBounds rowBounds);
	
	//게시글 제목으로 검색해서 불러오기
	@Select("SELECT F.FREE_NO, U.USER_ID CONTENT_WRITER_ID, F.FREE_TITLE, F.FREE_CNT, " + 
			"TO_CHAR(F.FREE_DATE, 'YYYY-MM-DD HH24:MI:SS') CONTENT_DATE, " + 
			"(SELECT COUNT(*) FROM FREEDOMREPLY R WHERE F.FREE_NO = R.FREEDOM_NUM) REPLY_COUNT " + 
			"FROM FREEDOMBOARD F, USER_INFO U " + 
			"WHERE F.FREE_WRITER = U.USER_NO AND F.FREE_TITLE LIKE '%' || #{keywords} || '%' ")
	List<FreedomBoardDTO> getSearchKeyObjectFreedomBoardList(RowBounds rowBounds, String keywords);
	
	//게시글 제목 + 내용으로 검색해서 불러오기
	@Select("SELECT F.FREE_NO, U.USER_ID CONTENT_WRITER_ID, F.FREE_TITLE, F.FREE_CNT, " + 
			"TO_CHAR(F.FREE_DATE, 'YYYY-MM-DD HH24:MI:SS') CONTENT_DATE, " + 
			"(SELECT COUNT(*) FROM FREEDOMREPLY R WHERE F.FREE_NO = R.FREEDOM_NUM) REPLY_COUNT " + 
			"FROM FREEDOMBOARD F, USER_INFO U " + 
			"WHERE F.FREE_WRITER = U.USER_NO AND (F.FREE_TITLE || F.FREE_CONTENT) LIKE '%' || #{keywords} || '%' " + 
			"AND F.FREE_CONTENT LIKE '%' || #{keywords} || '%' ")
	List<FreedomBoardDTO> getSearchKeyObejctContentFreedomBoardList(RowBounds rowBounds, String keywords);
	
	//게시글 아이디로 검색해서 불러오기
	@Select("SELECT F.FREE_NO, U.USER_ID CONTENT_WRITER_ID, F.FREE_TITLE, F.FREE_CNT, " + 
			"TO_CHAR(F.FREE_DATE, 'YYYY-MM-DD HH24:MI:SS') CONTENT_DATE, " + 
			"(SELECT COUNT(*) FROM FREEDOMREPLY R WHERE F.FREE_NO = R.FREEDOM_NUM) REPLY_COUNT " + 
			"FROM FREEDOMBOARD F, USER_INFO U " + 
			"WHERE F.FREE_WRITER = U.USER_NO AND U.USER_ID LIKE '%' || #{keywords} || '%' ")
	List<FreedomBoardDTO> getSearchKeyIdFreedomBoardList(RowBounds rowBounds, String keywords);
	
	//게시글 내용 불러오기
	@Select("SELECT F.FREE_NO, U.USER_NO FREE_CONTENT_WRITER_IDX, U.USER_ID CONTENT_WRITER_ID, TO_CHAR(F.FREE_DATE, 'YYYY-MM-DD HH24:MI:SS') CONTENT_DATE, " + 
			"F.FREE_TITLE, F.FREE_CONTENT, F.FREE_CNT " + 
			"FROM USER_INFO U, FREEDOMBOARD F " +
			"WHERE U.USER_NO = F.FREE_WRITER " +
			"AND F.FREE_NO = #{content_idx} ")
	FreedomBoardDTO getFreedomBoardContent(int content_idx);
	
	//게시글 패스워드 대조 - 현재 사용 안함
	@Select("SELECT U.USER_PW " + 
			"FROM FREEDOMBOARD F, USER_INFO U " + 
			"WHERE U.USER_NO = F.FREE_WRITER " + 
			"AND F.FREE_NO = #{content_idx} ")
	String GetFreedomBoardPassword(int content_idx);
	
	// 페이징을 위한 게시글 갯수 불러오기
	@Select("SELECT COUNT(*) " + 
			"FROM FREEDOMBOARD ")
	int GetFreedomBoardContentCount();
	
	//게시글 제목으로 검색한 카운트 불러와 페이징 처리
	@Select("SELECT COUNT(*) " + 
			"FROM FREEDOMBOARD F, USER_INFO U " + 
			"WHERE F.FREE_WRITER = U.USER_NO AND F.FREE_TITLE LIKE '%' || #{keywords} || '%' ")
	int getSearchKeyObjectCount(String keywords);
	
	//게시글 제목 + 내용 검색한 카운트 불러와 페이징 처리
	@Select("SELECT COUNT(*) " + 
			"FROM FREEDOMBOARD F, USER_INFO U " + 
			"WHERE F.FREE_WRITER = U.USER_NO AND (F.FREE_TITLE || F.FREE_CONTENT) LIKE '%' || #{keywords} ||'%' ")
	int getSearchKeyObjectContent(String keywords);
	
	//게시글 아이디로 검색해서 불러온 카운트
	@Select("SELECT COUNT(*) " + 
			"FROM FREEDOMBOARD F, USER_INFO U " +
			"WHERE F.FREE_WRITER = U.USER_NO AND U.USER_ID LIKE '%' || #{keywords} || '%' ")
	int getSearchKeyIdCount(String keywords);
	
	//게시글 삭제 
	@Delete("DELETE FROM FREEDOMBOARD WHERE FREE_NO = #{content_idx}")
	void FreedomBoardDeleteContent(int content_idx);
	
	//게시글 삭제시 게시글에 작성된 댓글 삭제
	@Delete("DELETE FROM FREEDOMREPLY WHERE FREEDOM_NUM = #{content_idx}")
	void DeleteFreedomBoardWithReply(int content_idx); 
	
	//게시글 작성
	@Insert("INSERT INTO FREEDOMBOARD(FREE_NO, FREE_WRITER, FREE_TITLE, FREE_CNT, FREE_DATE, FREE_CONTENT) " + 
			"VALUES(CONTENT_CNT_SEQ.nextval, #{free_content_writer_idx}, #{free_title}, 0, SYSDATE, #{free_content}) ")
	void InsertFreedomBoardContent(FreedomBoardDTO freedomBoardDTO);
	
	//게시글 수정
	@Update("UPDATE FREEDOMBOARD SET FREE_TITLE=#{free_title}, FREE_CONTENT=#{free_content}, free_date=SYSDATE " + 
			"WHERE FREE_NO = #{free_no}")
	void modifyFreedomBoardContent(FreedomBoardDTO freedomModifyDTO);
	
	//게시글 조회수 증가
	@Update("UPDATE FREEDOMBOARD SET free_cnt = free_cnt + 1 WHERE free_no = #{content_idx}")
	void viewCount(int content_idx);
	
	// ===============================================================================================================================
	// 댓글 관련 Mapper
	
	@Select("SELECT REPLY_NUM, FREEDOM_NUM, REPLY_WRITER, REPLY_CONTENT, REPLY_DATE " + 
			"FROM FREEDOMREPLY " +
			"WHERE FREEDOM_NUM = #{freedom_num}" +
			"ORDER BY FREEDOM_NUM DESC")
	List<FreedomReplyDTO> getFreedomReplyList(int freedom_num);
	
	//댓글 작성
	@Insert("INSERT INTO FREEDOMREPLY(reply_num, freedom_num, reply_writer, reply_content, reply_date) " +
			"VALUES (freedom_reply_SEQ.nextval, #{freedom_num}, #{reply_writer}, #{reply_content}, sysdate) ")
	void InsertFreedomBoardReply(FreedomReplyDTO replyWriteDTO);
	
	//댓글 수정
	@Update("UPDATE FREEDOMREPLY SET reply_content = #{reply_content}, reply_date = SYSDATE WHERE freedom_num = #{freedom_num} and reply_num = #{reply_num}")
	void ModifyFreedomBoardReply(FreedomReplyDTO replyWriteDTO);
	
	//댓글 삭제
	@Delete("DELETE FROM FREEDOMREPLY WHERE FREEDOM_NUM=#{freedom_num} AND REPLY_NUM=#{reply_num}")
	void DeleteFreedomBoardReply(FreedomReplyDTO replyWriteDTO);
	
	//댓글 갯수 조회
	@Select("SELECT COUNT(*) FROM FREEDOMREPLY WHERE FREEDOM_NUM=#{freedom_num}")
	int GetFreedomBoardReplyCount(int freedom_num);
}