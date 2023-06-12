--객체
--오라클 데이터베이스 테이블
--1) 사용자 테이블
--2) 데이터 사전
--scott 계정에서 보기
SELECT * FROM DICTIONARY;
SELECT * FROM DICT;
--SCOTT 계정이 소유하고 있는 테이블
SELECT * FROM USER_TABLES;
--모든 사용자가 소유하고 있는 테이블
SELECT * FROM ALL_TABLES;
--관리자 계정이 있어야 볼 수 있는 내용
SELECT * FROM DBA_TABLES;
--분명히 존재하는데도 불구하고 SCOTT 계정에서 보면 존재하지 않는다고 뜨는 이유
--보안의 문제: 존재 여부를 알려주지 않아야 안전
--존재하지만 권한이 없다고 알려주면 테이블이 존재한다는 정보를 알려주는 꼴
--관리자 계정으로 접속해서 다시 확인하기
SELECT * FROM DBA_TABLES;
--관리자 계정으로 사용자 정보 확인
SELECT * FROM DBA_USERS WHERE USERNAME = 'SCOTT';
--다시 scott 계정으로 돌아오기
--인덱스
--DB 에 있는 데이터를 더 빠르게 찾도록 도와주는 객체
--인덱스가 없으면 전체를 다 찾음
--인덱스 정보 확인
SELECT * FROM USER_INDEXES;
--인덱스 열 정보 확인
SELECT * FROM USER_IND_COLUMNS;
--인덱스 생성
CREATE INDEX IDX_EMP_SAL ON EMP(SAL);
--방금 생성한 인덱스 열 정보 확인
SELECT * FROM USER_IND_COLUMNS;
--인덱스 삭제
DROP INDEX IDX_EMP_SAL;
--인덱스 삭제되었는지 확인
SELECT * FROM USER_IND_COLUMNS;
--뷰 - 테이블처럼 사용할 수 있는 객체
--사용 목적: 1) 편리성, 2) 보안성
--뷰 생성 권한이 필요
--관리자 계정으로 권한 부여
--명령 프롬프트에서 실행
sqlplus system/oracle
--권한 부여 = GRANT 권한 TO 계정
GRANT CREATE VIEW TO SCOTT;
--SCOTT 계정으로 실행하기
SELECT * FROM EMP WHERE DEPTNO = 10;
CREATE VIEW VW_EMP10
    AS (SELECT * FROM EMP WHERE DEPTNO = 10);
--뷰 생성 확인
SELECT * FROM USER_VIEWS;
--SQLPLUS 에서 다시 확인
sqlplus scott/tiger
SELECT VIEW_NAME, TEXT FROM USER_VIEWS;
--우리가 만든 뷰 사용
--SELECT * FROM EMP WHERE DEPTNO = 10; => VW_EMP10 로 대체하여 사용
SELECT * FROM EMP WHERE DEPTNO = 10;
SELECT * FROM VW_EMP10;
--뷰 삭제
DROP VIEW VW_EMP10;
--삭제가 되었는지 확인
SELECT * FROM VW_EMP10;
SELECT * FROM USER_VIEWS;
--ROWNUM = 테이블의 열이 아닌 가상의 열
SELECT ROWNUM, A.* FROM EMP A;
--급여가 높은 순으로 정렬
SELECT ROWNUM, A.* FROM EMP A ORDER BY SAL DESC;
--급여가 높은 순으로 정렬해서 ROWNUM 붙이려면 뷰를 사용해야 함
SELECT * FROM EMP ORDER BY SAL DESC;
--인라인뷰
SELECT ROWNUM, A.* FROM (SELECT * FROM EMP ORDER BY SAL DESC) A;
--WITH 절로 변환
WITH A AS (SELECT * FROM EMP ORDER BY SAL DESC)
SELECT ROWNUM, A.* FROM A;
--급여가 높은 상위 5개 보기
--인라인뷰
SELECT ROWNUM, A.* 
    FROM (SELECT * FROM EMP ORDER BY SAL DESC) A
    WHERE ROWNUM <= 5;
--WITH 절로 변환
WITH A AS (SELECT * FROM EMP ORDER BY SAL DESC)
SELECT ROWNUM, A.* FROM A WHERE ROWNUM <= 5;
--
--시퀀스 = 일련번호 생성하는 객체 = 규칙을 설정
--DEPT 테이블의 열 구조만 복사해서 테이블 생성
DROP TABLE DEPT_COPY;
CREATE TABLE DEPT_COPY
    AS SELECT * FROM DEPT WHERE 1 != 1;
