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
VALUES(notice_SEQ.nextval, 1, '��巹���� ���� ������ü(������, ����, ����, ����) ��Ͼȳ�', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '����Ư����ġ�� ����������ü �ȳ�', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '��������ó����ħ ���� ����ȳ�', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '��巹���� Ȩ������ �������� ó����ħ ���� �����ȳ�', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '��巹���� �� ��ü��� �ȳ�', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '	����Ư����ġ�� ���ڽü� ��� ��Ȳ �ڷ� (2020. 12. 31 ����)', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '����Ư����ġ�� ���ڽü� ��� ��Ȳ �ڷ� (2021.01.31 ����)', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '����Ư����ġ�� ���ڽü� ��� ��Ȳ �ڷ� (2021. 02. 31 ����)', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '	����Ư����ġ�� ���ڽü� ��� ��Ȳ �ڷ� (2021. 03. 31)', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '	2021�� ��ݱ� ����Ư����ġ�� ����������ü ����', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '��巹���� �� ��Ʃ�� ������� ������ �ȳ�', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '(�Ϸ�)�������� ���� ���� �� ������Ʈ�� ���� ������� ���� �ȳ�', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '	�Ѷ�� Ž�濹����(���Ǿ�, ������ �ڽ�) �ù��ǽ� �ȳ�', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '[��޾˸�] ����Ư����ġ�� �������Ա����㱹�� �� ü������Ȯ���㰡 ����', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '[������������] ���� ���������� �ӽ��ް� �ȳ�', '0', sysdate, '���������Դϴ�.');

INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '[������������] ���� �����ü� 35�� �ù����� �ȳ�', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '	���� �쵿 ~ ���� ���� �������� ����ȣ ���� �ȳ�', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '	�ڷγ� 19 Ȯ�� ������ ���� ����ũ ���� �ǹ�ȭ ������ġ��ȹ ����', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '���ֿ�����Ŵ�� ���� �Ͻ� �ߴ� �ȳ�', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '	2021 ������Ƽ ������ ������� �ȳ�', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '�ʱ��̿� ������ ������ ���ֿ��� �̺�Ʈ', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '��巹���� #�����ϴ� ���Ѱ��� ���� �̺�Ʈ ��÷�� �ȳ�', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '[��ȸ���Ÿ��α�] ���� ������ �� �̿��ο� �� �̿��� ���� ���� �ȳ�', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice 
VALUES(notice_SEQ.nextval, 1, '�������� ���� ���� �˸�', '0', sysdate, '���������Դϴ�.');
INSERT INTO notice
VALUES(notice_SEQ.nextval, 1, '[���ַ���ç����] ç���� ��÷�� ��ǥ', '0', sysdate, '���������Դϴ�.');

commit;