package com.adregamdi.dto;

import lombok.Data;

@Data
public class WeatherDTO {
	private float temper;
	private float rain;
	private int sky; // 맑음(0 / clear-day), 구름많음(1 / partly-cloudy-day), 흐림(2 / cloudy), 비(3 / rain), 눈(4 / snow)
	private float wind;
}

/*
	기온(T1H) - 단위 : °C
	강수량(RN1) - 단위 : mm
	하늘상태(SKY) - 코드 값 : 맑음(1), 구름많음(3), 흐림(4)
	강수형태(PTY) - 코드 값 : 없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4), 빗방울(5), 빗방울/눈날림(6), 눈날림(7)
	풍속(WSD) - 단위 : m/s
*/