SELECT * FROM DEPT_COPY;
--시퀀스 생성
CREATE SEQUENCE SEQ_DEPT
    INCREMENT BY 10
    START WITH 0
    MAXVALUE 90
    MINVALUE 0
    NOCYCLE
    CACHE 2;
--시퀀스 확인
SELECT * FROM USER_SEQUENCES;
--시퀀스 이용해서 데이터 추가 => 9번 반복
INSERT INTO DEPT_COPY (DEPTNO, DNAME, LOC)
    VALUES (SEQ_DEPT.NEXTVAL, 'DA', 'SEOUL');
SELECT * FROM DEPT_COPY;
--마지막으로 한번 더 해보면 이미 최대값에 도달했기 때문 추가 불가
INSERT INTO DEPT_COPY (DEPTNO, DNAME, LOC)
    VALUES (SEQ_DEPT.NEXTVAL, 'DA', 'SEOUL');
--시퀀스 사용 방법
SELECT SEQ_DEPT.CURRVAL FROM DUAL;
SELECT SEQ_DEPT.NEXTVAL FROM DUAL;
--시퀀스 변경
ALTER SEQUENCE SEQ_DEPT
    INCREMENT BY 3
    MAXVALUE 99
    CYCLE;
--데이터 입력 상태 먼저 확인
SELECT * FROM DEPT_COPY;
--3번 실행 = 최대값 99에 도달
INSERT INTO DEPT_COPY (DEPTNO, DNAME, LOC)
    VALUES (SEQ_DEPT.NEXTVAL, 'DA', 'SEOUL');
SELECT * FROM DEPT_COPY;
--3번 더 실행 = CYCLE 적용 = 최대값에 도달해도 최소값으로 다시 돌아감
INSERT INTO DEPT_COPY (DEPTNO, DNAME, LOC)
    VALUES (SEQ_DEPT.NEXTVAL, 'DA', 'SEOUL');
SELECT * FROM DEPT_COPY;
--시퀀스 삭제
DROP SEQUENCE SEQ_DEPT;
--삭제가 되었는지 확인
SELECT * FROM USER_SEQUENCES;
--시노님 = 공식적인 별칭 = 일회성이 아님 = 시노님 객체 삭제하기 전까지 계속해서 사용 가능
--SELECT 열 이름 AS 별칭 ~ => 일회성 별칭과 다름
--시노님 생성 권한이 필요
--관리자 계정으로 권한 부여
--명령 프롬프트에서 실행
sqlplus system/oracle
--권한 부여 = GRANT 권한 TO 계정
GRANT CREATE SYNONYM TO SCOTT;
GRANT CREATE PUBLIC SYNONYM TO SCOTT;
--SCOTT 계정으로 실행하기
CREATE SYNONYM E FOR EMP;
--시노님 사용
--EMP 대신에 E 라는 테이블 이름으로 사용 가능
SELECT * FROM EMP;
SELECT * FROM E;
--시노님 삭제
DROP SYNONYM E;
--삭제가 되었는지 확인
SELECT * FROM E;
--원래 이름 EMP 는 사용 가능
SELECT * FROM EMP;
--
--제약 조건
--1) NOT NULL = 빈값 허용하지 않음 = 빈값 불가
CREATE TABLE TABLE_NOTNULL(
    LOG_ID VARCHAR2(15) NOT NULL,
    LOG_PW VARCHAR2(15) NOT NULL,
    CP VARCHAR(15)
);
SELECT * FROM TABLE_NOTNULL;
DESC TABLE_NOTNULL;
--널값 추가 => 널값 불가 제약조건으로 인해 추가 불가
INSERT INTO TABLE_NOTNULL (LOG_ID, LOG_PW, CP)
    VALUES ('TEST_ID_1', NULL, '010-1234-5678');
INSERT INTO TABLE_NOTNULL (LOG_ID, CP)
    VALUES ('TEST_ID_1', '010-1234-5678');
--전화번호에 널값 추가 => 제약조건이 없기 때문에 입력 가능
INSERT INTO TABLE_NOTNULL (LOG_ID, LOG_PW)
    VALUES ('TEST_ID_1', 'TEST_PW_1');
SELECT * FROM TABLE_NOTNULL;
--널값으로 변경 => 널값 불가 제약조건으로 인해 변경 불가
UPDATE TABLE_NOTNULL
    SET LOG_PW = NULL
    WHERE LOG_ID = 'TEST_ID_1';
