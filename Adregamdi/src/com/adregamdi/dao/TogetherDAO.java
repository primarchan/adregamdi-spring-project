package com.adregamdi.dao;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.adregamdi.dto.ChatroomDTO;
import com.adregamdi.dto.SubscriptionDTO;
import com.adregamdi.dto.TogetherDTO;
import com.adregamdi.dto.TogetherReplyDTO;
import com.adregamdi.dto.UserDTO;
import com.adregamdi.mapper.TogetherMapper;

@Repository
public class TogetherDAO {
	
	@Autowired
  TogetherMapper togetherMapper;
	
	@Resource(name="loginUserDTO")
	private UserDTO loginUserDTO;

	
	public List<TogetherDTO> getTogetherList(RowBounds rowBounds) {
		List<TogetherDTO> contentList
		  = togetherMapper.getTogetherList(rowBounds);
		return contentList;
	}
	
	public TogetherDTO getTogetherContent(int content_idx)	{
		TogetherDTO content
		  = togetherMapper.getTogetherContent(content_idx);
		return content;
	}
	
	public int sendSubscription(SubscriptionDTO subscriptionDTO) {
		return togetherMapper.sendSubscription(subscriptionDTO);
	}
	
	public int confirmSubscription(SubscriptionDTO subscriptionDTO) {
		return togetherMapper.confirmSubscription(subscriptionDTO);
	}
	
	public int GetTogetherContentCount() {
		int contentCount = togetherMapper.GetTogetherContentCount();
		return contentCount;
	}
	
	public void InsertTogetherContent(TogetherDTO togetherDTO) {
		togetherDTO.setTo_writer(loginUserDTO.getUser_id());
		togetherMapper.InsertTogetherContent(togetherDTO);
	}
	
	public int getTogetherNo() {
		return togetherMapper.getTogetherNo();
	}
	
	public void createChatroom(TogetherDTO togetherDTO) {
		togetherMapper.createChatroom(togetherDTO);
	}
	
	public ChatroomDTO getChatMember(int content_idx) {
		return togetherMapper.getChatMember(content_idx);
	}
	
	public UserDTO getUserID(int user_no) {
		return togetherMapper.getUserID(user_no);
	}
	
	public void ModifyTogetherContent(TogetherDTO togetherModifyDTO) {
		togetherMapper.ModifyTogetherContent(togetherModifyDTO);
	}
	
	public String GetTogetherPassword(int content_idx) {
		String password = togetherMapper.GetTogetherPassword(content_idx);
		return password;
	}

	public void DeleteTogetherContent(int content_idx) {
		togetherMapper.DeleteTogetherContent(content_idx);
	}
	public void DeleteTogetherComment(int content_idx)	{
		togetherMapper.DeleteTogetherComment(content_idx);
	}
	
	public void InsertTogetherReply(TogetherReplyDTO replyWriteDTO) {
		togetherMapper.InsertTogetherReply(replyWriteDTO);
	}
	
	public List<TogetherReplyDTO> getTogetherReplyList(int together_num) {
		return togetherMapper.getTogetherReplyList(together_num);
	}
	
	public int minusUser1(int to_no) {
		return togetherMapper.minusUser1(to_no);
	}
	
	public int minusUser2(int to_no) {
		return togetherMapper.minusUser2(to_no);
	}
	
	public int minusUser3(int to_no) {
		return togetherMapper.minusUser3(to_no);
	}
	
	public int minusToCurr(int to_no) {
		return togetherMapper.minusToCurr(to_no);
	}
	
	public int deleteSub(int sub_writer) {
		return togetherMapper.deleteSub(sub_writer);
	}

}