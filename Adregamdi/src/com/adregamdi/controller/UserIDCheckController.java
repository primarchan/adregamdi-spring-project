package com.adregamdi.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.adregamdi.service.UserService;

// join 에서 받아온 아이디 값을 받아 유효성 체크

@RestController
public class UserIDCheckController {
	
	@Autowired
	private UserService userService;
	
	@GetMapping("/user/checkID/{user_id}")
	public String checkID(@PathVariable String user_id) {
		boolean chck = userService.checkID(user_id);
		return chck+"";
		
	}
	
}
