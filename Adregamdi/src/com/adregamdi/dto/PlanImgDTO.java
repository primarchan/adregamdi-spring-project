package com.adregamdi.dto;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class PlanImgDTO {
	private int plan_no;
	private int user_no;
	private String plan_img;
	private String regdate;
	private MultipartFile upload_img;
}
