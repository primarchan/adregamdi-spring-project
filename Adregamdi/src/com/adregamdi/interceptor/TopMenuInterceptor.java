package com.adregamdi.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;

import com.adregamdi.dto.UserDTO;

public class TopMenuInterceptor implements HandlerInterceptor{

	private UserDTO loginUserDTO;
	

	public TopMenuInterceptor(UserDTO loginUserDTO) {
		this.loginUserDTO   = loginUserDTO;
	}
	
	@Override
	public boolean preHandle
	(HttpServletRequest request, 
	 HttpServletResponse response, Object handler) throws Exception {
		
		
		request.setAttribute("loginUserDTO", loginUserDTO);
		
		return true;
	}
}