--제약 조건 확인
--P = PRIMARY KEY
--R = REFERENCE
--C = CHECK / NOT NULL
--U = UNIQUE
SELECT * FROM USER_CONSTRAINTS;
--제약조건 이름 지정
CREATE TABLE TABLE_NOTNULL1(
    LOG_ID VARCHAR2(15) CONSTRAINT TBNN1_LOGID_NN NOT NULL,
    LOG_PW VARCHAR2(15) CONSTRAINT TBNN1_LOGPW_NN NOT NULL,
    CP VARCHAR(15)
);
--제약 조건 확인
SELECT * FROM USER_CONSTRAINTS;
--제약 조건 변경(추가) => 이미 널값이 있기 때문에 변경 안됨
ALTER TABLE TABLE_NOTNULL
    MODIFY (CP NOT NULL);
--전화 번호 널값을 다른 값으로 변경
SELECT * FROM TABLE_NOTNULL;
UPDATE TABLE_NOTNULL
    SET CP = '010-1234-5678'
    WHERE LOG_ID = 'TEST_ID_1';
SELECT * FROM TABLE_NOTNULL;
--제약 조건 변경(추가) => 널값이 없기 때문에 변경 가능
ALTER TABLE TABLE_NOTNULL
    MODIFY (CP NOT NULL);
--혹시 TABLE_NOTNULL1 테이블에 전화번호 제약조건을 만들었을 경우에는 지우고 실습
SELECT * FROM USER_CONSTRAINTS;
ALTER TABLE TABLE_NOTNULL1 DROP CONSTRAINT SYS_C0011057;
--제약 조건 변경(추가)
ALTER TABLE TABLE_NOTNULL1
    MODIFY (CP CONSTRAINT TBNN1_CP_NN NOT NULL);
--제약 조건 확인
SELECT * FROM USER_CONSTRAINTS;
DESC TABLE_NOTNULL;
DESC TABLE_NOTNULL1;
--제약 조건 이름 변경
ALTER TABLE TABLE_NOTNULL1
    RENAME CONSTRAINT TBNN1_CP_NN TO TBNN1_CP_NN_AFTER;
--제약 조건 확인
SELECT * FROM USER_CONSTRAINTS;
--제약 조건 삭제
ALTER TABLE TABLE_NOTNULL1
    DROP CONSTRAINT TBNN1_CP_NN_AFTER;
--제약 조건 확인
SELECT * FROM USER_CONSTRAINTS;
--
--UNIQUE = 중복 불가
--이름 지정하여 제약조건 만들기
CREATE TABLE TB_UNQ(
    LOG_ID VARCHAR2(15) CONSTRAINT TBUNQ_LOGID_UNQ UNIQUE,
    LOG_PW VARCHAR2(15) CONSTRAINT TBUNQ_LOGPW_UNQ UNIQUE,
    CP     VARCHAR2(15)
);
--제약 조건 확인
SELECT * FROM USER_CONSTRAINTS WHERE CONSTRAINT_NAME LIKE 'TBUNQ%';
--데이터 추가
INSERT INTO TB_UNQ (LOG_ID, LOG_PW, CP)
    VALUES ('TEST_ID_1', 'TEST_PW_1', '010-1234-5678');
--한번 더 실행 => ID 와 PW 는 중복 불가라는 제약조건으로 인해 추가 불가
INSERT INTO TB_UNQ (LOG_ID, LOG_PW, CP)
    VALUES ('TEST_ID_1', 'TEST_PW_1', '010-1234-5678');
--전화번호는 제약조건이 없기 때문에 중복 입력 가능
INSERT INTO TB_UNQ (LOG_ID, LOG_PW, CP)
    VALUES ('TEST_ID_2', 'TEST_PW_2', '010-1234-5678');
SELECT * FROM TB_UNQ;
--널값 추가 => UNIQUE 는 중복 불가이지 널값 불가 아님 = 널값 입력 가능
INSERT INTO TB_UNQ (LOG_ID, LOG_PW, CP)
    VALUES (NULL, 'TEST_PW_3', '010-1234-5678');
SELECT * FROM TB_UNQ;
--널값은 중복 대상 아님 & UNIQUE 는 중복 불가이지 널값 불가 아님 = 널값 입력 가능
INSERT INTO TB_UNQ (LOG_PW, CP)
    VALUES ('TEST_PW_4', '010-1234-5678');
SELECT * FROM TB_UNQ;
--데이터 변경 => 중복 불가 제약 조건으로 인해 중복 데이터 변경 불가
UPDATE TB_UNQ
    SET LOG_ID = 'TEST_ID_1'
    WHERE LOG_PW = 'TEST_PW_3';
--중복 불가 제약 조건이 있기 때문에 중복 데이터가 아닌 값으로 변경
UPDATE TB_UNQ
    SET LOG_ID = 'TEST_ID_3'
    WHERE LOG_PW = 'TEST_PW_3';
