package com.adregamdi.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.adregamdi.dto.FreedomBoardDTO;
import com.adregamdi.dto.FreedomReplyDTO;
import com.adregamdi.dto.PageDTO;
import com.adregamdi.dto.UserDTO;
import com.adregamdi.service.FreedomBoardService;
import com.google.gson.JsonObject;

@Controller
@RequestMapping("/freedom")
public class FreedomBoardController {

	@Autowired
	FreedomBoardService freedomBoardService;

	@Resource(name = "loginUserDTO")
	private UserDTO loginUserDTO;

	//게시판 글 목록 불러오는 함수
	@GetMapping("/list")
	public String BoardList(@RequestParam(value="page", defaultValue="1") int page, Model model) {
		int search_done = 0;
		int search_res_count = 0;
		String keywords = "";
		List<FreedomBoardDTO> contentList = freedomBoardService.getFreedomBoardList(page);
		
		model.addAttribute("loginUserDTO", loginUserDTO);
		model.addAttribute("contentList", contentList);
		model.addAttribute("search_done", search_done);
		model.addAttribute("search_res_count", search_res_count);
		model.addAttribute("keyword", keywords);
		
		PageDTO pageDTO = freedomBoardService.getContentCnt(page);
		model.addAttribute("pageDTO", pageDTO);
		
		return "freedom/list";
	}
	
	@GetMapping("/listSearch")
	public String BoardListSearch
	(@RequestParam(value="page", defaultValue="1") int page,
	 @RequestParam("searchType") String searchType, 
	 @RequestParam("keywords") String keywords ,Model model) {
		if(searchType.equals("object")) {
			List<FreedomBoardDTO> contentList = freedomBoardService.getSearchKeyObjectFreedomBoardList(keywords, page);
			model.addAttribute("loginUserDTO", loginUserDTO);
			model.addAttribute("contentList", contentList);
			int search_done = 1;
			int search_res_count = freedomBoardService.getSearchKeyObjectCnt(keywords);
			
			model.addAttribute("search_done", search_done);
			model.addAttribute("search_res_count", search_res_count);
			model.addAttribute("keyword", keywords);
			model.addAttribute("searchType", searchType);
			
			PageDTO pageDTO = freedomBoardService.getSearchKeyObjectCount(keywords, page);
			model.addAttribute("pageDTO", pageDTO);
			return "freedom/list";
		} else if(searchType.equals("objcon")) {
			List<FreedomBoardDTO> contentList = freedomBoardService.getSearchKeyObejctContentFreedomBoardList(keywords, page);
			model.addAttribute("loginUserDTO", loginUserDTO);
			model.addAttribute("contentList", contentList);
			int search_done = 1;
			int search_res_count = freedomBoardService.getSearchKeyObjectContent(keywords);
			
			model.addAttribute("search_done", search_done);
			model.addAttribute("search_res_count", search_res_count);
			model.addAttribute("keyword", keywords);
			model.addAttribute("searchType", searchType);
			
			PageDTO pageDTO = freedomBoardService.getSearchKeyObjectContent(keywords, page);
			model.addAttribute("pageDTO", pageDTO);
			return "freedom/list";
		} else if(searchType.equals("writerID")) {
			List<FreedomBoardDTO> contentList = freedomBoardService.getSearchKeyIdFreedomBoardList(keywords, page);
			model.addAttribute("loginUserDTO", loginUserDTO);
			model.addAttribute("contentList", contentList);
			int search_done = 1;
			int search_res_count = freedomBoardService.getSearchKeyIdCnt(keywords);
			
			model.addAttribute("search_done", search_done);
			model.addAttribute("search_res_count", search_res_count);
			model.addAttribute("keyword", keywords);
			model.addAttribute("searchType", searchType);
			
			PageDTO pageDTO = freedomBoardService.getSearchKeyId(keywords, page);
			model.addAttribute("pageDTO", pageDTO);
			return "freedom/list";
		} 
		
		return "freedom/list";
	}
	
	// 게시판 글 삭제 함수
	@GetMapping("/deleteProc")
	public String BoardDeleteProc
	(@RequestParam("content_idx") int content_idx) {
		freedomBoardService.DeleteFreedomBoardWithReply(content_idx);
		freedomBoardService.FreedomBoardDeleteContent(content_idx);
		
		return "freedom/delete_success";
	}
	
	// 게시글 조회 함수
	@GetMapping("/read")
	public String BoardRead
	(@ModelAttribute ("replyWriteDTO") FreedomReplyDTO replyWriteDTO, @RequestParam("content_idx") int content_idx, Model model) {
		freedomBoardService.viewCount(content_idx);
		FreedomBoardDTO readContentDTO = freedomBoardService.getFreedomBoardContent(content_idx);
		int reply_count = freedomBoardService.GetFreedomBoardReplyCount(content_idx);
		readContentDTO.setReply_count(reply_count);
		model.addAttribute("loginUserDTO", loginUserDTO);
		model.addAttribute("readContentDTO", readContentDTO);
		model.addAttribute("content_idx", content_idx);
		return "freedom/read_demo";
	}
	
	@ResponseBody
	@PostMapping("/replyCount")
	public int replyCount(@RequestParam("content_idx") int content_idx) {
		return freedomBoardService.GetFreedomBoardReplyCount(content_idx);
	}

