package com.adregamdi.dto;

import lombok.Data;

@Data
public class SubscriptionDTO {
	private int sub_no;
	private int to_no;
	private int to_writer_no;
	private String sub_message;
	private int sub_writer;
	private String sub_status;
	private String sub_date;
	private String notifi_writer;
}
