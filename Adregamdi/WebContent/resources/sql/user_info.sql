CREATE TABLE user_info
(
    user_no       NUMBER           NOT NULL, 
    user_name     VARCHAR2(15)     , 
    user_id       VARCHAR2(50)     unique, 
    user_pw       VARCHAR2(100)    , 
    user_email    VARCHAR2(50)     NOT NULL, 
    user_phone    VARCHAR2(15)     NOT NULL, 
    user_provider NUMBER           NOT NULL,
    CONSTRAINT user_info_pk PRIMARY KEY (user_no)
);


-- user_info 테이블 시퀀스 생성
CREATE SEQUENCE user_info_SEQ
START WITH 1
INCREMENT BY 1;



-- 회원탈퇴를 위해 반드시 필요한 쿼리문
-- 외래키 컬럼 삭제
ALTER TABLE [각 게시판 테이블] DROP CONSTRAINT [외래키 이름];

-- ON DELETE CASCADE 를 적용한 외래키 재생성
ALTER TABLE [각 게시판 테이블] ADD CONSTRAINT [외래키 이름] FOREIGN KEY ([외래키 자식 컬럼])
REFERENCES USER_INFO(user_no) ON DELETE CASCADE;
