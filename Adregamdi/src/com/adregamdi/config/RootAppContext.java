package com.adregamdi.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.context.annotation.SessionScope;

import com.adregamdi.dto.UserDTO;

@Configuration
public class RootAppContext {
	
	// 로그인 한 유저정보를 담은 객체
	@Bean("loginUserDTO")
	@SessionScope
	public UserDTO loginUserDTO() {
		return new UserDTO();
	}
	
}
