package com.adregamdi.api;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Service;

import com.adregamdi.dto.WeatherDTO;


@Service
public class WeatherAPI {
	final String serviceKey = "1Pu4UXuCj88qEZ2m7lWAsNCj4FcA8nhUutYQlXwqrnKRQiB5cuYHPlvedpq%2B0uoo8%2FuZ0TqCSiMtt0BA51OWNA%3D%3D";
	
	public WeatherDTO getWeatherJeju() throws IOException, ParseException {
		WeatherDTO weatherDTO = new WeatherDTO();
		
		SimpleDateFormat format1 = new SimpleDateFormat ( "yyyyMMdd");
		SimpleDateFormat format2 = new SimpleDateFormat ( "HH" );
				
		Date today = new Date();
		Date yesterday = new Date(today.getTime() - (1000 * 60 * 60 * 24));
		int currentTime = Integer.parseInt(format2.format(today));
		int baseTime = (currentTime != 0) ? Integer.parseInt(format2.format(today)) - 1 : 23;
		
		String date = "";
		
		if(currentTime == 0) {
			date = format1.format(yesterday);
		} else {
			date = format1.format(today);
		}
		
		String time = "";
		if(baseTime  < 10) {
			time = "0" + baseTime + "00";
		} else {
			time =  baseTime + "00";
		}
		
		String preTime = "";
		if(currentTime  < 10) {
			preTime = "0" + currentTime + "00";
		} else {
			preTime =  currentTime + "00";
		}
		
		String urlStr = "http://apis.data.go.kr/1360000/VilageFcstInfoService/getUltraSrtFcst?"
									 + "serviceKey=" + serviceKey
									 + "&numOfRows=60"
									 + "&pageNo=1"
									 + "&dataType=json"
									 + "&base_date=" + date
									 + "&base_time=" + time
									 + "&nx=53"
									 + "&ny=38";
				
		URL url = new URL(urlStr);
		
		BufferedReader br;
		String line = "";
		String result = "";
		
		br = new BufferedReader(new InputStreamReader(url.openStream(), "UTF-8"));
		
		while((line=br.readLine())!=null) {
			result = result.concat(line);
		}
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject) parser.parse(result);
		JSONObject response = (JSONObject) object.get("response");
		JSONObject body = (JSONObject) response.get("body");
		JSONObject items = (JSONObject) body.get("items");
		JSONArray item = (JSONArray) items.get("item");
		String sky = "";
		String pty = "";
		for(int i = 0; i < item.size(); i++) {
			JSONObject obj = (JSONObject) item.get(i);
			String fcstTime = (String) obj.get("fcstTime");
			String category = (String) obj.get("category");
			if(fcstTime.equals(preTime) && category.equals("T1H")) {
				String fcstValue = (String) obj.get("fcstValue");
				weatherDTO.setTemper(Float.parseFloat(fcstValue));
			}
			if(fcstTime.equals(preTime) && category.equals("RN1")) {
				String fcstValue = (String) obj.get("fcstValue");
				weatherDTO.setRain(Float.parseFloat(fcstValue));
			}
			if(fcstTime.equals(preTime) && category.equals("SKY")) {
				sky = (String) obj.get("fcstValue");
			}
			if(fcstTime.equals(preTime) && category.equals("PTY")) {
				pty = (String) obj.get("fcstValue");
			}
			if(fcstTime.equals(preTime) && category.equals("WSD")) {
				String fcstValue = (String) obj.get("fcstValue");
				weatherDTO.setWind(Float.parseFloat(fcstValue));
			}
		}
		
