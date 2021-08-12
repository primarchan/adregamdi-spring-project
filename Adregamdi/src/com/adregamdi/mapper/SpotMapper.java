package com.adregamdi.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;

import com.adregamdi.dto.ReviewDTO;
import com.adregamdi.dto.SpotDTO;

public interface SpotMapper {
	
	@SelectKey(statement="select spot_seq.nextval from dual", keyProperty="like_idx", before=true, resultType=int.class)
	
	@Insert("INSERT INTO SPOT_INFO VALUES ( #{like_idx}, #{content_id}, #{like_cnt}, #{review_cnt})")
	void inputContentId(SpotDTO spotDTO);
	
	@Select("SELECT COUNT(*) FROM SPOT_INFO")
	int getTotalSpot();
	
	@Update("UPDATE SPOT_INFO SET LIKE_CNT = LIKE_CNT + 1 WHERE CONTENT_ID= #{content_id}")
	void plusLikeCnt(String content_id);
	
	@Select("SELECT * FROM SPOT_INFO")
	ArrayList<SpotDTO> getSpotInfo();
	
	@Select("SELECT CONTENT_ID FROM (SELECT *  FROM SPOT_INFO ORDER BY LIKE_CNT DESC) WHERE ROWNUM<=3")
	ArrayList<String> getBestSpotInfo1();
	
	
	@Select("SELECT * FROM REVIEW_INFO WHERE CONTENT_ID = #{content_id}")
	ArrayList<ReviewDTO> getReviewInfo(@Param("content_id")String content_id);
	
	
	@SelectKey(statement="select REVIEW_SEQ.NEXTVAL from dual", keyProperty="review_idx", before=true, resultType=int.class)
	
	@Insert("INSERT INTO REVIEW_INFO VALUES (#{review_idx}, #{content_id} , #{user_no}, #{user_id}, to_char(SYSDATE, 'YYYY.MM.DD HH24:MI'), #{review_content})")
	void inputReview(ReviewDTO reviewDTO);
	
	@Update("UPDATE SPOT_INFO SET REVIEW_CNT = REVIEW_CNT + 1 WHERE CONTENT_ID= #{content_id}")
	void plusReviewCnt(String content_id);
	
	@Delete("DELETE FROM REVIEW_INFO WHERE REVIEW_IDX = #{review_idx}")
	void deleteReview(@Param("review_idx")int review_idx);
	
	@Update("UPDATE SPOT_INFO SET REVIEW_CNT = REVIEW_CNT - 1 WHERE CONTENT_ID= #{content_id}")
	void minusReviewCnt(String content_id);
	
}
