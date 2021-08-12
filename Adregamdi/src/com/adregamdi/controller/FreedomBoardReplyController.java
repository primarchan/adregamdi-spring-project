package com.adregamdi.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.adregamdi.dto.FreedomReplyDTO;
import com.adregamdi.service.FreedomBoardService;

@RestController
@RequestMapping("/freedomReply")
public class FreedomBoardReplyController {
	
	@Autowired
	FreedomBoardService freedomBoardService; 
	
	//댓글 리스트 가져오기
	@PostMapping("/replyGetList")
	public List<FreedomReplyDTO> BoardReplyGetList(@RequestParam("freedom_num")int freedom_num){
		List<FreedomReplyDTO> replyList = freedomBoardService.getFreedomReplyList(freedom_num);
		return replyList;
	}
	
	//댓글 작성
	@PostMapping("/replyWriteProc")
	public Map<String,Object> BoardReplyWriteProc(@RequestBody FreedomReplyDTO replyWriteDTO) {
		Map<String,Object> result = new HashMap<>();
		
		try {
			freedomBoardService.InsertFreedomBoardReply(replyWriteDTO);
			result.put("status", "True");
		}catch(Exception e) {
			e.printStackTrace();
			result.put("status", "False");
		}
		
		return result;
	}
	
	//댓글 수정
	@PostMapping("/replyModifyProc")
	public Map<String,Object> BoardReplyModifyProc(@RequestBody FreedomReplyDTO replyWriteDTO) {
		Map<String, Object> result = new HashMap<>();
		try {
			freedomBoardService.ModifyFreedomBoardReply(replyWriteDTO);
			result.put("status", "True");
		}catch(Exception e){
			e.printStackTrace();
			result.put("status", "False");
		}
		
		return result;
	}
	
	//댓글 삭제
	@PostMapping("/replyDeleteProc")
	public Map<String, Object> BoardReplyDeleteProc(@RequestBody FreedomReplyDTO replyWriteDTO){
		Map<String, Object> result = new HashMap<>();
		
		try {
			freedomBoardService.DeleteFreedomBoardReply(replyWriteDTO);
			result.put("status", "True");
		} catch(Exception e) {
			e.printStackTrace();
			result.put("status", "False");
		}
		
		return result;
	}
}
