package com.adregamdi.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.validation.Valid;
import javax.xml.parsers.ParserConfigurationException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.xml.sax.SAXException;

import com.adregamdi.api.VisitKoreaAPI;
import com.adregamdi.dto.ChatroomDTO;
import com.adregamdi.dto.PageDTO;
import com.adregamdi.dto.SubscriptionDTO;
import com.adregamdi.dto.TogetherDTO;
import com.adregamdi.dto.TogetherReplyDTO;
import com.adregamdi.dto.UserDTO;
import com.adregamdi.dto.VisitKoreaDTO;
import com.adregamdi.service.TogetherService;
import com.adregamdi.service.UserService;

@Controller
@RequestMapping("/together")
public class TogetherController {

	@Autowired
	TogetherService togetherService;
	
	@Autowired
	UserService userService;
	
	@Resource(name="loginUserDTO")
	private UserDTO loginUserDTO;
	
	@Autowired
	private VisitKoreaAPI spot;
	
	@GetMapping("/list")
	public String TogetherList(@RequestParam(value="page", defaultValue="1")int page, Model model) {
		List<TogetherDTO> contentList = togetherService.getTogetherList(page);
		model.addAttribute("loginUserDTO", loginUserDTO);
		model.addAttribute("contentList", contentList);
		
		PageDTO pageDTO = togetherService.getContentCnt(page);
		model.addAttribute("pageDTO", pageDTO);
		
		return "together/list";
	}
	
	@ResponseBody
	@PostMapping("/subAccept")
	public boolean subAccept(@ModelAttribute SubscriptionDTO subscriptionDTO) {
		
		return userService.subAccept(subscriptionDTO.getSub_no()) && userService.toCurrCount(subscriptionDTO.getTo_no()) && userService.setChatUser(subscriptionDTO);
	}

	@GetMapping("/read")
	public String TogetherRead(@RequestParam("content_idx") int content_idx, Model model) throws ParserConfigurationException, SAXException, IOException {
		
		TogetherDTO togetherDTO = togetherService.getTogetherContent(content_idx);
		
		VisitKoreaDTO place = spot.getOneSpot(togetherDTO.getTo_place());
		
		ChatroomDTO chatroomDTO = togetherService.getChatroom(content_idx);
		
		ArrayList<UserDTO> userList = togetherService.getChatMember(content_idx);
		
		SubscriptionDTO subscriptionDTO = new SubscriptionDTO();
		subscriptionDTO.setSub_writer(loginUserDTO.getUser_no());
		subscriptionDTO.setTo_no(content_idx);
		int confirmSub = togetherService.confirmSubscription(subscriptionDTO);
		
		model.addAttribute("togetherDTO", togetherDTO);
		model.addAttribute("place", place);
		model.addAttribute("loginUserDTO", loginUserDTO);
		model.addAttribute("chatroomDTO", chatroomDTO);
		model.addAttribute("userList", userList);
		model.addAttribute("confirmSub", confirmSub);
		
		return "together/read";
	}
	
	@ResponseBody
	@PostMapping("/subcription")
	public int subcription(@ModelAttribute SubscriptionDTO subscriptionDTO) {
		
		int result = 0;
		
		int confirm = togetherService.confirmSubscription(subscriptionDTO);
		
		if(confirm == 0) {
			togetherService.sendSubscription(subscriptionDTO);
			result = 1;
		} else {
			result = 0;
		}
		
		return result;
	}
	
	@ResponseBody
	@PostMapping("/userMinus")
	public boolean userMinus(@ModelAttribute  SubscriptionDTO subscriptionDTO) {
		
		int user_no = subscriptionDTO.getSub_writer();
		int to_no = subscriptionDTO.getTo_no();
		
		boolean result = togetherService.minusUser(to_no, user_no) && togetherService.minusToCurr(to_no) && togetherService.deleteSub(user_no);
		
		return result;
	}
	
	@GetMapping("/deleteProc")
	public String BoardDeleteProc
	(@RequestParam("content_idx") int content_idx) {
		togetherService.DeleteTogetherComment(content_idx);
		togetherService.DeleteTogetherContent(content_idx);
		
		return "together/delete_success";
	}
	
