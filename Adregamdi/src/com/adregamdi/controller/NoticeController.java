package com.adregamdi.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.adregamdi.dto.NoticeDTO;
import com.adregamdi.dto.PageDTO;
import com.adregamdi.dto.UserDTO;
import com.adregamdi.service.NoticeService;

@Controller
@RequestMapping("/notice")
public class NoticeController{

	@Autowired
	NoticeService noticeService;

	@Resource(name = "loginUserDTO")
	private UserDTO loginUserDTO;
    
	// 공지사항 목록
	// 공지사항 페이징 처리
	@GetMapping("/list")
	public String BoardList(@RequestParam(value="page", defaultValue="1") int page, Model model) {
		List<NoticeDTO> contentList = noticeService.getNoticeList(page);
		model.addAttribute("loginUserDTO", loginUserDTO);
		model.addAttribute("contentList", contentList);
		PageDTO pageDTO = noticeService.getContentCnt(page);
		model.addAttribute("pageDTO", pageDTO);
		
		return "notice/list";
	}
    
	// 공지사항 본문 내용
	// 공지사항 이전 / 다음글
	@GetMapping("/read")
	public String NoticeRead(@RequestParam("content_idx") int content_idx, Model model) {
		noticeService.viewCount(content_idx);
		NoticeDTO readContentDTO = noticeService.getNoticeContent(content_idx);
		NoticeDTO nextPrev = noticeService.getNextPrev(content_idx);
		NoticeDTO nextContentDTO = noticeService.getNoticeContent(nextPrev.getNext_no());
		NoticeDTO preContentDTO = noticeService.getNoticeContent(nextPrev.getPre_no());
		model.addAttribute("loginUserDTO", loginUserDTO);
		model.addAttribute("nextPrev", nextPrev);
		model.addAttribute("readContentDTO", readContentDTO);
		model.addAttribute("nextContentDTO", nextContentDTO);
		model.addAttribute("preContentDTO", preContentDTO);
		return "notice/read";
	}
    
	// 공지사항 글쓰기
	@GetMapping("/write")
	public String BoardWrite(@ModelAttribute("noticeWriteDTO") NoticeDTO noticeWriteDTO) {
		return "notice/write";
	}
    
	// 공지사항 글쓰기 처리
	@PostMapping("/writeProc")
	public String BoardWrite_Proc(@Valid @ModelAttribute("NoticeWriteDTO") NoticeDTO noticeWriteDTO, BindingResult result) {
		if (result.hasErrors())
			return "notice/write";
		noticeService.InsertNoticeContent(noticeWriteDTO);
		return "notice/write_success";
	}
    
	// 공지사항 수정
	@GetMapping("/modify")
	public String NoticeModify(@ModelAttribute("noticeModifyDTO") NoticeDTO noticeModifyDTO, @RequestParam("content_idx") int content_idx, Model model) {
		NoticeDTO noticeContentDTO = noticeService.getNoticeContent(content_idx);
		noticeModifyDTO.setNotice_no(noticeContentDTO.getNotice_no());
		noticeModifyDTO.setNotice_title(noticeContentDTO.getNotice_title());
		noticeModifyDTO.setNotice_content(noticeContentDTO.getNotice_content());
		noticeModifyDTO.setNotice_cnt(noticeContentDTO.getNotice_cnt());
		noticeModifyDTO.setContent_notice_user_no(noticeContentDTO.getContent_notice_user_no());
		noticeModifyDTO.setNotice_date(noticeContentDTO.getNotice_date());
		return "notice/modify";
	}
    
	// 게시글 수정 처리
	@PostMapping("/modifyProc")
	public String BoardModify_Proc(@Valid @ModelAttribute("noticeModifyDTO") NoticeDTO noticeModifyDTO, BindingResult result) {
		noticeService.ModifyNoticeContent(noticeModifyDTO);
		return "notice/modify_success";
	}
    
	// 게시글 삭제
	@GetMapping("/delete")
	public String NoticeDelete(@RequestParam("content_idx") int content_idx) {
		noticeService.DeleteNoticeContent(content_idx);
		return "notice/delete_success";
	}
	
	// 공지사항 검색
	@GetMapping("/listSearch")
	public String BoardListSearch
	(@RequestParam(value="page", defaultValue="1") int page,
	 @RequestParam("searchType") String searchType, 
	 @RequestParam("keywords") String keywords ,Model model) {
		if(searchType.equals("object")) {
			List<NoticeDTO> contentList = noticeService.getSearchKeyObjectNoticeList(keywords, page);
			model.addAttribute("loginUserDTO", loginUserDTO);
			model.addAttribute("contentList", contentList);
			int search_done = 1;
			int search_res_count = noticeService.getSearchKeyObjectCount(keywords);
			
			model.addAttribute("search_done", search_done);
			model.addAttribute("search_res_count", search_res_count);
			model.addAttribute("keyword", keywords);
			model.addAttribute("searchType", searchType);
			
			PageDTO pageDTO = noticeService.getSearchKeyObjectCount(keywords, page);
			model.addAttribute("pageDTO", pageDTO);
			return "notice/list";
		} else if(searchType.equals("objcon")) {
			List<NoticeDTO> contentList = noticeService.getSearchKeyObejctContentNoticeList(keywords, page);
			model.addAttribute("loginUserDTO", loginUserDTO);
			model.addAttribute("contentList", contentList);
			int search_done = 1;
			int search_res_count = noticeService.getSearchKeyObjectContent(keywords);
			
			model.addAttribute("search_done", search_done);
			model.addAttribute("search_res_count", search_res_count);
			model.addAttribute("keyword", keywords);
			model.addAttribute("searchType", searchType);
			
			PageDTO pageDTO = noticeService.getSearchKeyObjectContent(keywords, page);
			model.addAttribute("pageDTO", pageDTO);
			return "notice/list";
		}
		return "notice/list";
	}
	
	
}
