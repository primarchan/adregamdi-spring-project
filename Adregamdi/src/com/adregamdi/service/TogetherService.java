package com.adregamdi.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.adregamdi.dao.TogetherDAO;
import com.adregamdi.dto.PageDTO;
import com.adregamdi.dto.TogetherDTO;
import com.adregamdi.dto.TogetherReplyDTO;
import com.adregamdi.dto.UserDTO;
import com.adregamdi.dto.ChatroomDTO;
import com.adregamdi.dto.SubscriptionDTO;

@Service
public class TogetherService {
	
	@Autowired
	TogetherDAO togetherDAO;
	
	@Value("${page.listcnt}")
	private int page_listcnt;
	
	@Value("${page.pagination}")
	private int page_pagination;
	
	public List<TogetherDTO> getTogetherList(int page){
		int start = (page - 1) * page_listcnt;
		RowBounds rowBounds = new RowBounds(start, page_listcnt);
		
		List<TogetherDTO> contentList = togetherDAO.getTogetherList(rowBounds);
		
		return contentList;
	}
	public TogetherDTO getTogetherContent(int content_idx) {
		TogetherDTO content = togetherDAO.getTogetherContent(content_idx);
		return content;
	}
	
	public boolean sendSubscription(SubscriptionDTO subscriptionDTO) {
		return togetherDAO.sendSubscription(subscriptionDTO) > 0;
	}
	
	public int confirmSubscription(SubscriptionDTO subscriptionDTO) {
		return togetherDAO.confirmSubscription(subscriptionDTO);
	}
	
	public int GetTogetherContentCount() {
		int contentCount = togetherDAO.GetTogetherContentCount();
		return contentCount;
	}
	public void InsertTogetherContent(TogetherDTO togetherDTO) {
		togetherDAO.InsertTogetherContent(togetherDTO);
	}
	
	public int getTogetherNo() {
		return togetherDAO.getTogetherNo();
	}
	
	public void createChatroom(TogetherDTO togetherDTO) {
		togetherDAO.createChatroom(togetherDTO);
	}
	
	public ChatroomDTO getChatroom(int content_idx) {
		return togetherDAO.getChatMember(content_idx);
	}
	
	public ArrayList<UserDTO> getChatMember(int content_idx) {
		ArrayList<UserDTO> userList = new ArrayList<UserDTO>();
		
		ChatroomDTO chatroomDTO = togetherDAO.getChatMember(content_idx);
		
		userList.add(togetherDAO.getUserID(chatroomDTO.getTo_writer_no()));
		
		if(chatroomDTO.getUser1() != 0) {
			userList.add(togetherDAO.getUserID(chatroomDTO.getUser1()));
		}
		
		if(chatroomDTO.getUser2() != 0) {
			userList.add(togetherDAO.getUserID(chatroomDTO.getUser2()));
		}
		
		if(chatroomDTO.getUser3() != 0) {
			userList.add(togetherDAO.getUserID(chatroomDTO.getUser3()));
		}
		
		return userList;
	}
	
	public boolean minusUser(int to_no, int user_no) {
		
		ChatroomDTO chatroomDTO = togetherDAO.getChatMember(to_no);
		
		if(chatroomDTO.getUser1() == user_no) {
			return togetherDAO.minusUser1(to_no) > 0;
		} else if(chatroomDTO.getUser2() == user_no) {
			return togetherDAO.minusUser2(to_no) > 0;
		} else if(chatroomDTO.getUser3() == user_no) {
			return togetherDAO.minusUser3(to_no) > 0;
		}
		
		return false;
	}
	
	public boolean deleteSub(int sub_writer) {
		return togetherDAO.deleteSub(sub_writer) > 0;
	}
	
	public boolean minusToCurr(int to_no) {
		return togetherDAO.minusToCurr(to_no) > 0;
	}
	
	public void ModifyTogetherContent(TogetherDTO togetherModifyDTO) {
		togetherDAO.ModifyTogetherContent(togetherModifyDTO);
	}
	public String GetTogetherPassword(int content_idx) {
		String password = togetherDAO.GetTogetherPassword(content_idx);
		return password;
	}
	public void DeleteTogetherContent(int content_idx) {
		togetherDAO.DeleteTogetherContent(content_idx);
	}
	public void DeleteTogetherComment(int content_idx) {
		togetherDAO.DeleteTogetherComment(content_idx);
	}
	public PageDTO getContentCnt(int currPage) {
		int contentCnt = togetherDAO.GetTogetherContentCount();
		PageDTO tumpPageDTO = new PageDTO(contentCnt, currPage, page_listcnt, page_pagination);
		return tumpPageDTO;
	}
	
	//채팅 입력
	public void InsertTogetherReply(TogetherReplyDTO replyWriteDTO) {
		togetherDAO.InsertTogetherReply(replyWriteDTO);
	}
	
	//채팅 리스트
	public List<TogetherReplyDTO> getTogetherReplyList(int together_num){
		List<TogetherReplyDTO> replyList = togetherDAO.getTogetherReplyList(together_num);
		return replyList;
	}	
	
	
}