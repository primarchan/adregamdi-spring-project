-- TOGETHER --
DROP TABLE TOGETHER PURGE;
create table together(
    to_no      int      constraint together_pk primary key,         -- 게시글번호
    to_writer   int      constraint together_fk references user_info(user_no),   -- 회원번호
    to_title   varchar2(300)   not null,                  -- 공고제목   
    to_place   varchar2(300)   not null,                 -- 여행장소
    to_content   varchar2(4000)     not null,                  -- 공고문
    to_date   date                not null,                  -- 작성날짜   
    to_curr   number      not null,                  -- 현재인원    
    to_total   number      not null,                  -- 모집인원   
    to_meet   varchar2(20)   not null,                 -- 여행날짜   
    to_state   number      not null                  -- 공고현황   
);


INSERT INTO TOGETHER VALUES(1, 1, 'TEST', '휴애리', '같이가요같이', SYSDATE, 1, 4, '2021-6-7', 1);
SELECT * FROM TOGETHER where to_writer = 1;

ALTER TABLE TOGETHER DROP CONSTRAINT TOGETHER_FK;

ALTER TABLE TOGETHER ADD CONSTRAINT TOGETHER_FK FOREIGN KEY (TO_WRITER)
REFERENCES USER_INFO(user_no) ON DELETE CASCADE;



DROP SEQUENCE TOGETHER_SEQ;
CREATE SEQUENCE TOGETHER_SEQ
START WITH 1
INCREMENT BY 1;


commit;



DROP TABLE SUBSCRIPTION PURGE;
CREATE TABLE SUBSCRIPTION (
    sub_no      NUMBER  CONSTRAINT SUBSCRIPTION_PK PRIMARY KEY,
    to_no       NUMBER constraint SUBSCRIPTION_FK references TOGETHER(to_no),
    to_writer   NUMBER,
    sub_message VARCHAR2(500),
    sub_writer  NUMBER,
    sub_status  VARCHAR(1) DEFAULT '0',
    sub_date    DATE
);



SELECT * FROM USER_INFO;
SELECT * FROM SUBSCRIPTION;
INSERT INTO SUBSCRIPTION VALUES(2, 1, 1, '같이갈까요?', 1, '0', SYSDATE);
commit;