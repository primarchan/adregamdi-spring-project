package com.adregamdi.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.mybatis.spring.MyBatisSystemException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.adregamdi.dao.UserDAO;
import com.adregamdi.dto.PlanDTO;
import com.adregamdi.dto.SubscriptionDTO;
import com.adregamdi.dto.TogetherDTO;
import com.adregamdi.dto.UserDTO;
import com.adregamdi.service.UserService;
import com.adregamdi.validator.UserValidator;

@Controller
@RequestMapping("/user")
public class UserController {
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private UserDAO userDAO;
	
	@Resource(name="loginUserDTO")
	private UserDTO loginUserDTO;
	
	
	@GetMapping("/login")
	public String login
	(@ModelAttribute("tmpLoginUserDTO") UserDTO tmpLoginUserDTO,
	@RequestParam(value="fail", defaultValue="false") boolean fail,
	Model model)
	{
		model.addAttribute("fail", fail);
		
		return "user/login";
	}
	
	@PostMapping("/login_proc")
	public String loginProc(@Valid @ModelAttribute("tmpLoginUserDTO") UserDTO tmpLoginUserDTO, BindingResult result) {
		
		try {
			if(result.hasErrors()) {
				return "user/login";
			}
			
			userService.getLoginUserDTO(tmpLoginUserDTO);
			
			if(loginUserDTO.isUserLogin() == true) {
				return "user/login_success";
			}else {
				return "user/login_fail";
			}
		} catch (MyBatisSystemException e) {
			e.printStackTrace();
		}
		return "user/login_fail";	
	}
	
	
	
	@GetMapping("/logout")
	public String logout(HttpSession session) throws IOException {
		loginUserDTO.setUserLogin(false);
		session.invalidate();
		return "/user/logout";
	}
	
	@GetMapping("/not_login")
	  public String notLogin() {
	  return "user/not_login";
	}
	
	@GetMapping("/active_login")
	public String nullLogin() {
		return "user/active_login";
	}

	
	@GetMapping("/delete")
	public String delete(@ModelAttribute("deleteUserDTO") UserDTO deleteUserDTO ) {
		return "user/delete";
	}
	
	
	@PostMapping("/delete_proc")
	public String deleteProc(@Valid @ModelAttribute("deleteUserDTO") UserDTO deleteUserDTO, BindingResult result) {
		if(result.hasErrors()) {
			return "user/delete";
		}
		
		userService.deleteUserInfo(deleteUserDTO);
		
		boolean emptyID = userService.checkID(loginUserDTO.getUser_id());
		
		if(emptyID == true) {
			loginUserDTO.setUserLogin(false);
			return "user/delete_success";
		}else {
			return "user/delete_fail";
		}
	}
	
	
	@GetMapping("/join")
	public String join(@ModelAttribute("joinUserDTO") UserDTO joinUserDTO) {
		
		return "user/join";
	}
	
	
	@PostMapping("/join_proc")
	public String joinProc(@Valid @ModelAttribute("joinUserDTO") UserDTO joinUserDTO, BindingResult result) {
		if(result.hasErrors()) {                         
			return "user/join";
		}
		
		String user_phone = joinUserDTO.getUser_phone().replace("-", "");		
		Integer checkPhone = userDAO.checkPhone(user_phone);
		
		if(checkPhone == null) {
		
			userService.addUserInfo(joinUserDTO);	
		
			return "user/join_success";
		}else {
			return "user/join_fail";
		}
		
	}
	
	
	@GetMapping("/modify")
	public String modify(@ModelAttribute("modifyUserDTO") UserDTO modifyUserDTO) {
		userService.getModifyUserDTO(modifyUserDTO);
		return "user/modify";
	}
	
	@PostMapping("/modify_proc")
	public String modifyProc(@Valid @ModelAttribute("modifyUserDTO") UserDTO modifyUserDTO, BindingResult result) {
		if(result.hasErrors()) {
			return "user/modify";
		}
		userService.modifyUserInfo(modifyUserDTO);
		return "user/modify_success";
	}

	
	
	
	
	
	@ResponseBody
	@PostMapping("/myToNotification")
	public List<SubscriptionDTO> myToNotification(@RequestParam("to_no") int to_no) {
		
		List<SubscriptionDTO> myToNotification = new ArrayList<SubscriptionDTO>();
		
		myToNotification = userService.getToNotification(to_no);
		return myToNotification;
	}
	
	@ResponseBody
	@PostMapping("/subCancel")
	public boolean subCancel(@RequestParam("sub_no") int sub_no) {
		
		return userService.subCancel(sub_no);
	}
	
	
	// accept 는 together controller 에...

	@GetMapping("/my_to")
	public String myTo(Model model) {
		
		List<TogetherDTO> myTo
		= userService.getMyTo(loginUserDTO.getUser_no());
		model.addAttribute("myTo", myTo);
		
		List<TogetherDTO> mySub
		= userService.getMySub(loginUserDTO.getUser_no());
		
		if(!(mySub.isEmpty())) {
			model.addAttribute("mySub", mySub);			
		}

		String myPublicCount = userService.getPublicCount(loginUserDTO.getUser_no());
		String myPrivatCount = userService.getPrivateCount(loginUserDTO.getUser_no());
		String myToCount = userService.getMyToCount(loginUserDTO.getUser_no());
		model.addAttribute("myPublicCount", myPublicCount);
		model.addAttribute("myPrivatCount", myPrivatCount);
		model.addAttribute("myToCount", myToCount);
		
		return "user/my_to";
	}
	
	@GetMapping("/my_page")
	public String myPage(Model model) {
		
		List<PlanDTO> myPlan
		= userService.getMyPlan(loginUserDTO.getUser_no());
		model.addAttribute("myPlan", myPlan);
		
		
		String myPublicCount = userService.getPublicCount(loginUserDTO.getUser_no());
		String myPrivatCount = userService.getPrivateCount(loginUserDTO.getUser_no());
		String myToCount = userService.getMyToCount(loginUserDTO.getUser_no());
		model.addAttribute("myPublicCount", myPublicCount);
		model.addAttribute("myPrivatCount", myPrivatCount);
		model.addAttribute("myToCount", myToCount);
	
		return "user/my_page";
	}

	@GetMapping("/my_page_disable")
	public String myPageDisable(Model model) {
		
		List<PlanDTO> myPlan
		= userService.getMyPlan(loginUserDTO.getUser_no());
		model.addAttribute("myPlan", myPlan);
		
		String myPublicCount = userService.getPublicCount(loginUserDTO.getUser_no());
		String myPrivatCount = userService.getPrivateCount(loginUserDTO.getUser_no());
		String myToCount = userService.getMyToCount(loginUserDTO.getUser_no());
		model.addAttribute("myPublicCount", myPublicCount);
		model.addAttribute("myPrivatCount", myPrivatCount);
		model.addAttribute("myToCount", myToCount);

		
		return "user/my_page_disable";
	}
	


	
	
	
	

	@InitBinder
	public void initBinder(WebDataBinder binder) {
	  	UserValidator validator1 = new UserValidator();
	  	binder.addValidators(validator1);
	}
}
