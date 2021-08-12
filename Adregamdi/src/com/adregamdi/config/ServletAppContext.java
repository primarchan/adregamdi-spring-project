package com.adregamdi.config;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.mapper.MapperFactoryBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.adregamdi.dto.UserDTO;
import com.adregamdi.interceptor.LoginBlockInterceptor;
import com.adregamdi.interceptor.LoginInterceptor;
import com.adregamdi.interceptor.TopMenuInterceptor;
import com.adregamdi.mapper.FreedomBoardMapper;
import com.adregamdi.mapper.NoticeMapper;
import com.adregamdi.mapper.ScheduleMapper;
import com.adregamdi.mapper.SpotMapper;
import com.adregamdi.mapper.TogetherMapper;
import com.adregamdi.mapper.UserMapper;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = {"com.adregamdi.controller", "com.adregamdi.dto", "com.adregamdi.dao", "com.adregamdi.service", "com.adregamdi.api"})
@PropertySource("/WEB-INF/properties/db.properties")
public class ServletAppContext implements WebMvcConfigurer {

	@Value("${db.classname}")
	private String db_classname;

	@Value("${db.url}")
	private String db_url;

	@Value("${db.username}")
	private String db_username;

	@Value("${db.password}")
	private String db_password;

	@Resource(name = "loginUserDTO")
	private UserDTO loginUserDTO;

	@Override
	public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
		converters.add(new MappingJackson2HttpMessageConverter());
	}
	
	@Override
	public void configureViewResolvers(ViewResolverRegistry registry) {
		WebMvcConfigurer.super.configureViewResolvers(registry);
		registry.jsp("/WEB-INF/view/", ".jsp");
	}

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		WebMvcConfigurer.super.addResourceHandlers(registry);
		registry.addResourceHandler("/**").addResourceLocations("/resources/");
	}

	@Bean
	public BasicDataSource dataSource() {
		BasicDataSource source = new BasicDataSource();
		source.setDriverClassName(db_classname);
		source.setUrl(db_url);
		source.setUsername(db_username);
		source.setPassword(db_password);

		return source;
	}

	@Bean
	public SqlSessionFactory factory(BasicDataSource source) throws Exception {
		SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
		factoryBean.setDataSource(source);
		SqlSessionFactory factory = factoryBean.getObject();
		return factory;
	}

	@Bean
	public MapperFactoryBean<ScheduleMapper> getScheduleMapper(SqlSessionFactory factory) {
		MapperFactoryBean<ScheduleMapper> factoryBean = new MapperFactoryBean<ScheduleMapper>(ScheduleMapper.class);
		factoryBean.setSqlSessionFactory(factory);
		return factoryBean;
	}

	@Bean
	public MapperFactoryBean<SpotMapper> getSpotMapper(SqlSessionFactory factory) throws Exception {
		MapperFactoryBean<SpotMapper> factoryBean = new MapperFactoryBean<SpotMapper>(SpotMapper.class);
		factoryBean.setSqlSessionFactory(factory);
		return factoryBean;
	}

	@Bean
	public MapperFactoryBean<TogetherMapper> getTogetherMapper(SqlSessionFactory factory) {
		MapperFactoryBean<TogetherMapper> factoryBean = new MapperFactoryBean<TogetherMapper>(TogetherMapper.class);
		factoryBean.setSqlSessionFactory(factory);
		return factoryBean;
	}

	@Bean
	public MapperFactoryBean<FreedomBoardMapper> FreedomBoardMapper(SqlSessionFactory factory) {
		MapperFactoryBean<FreedomBoardMapper> factoryBean = new MapperFactoryBean<FreedomBoardMapper>(
				FreedomBoardMapper.class);
		factoryBean.setSqlSessionFactory(factory);
		return factoryBean;
	}

	@Bean
	public MapperFactoryBean<UserMapper> getUserMapper(SqlSessionFactory factory) {
		MapperFactoryBean<UserMapper> factoryBean = new MapperFactoryBean<UserMapper>(UserMapper.class);
		factoryBean.setSqlSessionFactory(factory);
		return factoryBean;
	}

	
	@Bean
	public MapperFactoryBean<NoticeMapper> getNoticeMapper(SqlSessionFactory factory) {
		MapperFactoryBean<NoticeMapper> factoryBean = new MapperFactoryBean<NoticeMapper>(NoticeMapper.class);
		factoryBean.setSqlSessionFactory(factory);
		return factoryBean;
	}
	
	// 인터셉터 등록 부분
	public void addInterceptors(InterceptorRegistry registry) {
		WebMvcConfigurer.super.addInterceptors(registry);

		TopMenuInterceptor topMenuInterceptor = new TopMenuInterceptor(loginUserDTO);

		LoginInterceptor loginInterceptor = new LoginInterceptor(loginUserDTO);

		LoginBlockInterceptor loginBlockInterceptor = new LoginBlockInterceptor(loginUserDTO);
		
	  	InterceptorRegistration topReg
	  	  = registry.addInterceptor(topMenuInterceptor);
		
	  	InterceptorRegistration not_loginReg
		  = registry.addInterceptor(loginInterceptor);
	  	
	  	InterceptorRegistration active_loginReg
		  = registry.addInterceptor(loginBlockInterceptor);
	  	
	  	// 각 인터셉터별 실행시킬 Mapper 부분
	  	topReg.addPathPatterns("/**");
	  	
	  	not_loginReg.addPathPatterns("/user/modify", "/user/logout", "/user/delete",
	  			"/notice/modify", "/notice/delete", "/notice/write", "/user/my_page", "/user/my_to", "/user/my_page_disable");

	  	active_loginReg.addPathPatterns("/user/login", "/user/join", "/notice/write", "/notice/modify");
	  	
	
	}

	// properties 占쎈쨨占쎈쐭 占쎈툧占쎈퓠 占쎌뿳占쎈뮉 properties占쎈솁占쎌뵬占쎈굶占쎌뵠 �빊�뫖猷롳옙由븝쭪占� 占쎈륫占쎈즲嚥∽옙 揶쏆뮆�롳옙�읅占쎌몵嚥∽옙 �꽴占썹뵳�뗫퉸雅뚯눖�뮉 Bean
	@Bean
	public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
		return new PropertySourcesPlaceholderConfigurer();
	}

	// 占쎈솁占쎌뵬 筌ｌ꼶�봺
	@Bean
	public StandardServletMultipartResolver multipartResolver() {
		return new StandardServletMultipartResolver();
	}
	
	@Bean
	public static PropertySourcesPlaceholderConfigurer
	propertySourcePlaceholderConfigurer() {
	 	return new PropertySourcesPlaceholderConfigurer();
	}
	
	@Bean
	public ReloadableResourceBundleMessageSource messageSource() {
		ReloadableResourceBundleMessageSource res =
				new ReloadableResourceBundleMessageSource();
		res.setBasenames("/WEB-INF/properties/error_message");
		return res;
	}
}