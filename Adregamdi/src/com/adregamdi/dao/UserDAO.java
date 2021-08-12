package com.adregamdi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.adregamdi.dto.ChatroomDTO;
import com.adregamdi.dto.PlanDTO;
import com.adregamdi.dto.SubscriptionDTO;
import com.adregamdi.dto.TogetherDTO;
import com.adregamdi.dto.UserDTO;
import com.adregamdi.mapper.UserMapper;

@Repository
public class UserDAO {
	
	@Autowired
	private UserMapper userMapper;

	public String checkID(String user_id) {
		String checking_id = userMapper.checkID(user_id);
		return checking_id;
	}

	
	public Integer checkPhone(String user_phone) {
		return userMapper.checkPhone(user_phone);
	}
	
	public void addUserInfo(UserDTO joinUserDTO) {	
		if(joinUserDTO.getUser_provider() != 2) {
			joinUserDTO.setUser_provider(1);
		}
		userMapper.addUserInfo(joinUserDTO);
	}
	

	
	public UserDTO getLoginUserDTO(UserDTO loginUserDTO) {
		UserDTO formDBUserDTO = userMapper.getLoginUser(loginUserDTO);
		
		return formDBUserDTO;
	}
	
	public String getPw(String user_id) {
		return userMapper.getPw(user_id);
	}
	
	
	public UserDTO getModifyUserDTO(int user_no) {
		return userMapper.getModifyUserDTO(user_no);
	}
	
	public void modifyUserInfo(UserDTO modifyUserDTO) {
		userMapper.modifyUserInfo(modifyUserDTO);
	}
	
	
	public void deleteUserInfo(UserDTO deleteUserDTO) {
		userMapper.deleteUserInfo(deleteUserDTO);
	}


	public void deleteNaverInfo(UserDTO deleteUserDTO) {
		userMapper.deleteNaverInfo(deleteUserDTO);
	}


	public List<PlanDTO> getMyPlan(int user_no) {
		return userMapper.getMyPlan(user_no);
	}


	public String getPrivateCount(int user_no) {
		return userMapper.getPrivateCount(user_no);
	}

	public String getPublicCount(int user_no) {
		return userMapper.getPublicCount(user_no);
	}


	public List<TogetherDTO> getMyTo(int user_no) {
		return userMapper.getMytogether(user_no);
	}


	public List<SubscriptionDTO> getToNotification(int to_no) {
		return userMapper.getToNotification(to_no);
	}


	public String getMyToCount(int user_no) {
		return userMapper.getMyToCount(user_no);
	}


	public int subCancel(int sub_no) {
		return userMapper.subCancel(sub_no);
	}


	public int subAccept(int sub_no) {
		return userMapper.subAccept(sub_no);
	}


	public int toCurrCount(int to_no) {
		return userMapper.toCurrCount(to_no);
	}

	public int setChatUser (ChatroomDTO chatroomDTO) {
		return userMapper.setChatUser(chatroomDTO);
	}
	
	public int getToTotal(int to_no) {
		return userMapper.getToTotal(to_no);
	}
	
	
	public ChatroomDTO getChatroom (int to_no) {
		return userMapper.getChatroom(to_no);
	}


	public List<TogetherDTO> getMySub(int user_no) {
		return userMapper.getMySub(user_no);
	}
}