		if(sky.equals("1") && pty.equals("0")) {
			weatherDTO.setSky(0);
		}
		if(sky.equals("3") && pty.equals("0")) {
			weatherDTO.setSky(1);
		}
		if(sky.equals("4") && pty.equals("0")) {
			weatherDTO.setSky(2);
		}
		if(pty.equals("1") || pty.equals("2") || pty.equals("4") || pty.equals("5")) {
			weatherDTO.setSky(3);
		}
		if(pty.equals("3") || pty.equals("6") || pty.equals("7")) {
			weatherDTO.setSky(4);
		}
		return weatherDTO;
	}
	
	public WeatherDTO getWeatherSeogwipo() throws IOException, ParseException {
		WeatherDTO weatherDTO = new WeatherDTO();
		
		SimpleDateFormat format1 = new SimpleDateFormat ( "yyyyMMdd");
		SimpleDateFormat format2 = new SimpleDateFormat ( "HH" );
				
		Date today = new Date();
		Date yesterday = new Date(today.getTime() - (1000 * 60 * 60 * 24));
		
		int currentTime = Integer.parseInt(format2.format(today));
		int baseTime = (currentTime != 0) ? Integer.parseInt(format2.format(today)) - 1 : 23;
		
		String date = "";
		
		if(currentTime == 0) {
			date = format1.format(yesterday);
		} else {
			date = format1.format(today);
		}
		
		String time = "";
		if(baseTime  < 10) {
			time = "0" + baseTime + "00";
		} else {
			time =  baseTime + "00";
		}
		
		String preTime = "";
		if(currentTime  < 10) {
			preTime = "0" + currentTime + "00";
		} else {
			preTime =  currentTime + "00";
		}
		
		String urlStr = "http://apis.data.go.kr/1360000/VilageFcstInfoService/getUltraSrtFcst?"
				+ "serviceKey=" + serviceKey
				+ "&numOfRows=60"
				+ "&pageNo=1"
				+ "&dataType=json"
				+ "&base_date=" + date
				+ "&base_time=" + time
				+ "&nx=52"
				+ "&ny=33";
		
		URL url = new URL(urlStr);
		
		BufferedReader br;
		String line = "";
		String result = "";
		
		br = new BufferedReader(new InputStreamReader(url.openStream(), "UTF-8"));
		
		while((line=br.readLine())!=null) {
			result = result.concat(line);
		}
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject) parser.parse(result);
		JSONObject response = (JSONObject) object.get("response");
		JSONObject body = (JSONObject) response.get("body");
		JSONObject items = (JSONObject) body.get("items");
		JSONArray item = (JSONArray) items.get("item");
		String sky = "";
		String pty = "";
		for(int i = 0; i < item.size(); i++) {
			JSONObject obj = (JSONObject) item.get(i);
			String fcstTime = (String) obj.get("fcstTime");
			String category = (String) obj.get("category");
			if(fcstTime.equals(preTime) && category.equals("T1H")) {
				String fcstValue = (String) obj.get("fcstValue");
				weatherDTO.setTemper(Float.parseFloat(fcstValue));
			}
			if(fcstTime.equals(preTime) && category.equals("RN1")) {
				String fcstValue = (String) obj.get("fcstValue");
				weatherDTO.setRain(Float.parseFloat(fcstValue));
			}
			if(fcstTime.equals(preTime) && category.equals("SKY")) {
				sky = (String) obj.get("fcstValue");
			}
			if(fcstTime.equals(preTime) && category.equals("PTY")) {
				pty = (String) obj.get("fcstValue");
			}
			if(fcstTime.equals(preTime) && category.equals("WSD")) {
				String fcstValue = (String) obj.get("fcstValue");
				weatherDTO.setWind(Float.parseFloat(fcstValue));
			}
		}
		
		if(sky.equals("1") && pty.equals("0")) {
			weatherDTO.setSky(0);
		}
		if(sky.equals("3") && pty.equals("0")) {
			weatherDTO.setSky(1);
		}
		if(sky.equals("4") && pty.equals("0")) {
			weatherDTO.setSky(2);
		}
		if(pty.equals("1") || pty.equals("2") || pty.equals("4") || pty.equals("5")) {
			weatherDTO.setSky(3);
		}
		if(pty.equals("3") || pty.equals("6") || pty.equals("7")) {
			weatherDTO.setSky(4);
		}
		return weatherDTO;
	}
}
