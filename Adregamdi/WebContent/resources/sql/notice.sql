-- notice 테이블 생성
CREATE TABLE notice
(
    notice_no         NUMBER CONSTRAINT notice_pk PRIMARY KEY, 
    notice_user_no    NUMBER constraint notice_fk REFERENCES user_info(user_no),
    notice_title      VARCHAR2(100)    NOT NULL, 
    notice_cnt        NUMBER           NOT NULL, 
    notice_date       DATE             NOT NULL, 
    notice_content    VARCHAR2(4000)    NOT NULL
);

-- notice 테이블 삭제
DROP TABLE notice PURGE;
DELETE FROM noitce;

-- notice 테이블 조회
SELECT * FROM notice;

-- notice 테이블에 데이터 삽입
INSERT INTO notice VALUES (notice_SEQ.nextval, 1, '공지사항1', '0', sysdate, '공지사항입니다.');

-- ***** 관리자 계정 설정 *****
UPDATE USER_INFO SET USER_PROVIDER=0 WHERE USER_NO=1;
-------------------------------------------------------------------------------------------------------------------------------

-- notice 테이블 시퀀스(notice_SEQ) 생성
CREATE SEQUENCE notice_SEQ
START WITH 1
INCREMENT BY 1;

-- notice 테이블 시퀀스(notice_SEQ) 삭제
DROP SEQUENCE notice_SEQ;

-- notice 테이블 시퀀스(notice_SEQ) 조회
SELECT notice_SEQ.CURRVAL FROM DUAL;

-- notice 테이블 시퀀스(notice_SEQ) 현재 값 조회
SELECT LAST_NUMBER FROM USER_SEQUENCES WHERE SEQUENCE_NAME='notice_SEQ';

-- notice 테이블 시퀀스(notice_SEQ) 'NEXTVAL' 값 조회
SELECT notice_SEQ.NEXTVAL FROM DUAL;
-------------------------------------------------------------------------------------------------------------------------------

-- 이전글, 다음글 기능 쿼리문
SELECT N.*
FROM (
    SELECT
        notice_no,
        LEAD(NOTICE_NO, 1) OVER (ORDER BY NOTICE_NO DESC) AS NEXT_NO,
        LEAD(NOTICE_TITLE, 1, '다음글이 없습니다') OVER (ORDER BY NOTICE_NO DESC) AS NEXT_TITLE,
        LAG(NOTICE_NO, 1) OVER (ORDER BY NOTICE_NO DESC) AS PRE_NO,
        LAG(NOTICE_TITLE, 1, '이전글이 없습니다') OVER (ORDER BY NOTICE_NO DESC) AS PRE_TITLE
    FROM NOTICE
) N
WHERE N.notice_no = 1;

-- 조회수 기능 쿼리문
UPDATE NOTICE SET notice_cnt = notice_cnt + 1 WHERE notice_no = #{notice_cnt}
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------