package com.adregamdi.dao;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.adregamdi.dto.ReviewDTO;

import com.adregamdi.dto.SpotDTO;
import com.adregamdi.mapper.SpotMapper;

@Repository
public class SpotDAO {

	@Autowired
	SpotMapper spotMapper;
	
	public void inputContentId(SpotDTO likeDTO) {
		spotMapper.inputContentId(likeDTO);
	}
	
	public void plusLikeCnt(String content_id) {
		spotMapper.plusLikeCnt(content_id);
	}
	
	public ArrayList<SpotDTO> getSpotInfo() {
		return spotMapper.getSpotInfo();
	}
	
	public ArrayList<String> getBestSpotInfo1() {
		return spotMapper.getBestSpotInfo1();
	}
	
	public ArrayList<ReviewDTO> getReviewInfo(String content_id) {
		ArrayList<ReviewDTO> reviewDTO = spotMapper.getReviewInfo(content_id);		
		return reviewDTO;
	}
	
	public void inputReview(ReviewDTO reviewDTO) {
		spotMapper.inputReview(reviewDTO);
	}
	
	public void plusReviewCnt(String content_id) {
		spotMapper.plusReviewCnt(content_id);
	}
	
	public void deleteReview(int review_idx) {
		spotMapper.deleteReview(review_idx);
	}
	
	public void minusReviewCnt(String content_id) {
		spotMapper.minusReviewCnt(content_id);
	}
	
	public int getTotalSpot() {
		return spotMapper.getTotalSpot();
	}
}
