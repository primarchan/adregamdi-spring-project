package com.adregamdi.dao;

import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.adregamdi.dto.PlanDTO;
import com.adregamdi.dto.PlanImgDTO;
import com.adregamdi.dto.UserPlanDTO;
import com.adregamdi.mapper.ScheduleMapper;

@Repository
public class ScheduleDAO {
	
	@Autowired
	private ScheduleMapper scheduleMapper;
	
	public int createPlan(PlanDTO planDTO) {
		return scheduleMapper.createPlan(planDTO);
	}
	
	public int getPlanNo() {
		return scheduleMapper.getPlanNo();
	}
	
	public int insertUserPlan(UserPlanDTO userPlanDTO) {
		return scheduleMapper.insertUserPlan(userPlanDTO);
	}
	
	public PlanDTO getPlan(int plan_no) {
		return scheduleMapper.getPlan(plan_no);
	}
	
	public List<UserPlanDTO> getUserPlanCreate(int plan_no) {
		return scheduleMapper.getUserPlanCreate(plan_no);
	}
	
	public void uploadPlanImg(PlanImgDTO planImgDTO) {
		scheduleMapper.uploadPlanImg(planImgDTO);
	}
	
	public void updatePlanImg(PlanImgDTO planImgDTO) {
		scheduleMapper.updatePlanImg(planImgDTO);
	}
	
	public int updatePlan(PlanDTO planDTO) {
		return scheduleMapper.updatePlan(planDTO);
	}
	
	public int deleteSchedule(UserPlanDTO userPlanDTO) {
		return scheduleMapper.deleteSchedule(userPlanDTO);
	}
	
	public int updateSchedule(UserPlanDTO userPlanDTO) {
		return scheduleMapper.updateSchedule(userPlanDTO);
	}
	
	public List<PlanDTO> getPlanList(RowBounds rowbounds) {
		return scheduleMapper.getPlanList(rowbounds);
	}
	
	public int getContentCnt() {
		return scheduleMapper.getContentCnt();
	}
	
	public List<UserPlanDTO> readSchedule(int plan_no) {
		return scheduleMapper.readSchedule(plan_no);
	}
	
	public int deletePlan(int plan_no) {
		return scheduleMapper.deletePlan(plan_no);
	}
	
	public int deleteUserPlan(int plan_no) {
		return scheduleMapper.deleteUserPlan(plan_no);
	}
	
	public int modifyUserPlan(UserPlanDTO userPlanDTO) {
		return scheduleMapper.modifyUserPlan(userPlanDTO);
	}
}