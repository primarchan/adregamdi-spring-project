package com.adregamdi.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.xml.parsers.ParserConfigurationException;

import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.xml.sax.SAXException;

import com.adregamdi.api.VisitKoreaAPI;
import com.adregamdi.dto.PageDTO;
import com.adregamdi.dto.PlanDTO;
import com.adregamdi.dto.PlanImgDTO;
import com.adregamdi.dto.UserDTO;
import com.adregamdi.dto.UserPlanDTO;
import com.adregamdi.dto.VisitKoreaDTO;
import com.adregamdi.service.ScheduleService;

import net.sf.json.JSONArray;

@Controller
@RequestMapping("/schedule")
public class ScheduleController {
	
	@Autowired
	private ScheduleService scheduleService;
	
	@Autowired
	private VisitKoreaAPI visitKoreaAPI;
	
	@Resource(name = "loginUserDTO")
	private UserDTO loginUserDTO;
	
	@GetMapping("/list")
	public String list(@RequestParam("page") int page, Model model) {
		
		List<PlanDTO> planList = scheduleService.getPlanList(page, 8);
		PageDTO pageDTO = scheduleService.getContentCnt(page, 8, 10);
		
		model.addAttribute("loginUserDTO", loginUserDTO);
		model.addAttribute("pageDTO", pageDTO);
		model.addAttribute("planList", planList);
		
		return "schedule/list";
	}
	
	@PostMapping("/write")
	public String write(@ModelAttribute PlanDTO planDTO, @RequestParam String plan_date, @RequestParam String plan_term, Model model) {

		scheduleService.createPlan(planDTO);
		
		model.addAttribute("loginUserDTO", loginUserDTO);
		model.addAttribute("plan_title", planDTO.getPlan_title());
		model.addAttribute("plan_date",  plan_date);
		model.addAttribute("plan_term", plan_term);
		model.addAttribute("plan_no", scheduleService.getPlanNo());
		
		return "schedule/write";
	}
	
	@PostMapping("/write_proc")
	public String write_proc(@RequestParam("planData") String data, RedirectAttributes redirectAttributes) throws ParseException {
		System.out.println(data);
		List<UserPlanDTO> list = scheduleService.convertUserPlan(data, loginUserDTO.getUser_no());
		System.out.println(list);
		for(int i = 0; i < list.size(); i++) {
			scheduleService.insertUserPlan(list.get(i));
		}
		redirectAttributes.addAttribute("plan_no", list.get(0).getPlan_no());
		redirectAttributes.addAttribute("purpose", "write");
		return "redirect:/schedule/writeDetail";
	}
	
	@GetMapping("/writeDetail")
	public String writeDetail(@RequestParam("plan_no") int plan_no, @RequestParam("purpose") String purpose, Model model) {
		PlanDTO planDTO = new PlanDTO();
		String isModify = "N";
		
		planDTO = scheduleService.getPlan(plan_no);
		List<UserPlanDTO> plan = new ArrayList<UserPlanDTO>();
		if(purpose.equals("write")) {
			plan = scheduleService.getUserPlanCreate(plan_no);
		}
		if(purpose.equals("modify")) {
			plan = scheduleService.readSchedule(plan_no);
			isModify = "Y";		
		}
		if(purpose.equals("schedule")) {
			plan = scheduleService.readSchedule(plan_no);
		}
		
		model.addAttribute("loginUserDTO", loginUserDTO);
		model.addAttribute("isModify", isModify);
		model.addAttribute("planDTO", planDTO);
		model.addAttribute("plan_no", plan_no);
		model.addAttribute("planTotalDate", plan.get(0).getPlanTotalDate());
		model.addAttribute("planList", JSONArray.fromObject(plan));
		return "schedule/writeDetail";
	}
	
	@PostMapping("/writeDetail_proc")
	public String writeDetail_proc(@RequestParam("schedule") String data) throws ParseException {
		
		List<UserPlanDTO> schedule = scheduleService.convertSchedule(data);
		
		scheduleService.deleteSchedule(schedule.get(0));
		
		for(int i = 0; i < schedule.size(); i++) {
			scheduleService.updateSchedule(schedule.get(i));
		}
		
		return "schedule/write_success";
	}
	
	@ResponseBody
	@GetMapping("/information")
	public List<VisitKoreaDTO> information(@ModelAttribute VisitKoreaDTO visitKoreaDTO, Model model) throws ParserConfigurationException, SAXException, IOException, InterruptedException {
		
		if(visitKoreaDTO.getPageNo() == null) {
			visitKoreaDTO.setPageNo("1");
		}
		
		if(visitKoreaDTO.getSigunguCode() == null) {
			visitKoreaDTO.setSigunguCode("");
		}
		
		if(visitKoreaDTO.getContentTypeId() == null) {
			visitKoreaDTO.setContentTypeId("");
		}
		
		int totalCount = visitKoreaAPI.getTotalCount(visitKoreaDTO.getContentTypeId(), visitKoreaDTO.getSigunguCode());
		return visitKoreaAPI.getInformation(visitKoreaDTO, totalCount);
	}
	
	@ResponseBody
	@GetMapping("/detail")
	public List<String> detail(@ModelAttribute VisitKoreaDTO visitKoreaDTO) throws Exception {
		return visitKoreaAPI.getEachInformation(visitKoreaDTO);
	}
	
