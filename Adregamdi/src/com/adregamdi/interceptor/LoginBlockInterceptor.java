package com.adregamdi.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;

import com.adregamdi.dto.UserDTO;

public class LoginBlockInterceptor implements HandlerInterceptor {
	
	private UserDTO loginUserDTO;
	
	public LoginBlockInterceptor (UserDTO loginUserDTO) {
		this.loginUserDTO = loginUserDTO;
	}
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		if(loginUserDTO.isUserLogin() == true && loginUserDTO.getUser_provider() != 0 ) {
			String contextPath = request.getContextPath();
			response.sendRedirect(contextPath + "/user/active_login");
			
			return false;
		}
		
		return true;
	}
}
