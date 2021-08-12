package com.adregamdi.dto;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class PlanDTO {
	private int    plan_no;
	private int	   user_no;
	private String plan_title;
	private String plan_info;
	private String plan_img;
	private String plan_private;
	private int    plan_term;
}