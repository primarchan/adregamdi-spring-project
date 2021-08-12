package com.adregamdi.dto;


import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class ScheduleDTO {
	private int    schedule_rowno;
	private int    schedule_no;
	private int    schedule_writer;
	private String schedule_start;
	private String schedule_end;
	private String schedule_title;
	private String schedule_content;
	private String schedule_date;	
}