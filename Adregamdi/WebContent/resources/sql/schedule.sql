DROP TABLE USER_PLAN PURGE;
CREATE TABLE USER_PLAN (
    PLAN_NO        NUMBER,
    USER_NO        NUMBER,
    TITLE          VARCHAR2(200),
    CONTENTID      VARCHAR2(10),
    CONTENTTYPEID  VARCHAR2(5),
    ADDR           VARCHAR2(200),
    IMG_SRC        VARCHAR2(300),
    MAPX           VARCHAR2(20),
    MAPY           VARCHAR2(20),
    PLANDATE       VARCHAR2(30),
    PLANDAY        VARCHAR2(30),
    PLANTOTALDATE  VARCHAR2(30),
    STARTDATE      VARCHAR2(20),
    ENDDATE        VARCHAR2(20),
    DESCRIPT       VARCHAR2(1000),
    IS_INSERTAFTER VARCHAR(1) DEFAULT 'N',
    ISACC          VARCHAR(1) DEFAULT 'N'
);

DROP TABLE PLAN PURGE;
CREATE TABLE PLAN (
    PLAN_NO      NUMBER CONSTRAINT PLAN_PK PRIMARY KEY,
    USER_NO      NUMBER,
    PLAN_TITLE   VARCHAR2(200),
    PLAN_INFO    VARCHAR2(1000),
    PLAN_IMG     VARCHAR(300),
    PLAN_PRIVATE VARCHAR(1)
);

DROP SEQUENCE PLAN_SEQ;
CREATE SEQUENCE PLAN_SEQ
START WITH 1
INCREMENT BY 1;

DROP TABLE PLAN_IMG PURGE;
CREATE TABLE PLAN_IMG (
    PLAN_NO NUMBER,
    USER_NO NUMBER,
    PLAN_IMG VARCHAR2(300),
    REGDATE DATE
);

DROP TABLE USER_INFO PURGE;
CREATE TABLE USER_INFO
(
    USER_NO       NUMBER CONSTRAINT USER_PK PRIMARY KEY, 
    USER_NAME     VARCHAR2(15), 
    USER_ID       VARCHAR2(50) UNIQUE, 
    USER_PW       VARCHAR2(100), 
    USER_EMAIL    VARCHAR2(50) NOT NULL, 
    USER_PHONE    VARCHAR2(15) NOT NULL, 
    USER_PROVIDER NUMBER NOT NULL 
);

DROP SEQUENCE USER_INFO_SEQ;
CREATE SEQUENCE USER_INFO_SEQ
START WITH 1
INCREMENT BY 1;
select * from plan;
select * from user_info;
select * from user_plan;
SELECT * FROM PLAN WHERE PLAN_PRIVATE = 'N' ORDER BY PLAN_NO DESC;
insert into user_in;

SELECT PLAN_NO, COUNT(PLANTOTALDATE) FROM US;

INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '어드레감디 도내 관광업체(관광지, 음식, 쇼핑, 숙박) 등록안내', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '제주특별자치도 우수관광사업체 안내', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '개인정보처리방침 개정 시행안내', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '어드레감디 홈페이지 개인정보 처리방침 변경 사전안내', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '어드레감디 내 업체등록 안내', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '	제주특별자치도 숙박시설 통계 현황 자료 (2020. 12. 31 기준)', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '제주특별자치도 숙박시설 통계 현황 자료 (2021.01.31 기준)', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '제주특별자치도 숙박시설 통계 현황 자료 (2021. 02. 31 기준)', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '	제주특별자치도 숙박시설 통계 현황 자료 (2021. 03. 31)', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '	2021년 상반기 제주특별자치도 우수관광사업체 공모', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '어드레감디 내 유튜브 영상재생 브라우저 안내', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '(완료)비짓제주 서버 점검 및 업데이트에 따른 접속장애 예정 안내', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '	한라산 탐방예약제(성판악, 관음사 코스) 시범실시 안내', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '[긴급알림] 제주특별자치도 무사증입국불허국가 및 체류지역확대허가 국가', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '[여행정보변동] 도내 공영관광지 임시휴관 안내', '0', sysdate, '공지사항입니다.');

INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '[여행정보변동] 도내 공공시설 35곳 시범개방 안내', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '	고흥 녹동 ~ 제주 성산 선라이즈 제주호 취항 안내', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '	코로나 19 확산 차단을 위한 마스크 착용 의무화 행정조치계획 고시', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '제주여행지킴이 서비스 일시 중단 안내', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '	2021 에코파티 대면행사 개최취소 안내', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '탱귤이와 떠나는 안전한 제주여행 이벤트', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '어드레감디 #제값하는 착한가게 리뷰 이벤트 당첨자 안내', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '[사회적거리두기] 도내 관광지 등 이용인원 및 이용방법 제한 관련 안내', '0', sysdate, '공지사항입니다.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '비짓제주 서비스 복구 알림', '0', sysdate, '공지사항입니다.');
INSERT INTO notice
VALUES(notice_SEQ.nextval, 1, '[제주러뷰챌린지] 챌린지 당첨자 발표', '0', sysdate, '공지사항입니다.');

commit;
