package com.adregamdi.controller;

import java.io.IOException;

import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.adregamdi.api.WeatherAPI;
import com.adregamdi.dto.WeatherDTO;

@Controller
public class MainController {
	
	@Autowired
	private WeatherAPI weatherAPI;
	
	@RequestMapping(value="/", method=RequestMethod.GET)
	public  String main(Model model) throws IOException, ParseException {
		
		WeatherDTO jeju = weatherAPI.getWeatherJeju();
		WeatherDTO seogwipo = weatherAPI.getWeatherSeogwipo();
		model.addAttribute("jeju", jeju);
		model.addAttribute("seogwipo", seogwipo);
		
		return "main";
	}
}
