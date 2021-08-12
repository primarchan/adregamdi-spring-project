package com.adregamdi.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;

import com.adregamdi.dto.UserDTO;

public class LoginInterceptor implements HandlerInterceptor {
	
	private UserDTO loginUserDTO;
	
	public LoginInterceptor (UserDTO loginUserDTO) {
		this.loginUserDTO = loginUserDTO;
	}
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		if(loginUserDTO.isUserLogin() == false) {
			String contextPath = request.getContextPath();
			response.sendRedirect(contextPath + "/user/not_login");
			
			return false;
		}
		
		return true;
	}
	
	
}