	@GetMapping("/guide")
	public String guide(@ModelAttribute VisitKoreaDTO visitKoreaDTO, Model model) {
		model.addAttribute("contentId", visitKoreaDTO.getContentId());
		model.addAttribute("contentTypeId", visitKoreaDTO.getContentTypeId());
		return "schedule/detail";
	}
	
	@ResponseBody
	@GetMapping("/keyword")
	public List<VisitKoreaDTO> keyword(@ModelAttribute VisitKoreaDTO visitKoreaDTO, String keyword) throws ParserConfigurationException, SAXException, IOException, InterruptedException {
		
		if(visitKoreaDTO.getPageNo()==null) {
			visitKoreaDTO.setPageNo("1");
		}
		
		if(visitKoreaDTO.getSigunguCode() == null) {
			visitKoreaDTO.setSigunguCode("");
		}
		
		if(visitKoreaDTO.getContentTypeId() == null) {
			visitKoreaDTO.setContentTypeId("");
		}
		return visitKoreaAPI.getKeywordInformation(visitKoreaDTO, keyword);
	}
	
	@ResponseBody
	@PostMapping("/upload")
	public PlanDTO uploadPlanImg(@ModelAttribute PlanImgDTO planImgDTO) throws IllegalStateException, IOException {
		
		scheduleService.uploadPlanImg(planImgDTO);
		scheduleService.updatePlanImg(planImgDTO);
		
		return scheduleService.getPlan(planImgDTO.getPlan_no());
	}
	
	@ResponseBody
	@PostMapping("/update")
	public boolean uploadPlan(@ModelAttribute PlanDTO planDTO) {
				
		return scheduleService.updatePlan(planDTO);
	}
	
	@GetMapping("/read")
	public String read(@RequestParam("page") int page, @RequestParam("plan_no") int plan_no, Model model) {
		
		PlanDTO planDTO = scheduleService.getPlan(plan_no);
		List<UserPlanDTO> userPlanList = scheduleService.readSchedule(plan_no);
		int planTotalDate = Integer.parseInt(userPlanList.get(0).getPlanTotalDate());

		model.addAttribute("loginUserDTO", loginUserDTO);
		model.addAttribute("planDTO", planDTO);
		model.addAttribute("userPlanList", JSONArray.fromObject(userPlanList));
		model.addAttribute("planTotalDate", planTotalDate);
		model.addAttribute("page", page);
		
		return "schedule/read";
	}
	
	@ResponseBody
	@PostMapping("/delete")
	public boolean delete(@RequestParam("plan_no") int plan_no) {

		return scheduleService.deletePlan(plan_no) && scheduleService.deleteUserPlan(plan_no);
	}
	
	@GetMapping("/modify")
	public String modify(@RequestParam("plan_no") int plan_no, Model model) {
		
		PlanDTO plan = scheduleService.getPlan(plan_no);
		List<UserPlanDTO> planList = scheduleService.readSchedule(plan_no);
		String[] date = planList.get(0).getPlanDate().split("-");
		String plan_date = date[0] + "-" + date[1] + "-" + (Integer.parseInt(date[2]) - (Integer.parseInt(planList.get(0).getPlanDay()) - 1));
		model.addAttribute("loginUserDTO", loginUserDTO);
		model.addAttribute("planList", JSONArray.fromObject(planList));
		model.addAttribute("plan_title", plan.getPlan_title());
		model.addAttribute("plan_date", plan_date);
		model.addAttribute("plan_term", planList.get(0).getPlanTotalDate());
		model.addAttribute("plan_no", plan_no);
		
		return "schedule/modify";
	}
	
	@PostMapping("/modify_proc")
	public String modify_proc(@RequestParam("planData") String data, RedirectAttributes redirectAttributes) throws ParseException {
		
		List<UserPlanDTO> newPlan = scheduleService.convertUserPlan(data, loginUserDTO.getUser_no());
		List<UserPlanDTO> oldPlan = scheduleService.readSchedule(newPlan.get(0).getPlan_no());
		boolean isDiff = true;
		
		System.out.println(newPlan);
		System.out.println(oldPlan);
		
		scheduleService.deleteUserPlan(oldPlan.get(0).getPlan_no());
		
		for(int i = 0; i < newPlan.size(); i++) {
			isDiff = true;
			for(int j = 0; j < oldPlan.size(); j++) {
				if(newPlan.get(i).getTitle().equals(oldPlan.get(j).getTitle())) {
					System.out.println(oldPlan.get(j));
					if(oldPlan.get(j).getDescript() == null) {
						oldPlan.get(j).setDescript("");
					}
					scheduleService.modifyUserPlan(oldPlan.get(j));
					isDiff = false;
				}
			}
			
			if(isDiff) {
				System.out.println(newPlan.get(i));
				if(newPlan.get(i).getStartDate() == null) {
					newPlan.get(i).setStartDate("");
				}
				if(newPlan.get(i).getEndDate() == null) {
					newPlan.get(i).setEndDate("");
				}
				if(newPlan.get(i).getDescript() == null) {
					newPlan.get(i).setDescript("");
				}
				scheduleService.modifyUserPlan(newPlan.get(i));
			}
		}
		
		for(int i = 0; i < oldPlan.size(); i++) {
			if(oldPlan.get(i).getIs_insertAfter().equals("Y")) {
				scheduleService.updateSchedule(oldPlan.get(i));
			}
		}
		
		redirectAttributes.addAttribute("plan_no",oldPlan.get(0).getPlan_no());
		redirectAttributes.addAttribute("purpose","schedule");
		
		return "redirect:/schedule/writeDetail";
	}
}