	@GetMapping("/write")
	public String TogetherWrite
	(@ModelAttribute("togetherWriteDTO") TogetherDTO togetherWriteDTO) {
		return "together/write";
	}
	
	@PostMapping("/writeProc")
	public String TogetherWrite_Proc
	(@Valid @ModelAttribute("togetherWriteDTO") TogetherDTO togetherWriteDTO, BindingResult result) {
		if(result.hasErrors())
			return "together/write";
			
		togetherWriteDTO.setTo_writer_no(loginUserDTO.getUser_no());
		togetherWriteDTO.setTo_writer(loginUserDTO.getUser_id());

		togetherService.InsertTogetherContent(togetherWriteDTO);
		togetherWriteDTO.setTo_no(togetherService.getTogetherNo());
		togetherService.createChatroom(togetherWriteDTO);
		
		return "together/write_success";
	}
	
	@GetMapping("/modify")
  public String TogetherModify
  (@ModelAttribute("togetherModifyDTO") TogetherDTO togetherModifyDTO, 
   @RequestParam("content_idx") int content_idx, Model model) {
     
     TogetherDTO TogetherDTO = togetherService.getTogetherContent(content_idx);
     
     togetherModifyDTO.setTo_no(TogetherDTO.getTo_no());
     togetherModifyDTO.setTo_writer(TogetherDTO.getTo_writer());
     togetherModifyDTO.setTo_writer_no(TogetherDTO.getTo_writer_no());
     togetherModifyDTO.setTo_title(TogetherDTO.getTo_title());
     togetherModifyDTO.setTo_place(TogetherDTO.getTo_place());
     togetherModifyDTO.setTo_place_name(TogetherDTO.getTo_place_name());
     togetherModifyDTO.setTo_date(TogetherDTO.getTo_date());
     togetherModifyDTO.setTo_content(TogetherDTO.getTo_content());
     togetherModifyDTO.setTo_meet(TogetherDTO.getTo_meet());
     togetherModifyDTO.setTo_state(TogetherDTO.getTo_state());
     togetherModifyDTO.setTo_total(TogetherDTO.getTo_total());
     
     
     model.addAttribute("togetherModifyDTO", togetherModifyDTO);
     
     return "together/modify";
  }
  
  @PostMapping("/modifyProc")
  public String TogetherModify_Proc
  (@Valid @ModelAttribute("togetherModifyDTO") TogetherDTO togetherModifyDTO, BindingResult result) {
	  
	  if(result.hasErrors())
			return "together/modify";
     
     togetherService.ModifyTogetherContent(togetherModifyDTO);
     System.out.println(togetherModifyDTO.toString());
     
     return "together/modify_success";
  }
	
	@ResponseBody
	@GetMapping("/keyword")
	public List<VisitKoreaDTO> getKeywordInfo(VisitKoreaDTO visitKoreaDTO, String keyword, Model model) throws Exception {
		
		if(visitKoreaDTO.getPageNo()==null) visitKoreaDTO.setPageNo("1");
		if(visitKoreaDTO.getContentTypeId()==null) visitKoreaDTO.setContentTypeId("");
		List<VisitKoreaDTO> resultKeyword = spot.getKeywordInformation(visitKoreaDTO, keyword);
		
		return resultKeyword;
	} 	
	
	@ResponseBody
	@GetMapping("/writeMessage")
	public void writeMessage(TogetherReplyDTO togetherReplyDTO) {
		togetherService.InsertTogetherReply(togetherReplyDTO);		
	}
	
	@ResponseBody
	@GetMapping("/getMessage")
	public List<TogetherReplyDTO> getMessage(int together_num) {
		
		List<TogetherReplyDTO> getReply = togetherService.getTogetherReplyList(together_num);
		/*
		for(int i=0; i<getReply.size(); i++) {
			System.out.println("list : "+getReply.get(i).toString());
		}
 		*/
		return getReply;
	}
}
