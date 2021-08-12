package com.adregamdi.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.xml.parsers.ParserConfigurationException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.xml.sax.SAXException;

import com.adregamdi.api.VisitKoreaAPI;
import com.adregamdi.dto.PageDTO;
import com.adregamdi.dto.ReviewDTO;
import com.adregamdi.dto.SpotDTO;
import com.adregamdi.dto.UserDTO;
import com.adregamdi.dto.VisitKoreaDTO;
import com.adregamdi.service.SpotService;


@Controller
public class SpotController {
	
	private static int totalCount;
	
	@Autowired
	SpotService spotService;
	
	@Resource(name="loginUserDTO")
	private UserDTO loginUserDTO;

	
	@Autowired
	private VisitKoreaAPI spot;

	@GetMapping("/spot/main")
	public String spotMain(@RequestParam(value="currentPage", defaultValue="1")String currentPage,
			@RequestParam(value="sigunguCode", defaultValue="")String sigunguCode, @RequestParam(value="contentTypeId", defaultValue="")String contentTypeId, 
			 Model model ) throws Exception {
		
		int check = spotService.getTotalSpot();
		
		if(check == 0) {
			// SpotLikeDTO에 초기 데이터 값 넣기
			ArrayList<String> contentIdList = spot.lgetContentId();
			
			SpotDTO spotDTO = new SpotDTO();
			
			for(int i=0; i<contentIdList.size(); i++) {
				
				spotDTO.setContent_id(contentIdList.get(i));
				spotDTO.setLike_cnt(0);
				spotDTO.setReview_cnt(0);
				
				spotService.inputContentId(spotDTO);
			}
		}
		
		totalCount = spot.getTotalCount(contentTypeId, sigunguCode);
		
		model.addAttribute("pageMaker", new PageDTO(currentPage, totalCount, 10));
		model.addAttribute("sigunguCode", sigunguCode);
		model.addAttribute("contentTypeId", contentTypeId);		
		
		return "spot/main";
	}
	
	@ResponseBody
	@GetMapping("/spot/information")
	public List<VisitKoreaDTO> getSpotInfo2(VisitKoreaDTO visitKoreaDTO, Model model) throws Exception {
		
		
		if(visitKoreaDTO.getPageNo()==null) visitKoreaDTO.setPageNo("1");
		if(visitKoreaDTO.getSigunguCode()==null) visitKoreaDTO.setSigunguCode("");
		if(visitKoreaDTO.getContentTypeId()==null) visitKoreaDTO.setContentTypeId("");
		
		
		ArrayList<SpotDTO> spotDTO = spotService.getSpotInfo();
				
		return spot.getInformationPlusLike(visitKoreaDTO, spotDTO, totalCount);
	}
	
	@ResponseBody
	@GetMapping("/spot/best")
	public List<VisitKoreaDTO> getBestSpotInfo(VisitKoreaDTO visitKoreaDTO) throws SAXException, IOException, ParserConfigurationException {
		
		if(visitKoreaDTO.getPageNo()==null) visitKoreaDTO.setPageNo("1");
		if(visitKoreaDTO.getSigunguCode()==null) visitKoreaDTO.setSigunguCode("");
		if(visitKoreaDTO.getContentTypeId()==null) visitKoreaDTO.setContentTypeId("");
		
		ArrayList<String> bestContentId = spotService.getBestSpotInfo1();
		
		return spot.getBestInformation(visitKoreaDTO,  bestContentId);
	}
	
	@ResponseBody
	@GetMapping("/spot/details")
	public List<String> getDetailsInfo(String contentId, String contentTypeId) throws Exception {
		
		VisitKoreaDTO visitKoreaDTO = new VisitKoreaDTO();
		
		visitKoreaDTO.setContentId(contentId);
		visitKoreaDTO.setContentTypeId(contentTypeId);
		
		return spot.getEachInformation(visitKoreaDTO);
	}	
	
	@ResponseBody
	@GetMapping("/spot/keyword")
	public List<VisitKoreaDTO> getKeywordInfo(VisitKoreaDTO visitKoreaDTO, String keyword, Model model) throws Exception {
		
		if(visitKoreaDTO.getPageNo()==null) visitKoreaDTO.setPageNo("1");
		if(visitKoreaDTO.getContentTypeId()==null) visitKoreaDTO.setContentTypeId("");
		List<VisitKoreaDTO> resultKeyword = spot.getKeywordInformation(visitKoreaDTO, keyword);
		
		return resultKeyword;
	}
	
	
	@GetMapping("/spot/review") 
	public String review(@RequestParam ("contentId")String contentId, @RequestParam("contentTypeId")String contentTypeId, Model model) throws Exception {
		
		// 관광지 정보 출력
		model.addAttribute("contentId", contentId);
		model.addAttribute("contentTypeId", contentTypeId);
		
		VisitKoreaDTO visitKoreaDTO = new VisitKoreaDTO();
		
		visitKoreaDTO.setContentId(contentId);
		visitKoreaDTO.setContentTypeId(contentTypeId);
		
		List<String> information = spot.getEachInformation(visitKoreaDTO);
		
		model.addAttribute("information", information);
		
		
		// 리뷰 내용 출력
		ArrayList<ReviewDTO> reviewList = spotService.getReviewInfo(contentId);
		
		int reviewSize = reviewList.size();
		
		model.addAttribute("reviewList", reviewList);
		model.addAttribute("reviewSize", reviewSize);
		
		int loginCheck = loginUserDTO.getUser_no();
		model.addAttribute("loginCheck", loginCheck);
		
		return "/spot/review";
	}
	
	
	@ResponseBody
	@GetMapping("/spot/write_proc")
	public String writeProc(@RequestParam("contentId")String contentId, @RequestParam("content")String content) {
		
		ReviewDTO writeReviewDTO = new ReviewDTO();
		
		writeReviewDTO.setContent_id(contentId);
		writeReviewDTO.setReview_content(content);
		
		spotService.inputReview(writeReviewDTO);
		spotService.plusReviewCnt(contentId);		
		
		return "/spot/review";
	}
	
	@ResponseBody
	@GetMapping("/spot/delete_proc")
	public void deleteProc(@RequestParam("review_idx")String review_idx, @RequestParam("contentId")String contentId) {
		
		int reviewIdx = Integer.parseInt(review_idx);
		
		spotService.deleteReview(reviewIdx);
		spotService.minusReviewCnt(contentId);
	}
	
	@ResponseBody
	@GetMapping("/spot/likeProc")
	public ArrayList<SpotDTO> likeProc(@RequestParam("contentId")String contentId) throws SAXException, IOException, ParserConfigurationException {
		
		ArrayList<SpotDTO> spotDTO = spotService.getSpotInfo();
		
		spotService.plusLikeCnt(contentId);
		
		return spotDTO;
	}
	 
}
