package com.adregamdi.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.adregamdi.dto.ChatroomDTO;
import com.adregamdi.dto.PlanDTO;
import com.adregamdi.dto.SubscriptionDTO;
import com.adregamdi.dto.TogetherDTO;
import com.adregamdi.dto.UserDTO;

public interface UserMapper {
	
	
	@Select("SELECT USER_NAME FROM USER_INFO WHERE USER_ID = #{user_id}")
	String checkID(String user_id);
	
	@Select("SELECT USER_NO FROM USER_INFO WHERE USER_PHONE = #{user_phone}")
	Integer checkPhone(String user_phone);
	
	@Insert("INSERT INTO USER_INFO VALUES(USER_INFO_SEQ.NEXTVAL, #{user_name}, #{user_id},  #{user_pw},  #{user_email},  #{user_phone}, #{user_provider})")
	void addUserInfo(UserDTO joinUserDTO);

	@Select("SELECT USER_ID, USER_NO, USER_NAME, USER_EMAIL, USER_PHONE, USER_PROVIDER FROM USER_INFO WHERE USER_ID=#{user_id}")
	UserDTO getLoginUser(UserDTO tmpLoginUserDTO);
	
	@Select("SELECT USER_PW FROM USER_INFO WHERE USER_ID=#{user_id}")
	String getPw(String user_id);
	
	@Select("SELECT USER_ID, USER_NAME, USER_EMAIL, USER_PHONE FROM USER_INFO WHERE USER_NO=#{user_no}")
	UserDTO getModifyUserDTO(int user_idx);

	@Update("UPDATE USER_INFO SET USER_PW=#{user_pw}, USER_EMAIL=#{user_email}, USER_PHONE=#{user_phone} WHERE USER_NO=#{user_no}")
	void modifyUserInfo(UserDTO modifyUserDTO);
	
	@Delete("DELETE FROM USER_INFO WHERE user_no in(SELECT user_no FROM user_info WHERE user_id=#{user_id} AND user_pw=#{user_pw})")
	void deleteUserInfo(UserDTO deleteUserDTO);

	@Delete("DELETE FROM USER_INFO WHERE user_no in(SELECT user_no FROM user_info WHERE user_email=#{user_email} AND user_phone=#{user_phone})")
	void deleteNaverInfo(UserDTO deleteUserDTO);
	
	
	// MY_PAGE
	
	@Select("SELECT A.PLAN_NO, A.USER_NO, A.PLAN_TITLE, A.PLAN_INFO, A.PLAN_IMG, A.PLAN_PRIVATE, B.PLANTOTALDATE PLAN_TERM FROM PLAN A JOIN (SELECT PLAN_NO, AVG(PLANTOTALDATE) PLANTOTALDATE FROM USER_PLAN GROUP BY PLAN_NO) B ON A.PLAN_NO = B.PLAN_NO WHERE A.USER_NO=#{user_no} ORDER BY PLAN_NO DESC")
	List<PlanDTO> getMyPlan(int user_no);	
	
	@Select("SELECT COUNT(*) FROM PLAN A JOIN (SELECT PLAN_NO, AVG(PLANTOTALDATE) PLANTOTALDATE FROM USER_PLAN GROUP BY PLAN_NO) B ON A.PLAN_NO = B.PLAN_NO WHERE A.PLAN_PRIVATE = 'N' AND A.USER_NO=#{user_no}")
	String getPublicCount(int user_no);

	@Select("SELECT COUNT(*) FROM PLAN A JOIN (SELECT PLAN_NO, AVG(PLANTOTALDATE) PLANTOTALDATE FROM USER_PLAN GROUP BY PLAN_NO) B ON A.PLAN_NO = B.PLAN_NO WHERE A.PLAN_PRIVATE = 'Y' AND A.USER_NO=#{user_no}")
	String getPrivateCount(int user_no);
	
	@Select("SELECT COUNT(*) FROM TOGETHER T, USER_INFO U WHERE U.USER_NO = T.TO_WRITER_NO AND U.USER_NO=#{user_no}")
	String getMyToCount(int user_no);
 	
	@Select("SELECT * FROM TOGETHER T LEFT OUTER JOIN (SELECT A.TO_NO, COUNT(SUB_STATUS) STATUS FROM SUBSCRIPTION A, TOGETHER B WHERE A.TO_NO = B.TO_NO AND SUB_STATUS = 0 GROUP BY A.TO_NO) S ON T.TO_NO = S.TO_NO WHERE TO_WRITER_NO = #{user_no}")
	List<TogetherDTO> getMytogether(int user_no);
	
	@Select("SELECT S.SUB_NO,  S.TO_NO, S.SUB_MESSAGE, S.TO_WRITER_NO, S.SUB_WRITER, U.USER_ID notifi_writer, S.SUB_STATUS, TO_CHAR(S.SUB_DATE, 'YY-MM-DD') SUB_DATE " + 
			"FROM SUBSCRIPTION S, USER_INFO U " + 
			"WHERE S.SUB_WRITER = U.USER_NO " + 
			"AND S.TO_NO=#{to_no}" +
			"AND S.SUB_STATUS=0 ORDER BY S.SUB_NO")
	List<SubscriptionDTO> getToNotification(int to_no);
	
	@Select("SELECT \n"
			+ "t.to_no, t.to_writer_no, t.to_writer, t.to_title, t.to_place_name, t.to_content, t.to_date,\n"
			+ "t.to_curr, t.to_total, t.to_meet, t.to_state, s.sub_status status FROM TOGETHER T, SUBSCRIPTION S WHERE T.TO_NO = S.TO_NO AND S.SUB_WRITER=#{user_no}")
	List<TogetherDTO> getMySub(int user_no);
	
	@Update("UPDATE SUBSCRIPTION SET sub_status=2 WHERE sub_no=#{sub_no}")
	int subCancel(int sub_no);

	@Update("UPDATE SUBSCRIPTION SET sub_status=1 WHERE sub_no=#{sub_no}")
	int subAccept(int sub_no);

	@Update("UPDATE together SET to_curr = to_curr+1 WHERE to_no = #{to_no}")
	int toCurrCount(int to_no);
	
	@Update("UPDATE CHATROOM SET USER1 = #{user1}, USER2 = #{user2}, USER3 = #{user3} WHERE TO_NO = #{to_no}")
	int setChatUser (ChatroomDTO chatroomDTO);
	
	@Select("SELECT TO_TOTAL FROM TOGETHER WHERE TO_NO = #{to_no}")
	int getToTotal(int to_no);
	
	@Select("SELECT * FROM CHATROOM WHERE TO_NO = #{to_no}")
	ChatroomDTO getChatroom (int to_no);
}
