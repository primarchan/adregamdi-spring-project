package com.adregamdi.api;

import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.adregamdi.dao.UserDAO;
import com.adregamdi.dto.UserDTO;
import com.github.scribejava.core.model.OAuth2AccessToken;

@Controller
@RequestMapping("/user")
public class NaverLoginController {
	
	/* NaverLoginBO */
	private NaverLoginBO naverLoginBO;
	private String apiResult = null;


	@Autowired
	private UserDAO userDAO;


	@Resource(name = "loginUserDTO")
	private UserDTO loginUserDTO;

	@Autowired
	private void setNaverLoginBO(NaverLoginBO naverLoginBO) {
		this.naverLoginBO = naverLoginBO;
	}

	// 로그인 첫 화면 요청 메소드
	@RequestMapping(value = "/naver_login", method = { RequestMethod.GET, RequestMethod.POST })
	public String login(Model model, HttpSession session) {
		/* 네이버아이디로 인증 URL을 생성하기 위하여 naverLoginBO클래스의 getAuthorizationUrl메소드 호출 */
		String naverAuthUrl = naverLoginBO.getAuthorizationUrl(session);

		model.addAttribute("url", naverAuthUrl);
		return "user/naver_login";
	}

	// 네이버 로그인 성공시 callback호출 메소드
	@RequestMapping(value = "/callback", method = { RequestMethod.GET, RequestMethod.POST })
	public String callback(Model model, @Valid @ModelAttribute("joinUserDTO") UserDTO joinUserDTO, @RequestParam String code, @RequestParam String state, HttpSession session)
			throws IOException, ParseException {
		OAuth2AccessToken oauthToken;
		oauthToken = naverLoginBO.getAccessToken(session, code, state);
		// 1. 로그인 사용자 정보를 읽어온다.
		apiResult = naverLoginBO.getUserProfile(oauthToken); // String형식의 json데이터

		// 2. String형식인 apiResult를 json형태로 바꿈
		JSONParser parser = new JSONParser();
		Object obj = parser.parse(apiResult);
		JSONObject jsonObj = (JSONObject) obj;

		// 3. 데이터 파싱
		// Top레벨 단계 _response 파싱
		JSONObject response_obj = (JSONObject) jsonObj.get("response");
		// response의 nickname값 파싱
		String email = (String) response_obj.get("email");
		String mobile = (String) response_obj.get("mobile");
		String name = (String) response_obj.get("name");
		model.addAttribute("result", apiResult);
		

		
		String user_phone = mobile.replace("-", "");
		Integer checkPhone = userDAO.checkPhone(user_phone);
		
		int idx = email.indexOf("@"); 
		String userId = email.substring(0, idx);
		
		if(checkPhone == null) {
			joinUserDTO.setUser_email(email);
			joinUserDTO.setUser_id(userId);
			joinUserDTO.setUser_pw("");
			joinUserDTO.setUser_phone(user_phone);
			joinUserDTO.setUser_name(name);
			joinUserDTO.setUser_provider(2);
			userDAO.addUserInfo(joinUserDTO);
		}
		
		checkPhone = userDAO.checkPhone(user_phone);
		
		loginUserDTO.setUser_name(name);
		loginUserDTO.setUser_email(email);
		loginUserDTO.setUser_id(userId);		
		loginUserDTO.setUser_phone(user_phone);
		loginUserDTO.setUser_provider(2);
		loginUserDTO.setUser_no(checkPhone);
		

		
		 
		
		
		loginUserDTO.setUserLogin(true);

		

		return "user/login_success";

	}

}