	//게시글 작성 폼 함수
	@GetMapping("/write")
	public String BoardWrite
	(@ModelAttribute("freedomWriteDTO") FreedomBoardDTO freedomWriteDTO) {
		return "freedom/write_ckeditor_demo";
	}
	
	@RequestMapping(value = "/writeProc", method=RequestMethod.POST)
	public String BoardWrite_Proc
	(@Valid @ModelAttribute("FreedomWriteDTO") FreedomBoardDTO freedomWriteDTO, BindingResult result) {
		if(result.hasErrors())
			return "freedom/write_ckeditor_demo";
		
		freedomBoardService.InsertFreedomBoardContent(freedomWriteDTO);

		return "freedom/write_success";
	}

	//게시글 수정 폼 함수
	@GetMapping("/modify")
	public String BoardModify(@ModelAttribute("freedomModifyDTO") FreedomBoardDTO freedomModifyDTO,
			@RequestParam("content_idx") int content_idx, Model model) {

		FreedomBoardDTO freedomContentDTO = freedomBoardService.getFreedomBoardContent(content_idx);

		freedomModifyDTO.setFree_no(freedomContentDTO.getFree_no());
		freedomModifyDTO.setFree_title(freedomContentDTO.getFree_title());
		freedomModifyDTO.setFree_content(freedomContentDTO.getFree_content());
		freedomModifyDTO.setFree_cnt(freedomContentDTO.getFree_cnt());
		freedomModifyDTO.setContent_writer_id(freedomContentDTO.getContent_writer_id());
		freedomModifyDTO.setContent_date(freedomContentDTO.getContent_date());

		model.addAttribute("freedomModifyDTO",freedomModifyDTO);
		
		return "freedom/modify_demo";

	}
	
	//게시글 수정 함수
	@PostMapping("/modifyProc")
	public String BoardModify_Proc
	(@Valid @ModelAttribute("freedomModifyProcDTO") FreedomBoardDTO freedomModifyProcDTO, BindingResult result, Model model) {
		
		freedomBoardService.ModifyFreedomBoardContent(freedomModifyProcDTO);
		model.addAttribute("content_num", freedomModifyProcDTO.getFree_no());
		
		return "freedom/modify_success";
	}
	
	// Ckeditor를 통한 이미지 업로드 함수
	@ResponseBody
	@PostMapping("/fileUpload")
	public String FileUpload(HttpServletRequest req, HttpServletResponse resp, MultipartHttpServletRequest multiFile) throws Exception {
		JsonObject json = new JsonObject();
		PrintWriter printWriter = null;
		OutputStream out = null;
		MultipartFile file = multiFile.getFile("upload");
		if(file != null) {
			if(file.getSize() > 0 && StringUtils.isNotBlank(file.getName())) {
				if(file.getContentType().toLowerCase().startsWith("image/")) {
					try {
						String fileName = file.getName();
						byte[] bytes = file.getBytes();
						String uploadPath = req.getServletContext().getRealPath("/resources/images/freedom");
						File uploadFile = new File(uploadPath);
						if(!uploadFile.exists()) {
							uploadFile.mkdirs();
						}
						
						fileName = UUID.randomUUID().toString();
						uploadPath = uploadPath + "/" + fileName;
						out = new FileOutputStream(new File(uploadPath));
						out.write(bytes);
						
						printWriter = resp.getWriter();
						resp.setContentType("text/html");
						String fileUrl = req.getContextPath() + "/images/freedom/" + fileName;
						
						json.addProperty("uploaded", 1);
						json.addProperty("fileName", fileName);
						json.addProperty("url", fileUrl);
						
						printWriter.println(json);
					} catch (Exception e) {
						e.printStackTrace();
					} finally {
						if(out != null) {
							out.close();
						}
						
						if(printWriter != null) {
							printWriter.close();
						}
					}
				}
			}
		}
		
		return null;
	}
}

// 안쓰는 코드지만 남겨둠
/*
 * @GetMapping("/delete") public String BoardDelete
 * (@RequestParam("content_idx") int content_idx,
 * 
 * @ModelAttribute("tmpfreedomDeleteDTO") FreedomBoardDTO tmpfreedomDeleteDTO,
 * BindingResult result, Model model) { FreedomBoardDTO freedomDeleteDTO =
 * freedomBoardService.getFreedomBoardContent(content_idx);
 * model.addAttribute("freedomDeleteDTO", freedomDeleteDTO);
 * 
 * return "freedom/delete"; }
 * 
 * 
 * @PostMapping("/deleteProc") public String BoardDeleteProc
 * (@RequestParam("content_idx") int content_idx,
 * 
 * @ModelAttribute("tmpfreedomDeleteDTO") FreedomBoardDTO tmpfreedomDeleteDTO,
 * BindingResult result, Model model) {
 * 
 * //데이터 베이스에서 불러오는 비밀번호 String user_pw =
 * freedomBoardService.GetFreedomBoardPassword(content_idx);
 * 
 * //입력받은 비밀번호 String input_pw = tmpfreedomDeleteDTO.getFree_user_pw();
 * 
 * BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
 * 
 * //인코더에 넣어줌(입력받은 비번, 암호와된 유저비번) boolean pwMatchRes = encoder.matches(input_pw,
 * user_pw);
 * 
 * if(input_pw != null && pwMatchRes == true) {
 * freedomBoardService.FreedomBoardDeleteContent(content_idx); return
 * "freedom/delete_success"; } else { model.addAttribute("content_idx",
 * content_idx); return "freedom/delete_fail"; } }
 */
