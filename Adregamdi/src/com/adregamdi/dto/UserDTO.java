package com.adregamdi.dto;

import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import lombok.Getter;
import lombok.Setter;

@Setter @Getter
public class UserDTO {
	
	private int 	user_no;
	
	@Size(min=1, max=6)
	@Pattern(regexp = "[가-힣]*")
	private String  user_name; 
	
	@Size(min=3, max=20)
	@Pattern(regexp = "[a-zA-Z0-9]*")
	private String  user_id;
	
	@Size(min=7, max=20)
	@Pattern(regexp = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d$@$!%*#?&]{7,}$")
	private String  user_pw;
	
	@Size(min=2, max=50)
	@Pattern(regexp = "^[a-zA-Z0-9]+@[a-z.-]+\\.[a-z]{2,6}$")
	private String  user_email;
	
	@Size(min=10, max=12)
	@Pattern(regexp = "[0-9]*")
	private String 	user_phone;
	
	private int user_provider;
	
	
	private boolean inputUserID;
	private boolean userLogin;
	

	
	

	
	public UserDTO() {
		this.setInputUserID(false);
		this.setUserLogin(false);
	}

	


	
}