SELECT * FROM TB_UNQ;
--기본키 = PRIMARY KEY = NOT NULL + UNIQUE
CREATE TABLE TB_PK(
    LOG_ID VARCHAR2(15) CONSTRAINT TBPK_LOGID_PK PRIMARY KEY,
    LOG_PW VARCHAR2(15) CONSTRAINT TBPK_LOGPW_NN NOT NULL,
    CP VARCHAR2(15)
);
--데이터 추가
INSERT INTO TB_PK (LOG_ID, LOG_PW, CP)
    VALUES ('TEST_ID_1', 'TEST_PW_1', '010-1234-5678');
SELECT * FROM TB_PK;
--한번 더 실행 = 중복 데이터 입력 안됨 => ID 는 PK = 중복 불가 + 널값 불가
INSERT INTO TB_PK (LOG_ID, LOG_PW, CP)
    VALUES ('TEST_ID_1', 'TEST_PW_1', '010-1234-5678');
--PW 는 널값 불가이기 때문에 중복 데이터는 입력 가능
INSERT INTO TB_PK (LOG_ID, LOG_PW, CP)
    VALUES ('TEST_ID_2', 'TEST_PW_1', '010-1234-5678');
SELECT * FROM TB_PK;
--널값 추가 = 널값 입력 안됨 => ID 는 PK = 중복 불가 + 널값 불가
INSERT INTO TB_PK (LOG_ID, LOG_PW, CP)
    VALUES (NULL, 'TEST_PW_1', '010-1234-5678');
--외래키 = FOREIGN KEY = 참조키 = 다른 테이블의 기본키를 참조
--EMP, DEPT 테이블이 가지고 있는 제약조건 확인
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME IN ('EMP', 'DEPT');
--EMP 테이블에 DEPT 테이블에 없는 부서 번호를 입력
SELECT * FROM EMP;
SELECT * FROM DEPT;
--참조할 수 있는 값이 없기 때문에 입력 안됨 = 부서 테이블에 90번 부서 데이터가 없음
--부서 테이블에 90번 데이터 먼저 입력한 다음에 사원 정보 입력해야 정상적으로 추가 가능
INSERT INTO EMP
    VALUES (9999, 'QUEEN', 'VICE', 7839, '2023-05-23', 5000, NULL, 90);
--테이블 생성
CREATE TABLE DEPT_FK(
    DEPTNO NUMBER(2) CONSTRAINT DEPTFK_DEPTNO_FK PRIMARY KEY,
    DNAME  VARCHAR2(15)
);
CREATE TABLE EMP_FK(
    EMPNO NUMBER(4) CONSTRAINT EMPFK_EMPNO_PK PRIMARY KEY,
    ENAME VARCHAR2(10),
    DEPTNO NUMBER(2) CONSTRAINT EMPFK_DEPTNO_FK REFERENCES DEPT_FK(DEPTNO)
);
--사원 추가 = 참조할 수 있는 값이 없기 때문에 추가 불가
--참조할 수 있는 값을 먼저 만들어야 함 = 부서 추가
INSERT INTO EMP_FK
    VALUES (9999, 'QUEEN', 10);
SELECT * FROM DEPT_FK;
--부서 추가
INSERT INTO DEPT_FK 
    VALUES (10, 'DA');
SELECT * FROM DEPT_FK;
--다시 사원 추가 = 참조할 수 있는 값이 있기 때문에 추가 가능
INSERT INTO EMP_FK
    VALUES (9999, 'QUEEN', 10);
--외래키가 있을 때 데이터 입력 순서
--1) 외래키 생성
--2) 참조할 부서 데이터 입력 (예, 부서 10번)
--3) 직원 데이터 입력 가능 (예, 직원 QUEEN)
--
--부서 삭제
SELECT * FROM DEPT_FK;
SELECT * FROM EMP_FK;
--10번 부서를 참조하고 있는 직원이 있기 때문에 삭제 불가
--사원을 먼저 삭제
DELETE DEPT_FK WHERE DEPTNO = 10;
--사원 삭제
DELETE EMP_FK WHERE EMPNO = 9999;
SELECT * FROM EMP_FK;
--다시 부서 삭제 => 더이상 10번 부서번호를 참조하고 있는 사원이 없기 때문 
DELETE DEPT_FK WHERE DEPTNO = 10;
SELECT * FROM DEPT_FK;
--외래키가 있을 때 데이터 삭제 순서
--1) 참조하고 있는 데이터 = 10번 부서 번호를 참조하고 있는 직원 데이터 삭제
--2) 부서 데이터 삭제
--
