-- together 테이블 삭제
DROP TABLE TOGETHER PURGE;

-- together SEQ 삭제
DROP SEQUENCE TOGETHER_SEQ;

-- together 테이블 생성
create table together(

    to_no		int					constraint together_pk primary key,						// 게시글번호
    to_writer	int					constraint together_fk references user_info(user_no),	// 회원번호
    to_title	varchar2(300)		not null,												// 공고제목	
    to_place	varchar2(300)		not null,												// 여행장소
    to_content	varchar2(4000)  	not null,												// 공고문
    to_date		date             	not null,												// 작성날짜	
    to_curr	number					not null,												// 현재인원	 
    to_total	number				not null,												// 모집인원	
    to_meet	varchar2(20)			not null,												// 여행날짜	
    to_state	number				not null												// 공고현황	
);

create sequence together_seq;
start with 1
increment by 1;