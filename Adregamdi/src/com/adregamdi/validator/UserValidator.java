package com.adregamdi.validator;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.adregamdi.dto.UserDTO;

public class UserValidator implements Validator {

	@Override
	public boolean supports(Class<?> clazz) {
		return UserDTO.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {
		UserDTO userDTO = (UserDTO)target;
		
		String dtoName = errors.getObjectName();
		
		if(dtoName.equals("joinUserDTO")) {
			if(userDTO.isInputUserID() == false) {
				errors.rejectValue("user_id", "DontCheckUserIdExist");
			}
		}
	}

}
