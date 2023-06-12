--다중행 서브쿼리(계속)
--EXISTS 연산자 - 서브쿼리에 결과가 있으면 TRUE 없으면 FALSE
SELECT DNAME FROM DEPT WHERE DEPTNO = 10; --결과가 하나 존재하기 때문에 TRUE
--EXISTS 연산자에서 TRUE 로 사용이 되면 앞에 SQL 문이 정상적으로 실행이 됨
SELECT * FROM EMP WHERE EXISTS (SELECT DNAME FROM DEPT WHERE DEPTNO = 10);
SELECT * FROM EMP;
SELECT DNAME FROM DEPT WHERE DEPTNO = 100; --결과가 존재하지 않기 때문에 FALSE
--EXISTS 연산자에서 FALSE 로 사용이 되면 앞에 SQL 문이 정상적으로 실행이 되지 않음 = 데이터 출력 없음
SELECT * FROM EMP WHERE EXISTS (SELECT DNAME FROM DEPT WHERE DEPTNO = 100);
--다중열 서브쿼리 = 열이 여러 개 = 복수열 서브쿼리
--실무에서 꽤 많이 사용하므로 꼭 기억!
SELECT DEPTNO, MIN(SAL) FROM EMP GROUP BY DEPTNO; 
SELECT * FROM EMP WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, MIN(SAL) FROM EMP GROUP BY DEPTNO);
SELECT DEPTNO, MAX(SAL) FROM EMP GROUP BY DEPTNO; 
SELECT * FROM EMP WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, MAX(SAL) FROM EMP GROUP BY DEPTNO);
--FROM 절 뒤에 사용하는 서브쿼리
--인라인 뷰 = SQL 문 실행 결과를 마치 테이블처럼 사용
SELECT * FROM EMP WHERE DEPTNO = 30;
SELECT * FROM DEPT;
SELECT E30.EMPNO, E30.ENAME, D.DEPTNO, D.DNAME 
    FROM (SELECT * FROM EMP WHERE DEPTNO = 30) E30, 
         (SELECT * FROM DEPT) D
    WHERE E30.DEPTNO = D.DEPTNO;
--인라인뷰에 사용하는 SQL 문이 길어진다면 WITH 절 사용하면 됨
--가독성을 높이기 위한 목적
--WITH 절에서 미리 내용을 파악할 수 있음 => SELECT 문을 읽으면 도움이 됨
WITH 
    E30 AS (SELECT * FROM EMP WHERE DEPTNO = 30), 
    D AS (SELECT * FROM DEPT)
SELECT E30.EMPNO, E30.ENAME, D.DEPTNO, D.DNAME 
    FROM E30, D
    WHERE E30.DEPTNO = D.DEPTNO;
--SELECT 절 뒤에서 사용하는 서브쿼리 = 스칼라 서브쿼리 = 열 처럼 사용
SELECT DNAME FROM EMP A, DEPT WHERE A.DEPTNO = DEPT.DEPTNO;
SELECT GRADE FROM EMP A, SALGRADE WHERE A.SAL BETWEEN LOSAL AND HISAL;
SELECT EMPNO, ENAME, JOB, SAL,
       (SELECT GRADE FROM SALGRADE WHERE A.SAL BETWEEN LOSAL AND HISAL) AS GRADE,
       DEPTNO,
       (SELECT DNAME FROM DEPT WHERE A.DEPTNO = DEPT.DEPTNO) AS DNAME
       FROM EMP A;
--
--데이터 조작어 DML, Data Manipulation Language
--데이터 수정하는 SQL 문장
--TCL 을 함께 사용해야 함(신중하게) - 최종변경 / 취소
--데이터 정의어 DDL, Data Definition Language + 자동 COMMIT
--원본을 복사한 실습용 테이블 만들기
CREATE TABLE DEPT_COPY
    AS SELECT * FROM DEPT;
SELECT * FROM DEPT_COPY;
--테이블 삭제
DROP TABLE DEPT_COPY;
SELECT * FROM DEPT_COPY;
--삭제 후 다시 테이블 만들기
CREATE TABLE DEPT_COPY
    AS SELECT * FROM DEPT;
SELECT * FROM DEPT_COPY;
--데이터 추가 INSERT
--INSERT INTO 테이블 이름 (열이름) VALUES (값)
INSERT INTO DEPT_COPY (DEPTNO, DNAME, LOC) VALUES (50, 'DA', 'BUSAN');
SELECT * FROM DEPT_COPY;
ROLLBACK;
--전체 열에 추가하는 경우는 열 생략 가능
INSERT INTO DEPT_COPY VALUES (50, 'DA', 'BUSAN');
SELECT * FROM DEPT_COPY;
--데이터 타입 확인
DESC DEPT_COPY;
--INSERT 문의 오류 발생의 경우
--1) 열 개수와 값 개수의 불일치
SELECT * FROM DEPT_COPY;
--열 3개 값 2개 생긴 오류 = 3번째 값을 같이 넣어주시면 해결
INSERT INTO DEPT_COPY (DEPTNO, DNAME, LOC) VALUES (60, 'DS');
INSERT INTO DEPT_COPY (DEPTNO, DNAME, LOC) VALUES (60, 'DS', 'SEOUL');
SELECT * FROM DEPT_COPY;
ROLLBACK;
SELECT * FROM DEPT_COPY;
INSERT INTO DEPT_COPY (DEPTNO, DNAME) VALUES (60, 'DS');
SELECT * FROM DEPT_COPY;
--2) 데이터 타입의 불일치
--숫자를 넣어야 하는 열에 문자를 넣었기 때문에 발생한 오류
INSERT INTO DEPT_COPY (DEPTNO, DNAME, LOC) VALUES ('70번', 'DE', 'SUWON');
INSERT INTO DEPT_COPY (DEPTNO, DNAME, LOC) VALUES (70, 'DE', 'SUWON');
SELECT * FROM DEPT_COPY;
--3) 데이터 입력 범위 벗어남
--2자리 숫자에 3자리 숫자를 넣어서 발생한 오류
INSERT INTO DEPT_COPY (DEPTNO, DNAME, LOC) VALUES (100, 'DD', 'INCHEON');
INSERT INTO DEPT_COPY (DEPTNO, DNAME, LOC) VALUES (80, 'DD', 'INCHEON');
SELECT * FROM DEPT_COPY;
--NULL 데이터 추가
SELECT * FROM DEPT_COPY;
ROLLBACK;
--명시적 입력
INSERT INTO DEPT_COPY (DEPTNO, DNAME, LOC) VALUES (50, 'DA', NULL);
SELECT * FROM DEPT_COPY;
--암시적 입력
INSERT INTO DEPT_COPY (DEPTNO, DNAME) VALUES (60, 'DS');
SELECT * FROM DEPT_COPY;
--BLANK 데이터 추가
INSERT INTO DEPT_COPY (DEPTNO, DNAME, LOC) VALUES (70, 'DE', '');
SELECT * FROM DEPT_COPY;
--개발자와 협력할 때는 비어있는 값이라는 의미를 확실히 전달하기 위해서는 NULL 용어 사용 권장
--날짜 데이터 INSERT
--실습 테이블 - EMP 테이블이 가지고 있는 구조만 복사 = 열만 복사 = 행은 복사하지 않음
CREATE TABLE EMP_COPY
    AS SELECT * FROM EMP WHERE 1 != 1;
SELECT * FROM EMP_COPY;
--팀장 2명 추가
INSERT INTO EMP_COPY (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO) 
    VALUES (5555, '장원영', 'MANAGER', 7839, '2023/05/22', 4000, 0, 10);
SELECT * FROM EMP_COPY;
INSERT INTO EMP_COPY (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO) 
    VALUES (7777, '차은우', 'MANAGER', 7839, '2023-05-22', 4000, 0, 10);
SELECT * FROM EMP_COPY;
--날짜 형식을 다르게 = 일/월/연
INSERT INTO EMP_COPY (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO) 
    VALUES (8888, '김민종', 'MANAGER', 7839, '22/05/2023', 4000, 0, 10);
SELECT * FROM EMP_COPY;
--에러 수정 = TO_DATE 함수로 일/월/연 날짜 형식을 알려줘야 함
INSERT INTO EMP_COPY (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO) 
    VALUES (8888, '김민종', 'MANAGER', 7839, TO_DATE('22/05/2023', 'DD/MM/YYYY'), 4000, 0, 10);
SELECT * FROM EMP_COPY;
--현재 날짜로 입력
INSERT INTO EMP_COPY (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO) 
    VALUES (9999, '배성욱', 'ANALYST', 5555, SYSDATE, 3000, NULL, 10);
SELECT * FROM EMP_COPY;
--서브쿼리로 추가
SELECT * FROM EMP_COPY;
SELECT A.EMPNO, A.ENAME, A.JOB, A.MGR, A.HIREDATE, A.SAL, A.COMM, A.DEPTNO 
    FROM EMP A, SALGRADE B 
    WHERE A.SAL BETWEEN B.LOSAL AND B.HISAL
      AND B.GRADE = 2;
INSERT INTO EMP_COPY (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
    SELECT A.EMPNO, A.ENAME, A.JOB, A.MGR, A.HIREDATE, A.SAL, A.COMM, A.DEPTNO 
    FROM EMP A, SALGRADE B 
    WHERE A.SAL BETWEEN B.LOSAL AND B.HISAL
      AND B.GRADE = 2;
SELECT * FROM EMP_COPY;
--데이터 변경 UPDATE
SELECT * FROM DEPT_COPY;
DROP TABLE DEPT_COPY;
CREATE TABLE DEPT_COPY
    AS SELECT * FROM DEPT;
SELECT * FROM DEPT_COPY;
--전체 = 일괄적으로 변경
UPDATE DEPT_COPY
    SET LOC = 'JEJU';
SELECT * FROM DEPT_COPY;
--취소
ROLLBACK;
SELECT * FROM DEPT_COPY;
--30번 부서 이름과 위치 변경
SELECT * FROM DEPT_COPY WHERE DEPTNO = 30;
SELECT DNAME, LOC FROM DEPT_COPY WHERE DEPTNO = 30;
UPDATE DEPT_COPY
    SET DNAME = 'DA',
        LOC = 'SEOUL'
    WHERE DEPTNO = 30;
SELECT * FROM DEPT_COPY;
SELECT * FROM DEPT_COPY WHERE DEPTNO = 30;
--수당 변경
SELECT * FROM EMP_COPY WHERE EMPNO = 9999;
UPDATE EMP_COPY
    SET COMM = 1000
    WHERE EMPNO = 9999;
SELECT * FROM EMP_COPY WHERE EMPNO = 9999;
--서브쿼리 이용하여 변경
SELECT * FROM DEPT_COPY WHERE DEPTNO = 30;
SELECT DNAME, LOC FROM DEPT WHERE DEPTNO = 30;
--DA SEOUL => SALES	CHICAGO 변경
UPDATE DEPT_COPY
    SET (DNAME, LOC) = (SELECT DNAME, LOC FROM DEPT WHERE DEPTNO = 30)
    WHERE DEPTNO = 30;
SELECT * FROM DEPT_COPY WHERE DEPTNO = 30;
--서브쿼리를 조건절에 사용
SELECT * FROM DEPT_COPY;
SELECT DEPTNO FROM DEPT_COPY WHERE DNAME = 'RESEARCH';
--DALLAS => BUSAN 변경
UPDATE DEPT_COPY
    SET LOC = 'BUSAN'
    WHERE DEPTNO = (SELECT DEPTNO FROM DEPT_COPY WHERE DNAME = 'RESEARCH');
SELECT * FROM DEPT_COPY;
--데이터 삭제 DELETE
SELECT * FROM EMP_COPY;
DROP TABLE EMP_COPY;
CREATE TABLE EMP_COPY
    AS SELECT * FROM EMP; 
SELECT * FROM EMP_COPY;
--데이터 일부 삭제
SELECT * FROM EMP_COPY WHERE JOB = 'CLERK';
DELETE EMP_COPY WHERE JOB = 'CLERK';
SELECT * FROM EMP_COPY WHERE JOB = 'CLERK';
--서브쿼리를 이용하여 데이터 일부 삭제
SELECT * FROM EMP_COPY;
SELECT * FROM SALGRADE;
SELECT A.EMPNO FROM EMP_COPY A, SALGRADE B 
    WHERE A.SAL BETWEEN B.LOSAL AND B.HISAL
      AND B.GRADE = 2;
SELECT * FROM EMP_COPY WHERE EMPNO IN (SELECT A.EMPNO FROM EMP_COPY A, SALGRADE B 
                                            WHERE A.SAL BETWEEN B.LOSAL AND B.HISAL
                                              AND B.GRADE = 2);
DELETE EMP_COPY WHERE EMPNO IN (SELECT A.EMPNO FROM EMP_COPY A, SALGRADE B 
                                            WHERE A.SAL BETWEEN B.LOSAL AND B.HISAL
                                              AND B.GRADE = 2);
SELECT * FROM EMP_COPY WHERE EMPNO IN (SELECT A.EMPNO FROM EMP_COPY A, SALGRADE B 
                                            WHERE A.SAL BETWEEN B.LOSAL AND B.HISAL
                                              AND B.GRADE = 2);
--테이블의 행 모두 삭제 = 데이터 전체 삭제
SELECT * FROM EMP_COPY;
DELETE EMP_COPY;
SELECT * FROM EMP_COPY;
--테이블 행 + 열 = 테이블 삭제
SELECT * FROM DEPT_COPY;
DROP TABLE DEPT_COPY;
SELECT * FROM DEPT_COPY;
--
--트랜잭션 제어 TCL, Transaction Control Language
--COMMIT: 최종 변경
--ROLLBACK: 취소
--실습 테이블 생성
CREATE TABLE DEPT_COPY
    AS SELECT * FROM DEPT;
SELECT * FROM DEPT_COPY;
--3 가지 DML 실행 후 취소
INSERT INTO DEPT_COPY VALUES (50, 'DA', 'SEOUL');
SELECT * FROM DEPT_COPY;
UPDATE DEPT_COPY
    SET LOC = 'SUWON'
    WHERE DEPTNO = 50;
SELECT * FROM DEPT_COPY;
DELETE DEPT_COPY WHERE DNAME = 'ACCOUNTING';
SELECT * FROM DEPT_COPY;
ROLLBACK;
SELECT * FROM DEPT_COPY;
--3 가지 DML 실행 후 최종 변경
SELECT * FROM DEPT_COPY;
INSERT INTO DEPT_COPY VALUES (50, 'DA', 'SEOUL');
SELECT * FROM DEPT_COPY;
UPDATE DEPT_COPY
    SET LOC = 'SUWON'
    WHERE DEPTNO = 50;
SELECT * FROM DEPT_COPY;
DELETE DEPT_COPY WHERE DNAME = 'ACCOUNTING';
SELECT * FROM DEPT_COPY;
COMMIT;
SELECT * FROM DEPT_COPY;
--읽기 일관성
--편집은 sqldeveloper 에서 하고 붙여넣기를 sqlplus 에 할 것
--sqldeveloper, sqlplus 각자 실행
SELECT * FROM DEPT_COPY;
--현재 양쪽에 보여지는 결과는 동일함
--sqldeveloper 에서 데이터 삭제
DELETE DEPT_COPY WHERE DEPTNO = 50;
--sqldeveloper, sqlplus 각자 실행
SELECT * FROM DEPT_COPY;
--sqldeveloper 에서 최종 변경
COMMIT;
--sqldeveloper, sqlplus 각자 실행
SELECT * FROM DEPT_COPY;
--수정 중인 데이터 접근을 막는 LOCK
--sqldeveloper, sqlplus 각자 실행
SELECT * FROM DEPT_COPY;
--sqldeveloper 에서 데이터 변경
--sqldeveloper, sqlplus 각자 실행
UPDATE DEPT_COPY 
    SET DNAME = 'DA'
    WHERE DEPTNO = 30;
--sqldeveloper 에서 최종 변경
COMMIT;
--
--데이터 정의어 DDL, Data Definition Language = 자동 COMMIT
--테이블 생성
--1) 열 이름과 자료형을 정의하면서 테이블 생성
SELECT * FROM EMP_COPY;
DROP TABLE EMP_COPY;
SELECT * FROM EMP_COPY;
--EMP_COPY 테이블 만들기
SELECT * FROM EMP;
CREATE TABLE EMP_COPY(
    EMPNO    NUMBER(4),
    ENAME    VARCHAR2(10),
    JOB      VARCHAR2(9),
    MGR      NUMBER(4),
    HIREDATE DATE,
    SAL      NUMBER(7,2),
    COMM     NUMBER(7,2),
    DEPTNO   NUMBER(2)
);
--2) 전체 행과 열을 복사하여 테이블 생성 = 열 구조 + 데이터
SELECT * FROM DEPT_COPY;
DROP TABLE DEPT_COPY;
CREATE TABLE DEPT_COPY
    AS SELECT * FROM DEPT;
SELECT * FROM DEPT_COPY;
--3) 일부 행과 열을 복사하여 테이블 생성 = 열 구조 + 일부 데이터
CREATE TABLE DEPT_COPY_30
    AS SELECT * FROM DEPT WHERE DEPTNO = 30;
SELECT * FROM DEPT_COPY_30;
--4) 열을 복사하여 테이블 생성 = 열 구조 = 행이 없음
SELECT A.EMPNO, A.ENAME, A.HIREDATE, A.SAL, B.DEPTNO, B.DNAME 
    FROM EMP A, DEPT B 
    WHERE A.DEPTNO = B.DEPTNO;
SELECT A.EMPNO, A.ENAME, A.HIREDATE, A.SAL, B.DEPTNO, B.DNAME 
    FROM EMP A, DEPT B 
    WHERE 1 != 1;
CREATE TABLE EMP_DEPT
    AS SELECT A.EMPNO, A.ENAME, A.HIREDATE, A.SAL, B.DEPTNO, B.DNAME 
    FROM EMP A, DEPT B 
    WHERE 1 != 1;
SELECT * FROM EMP_DEPT;
--테이블 변경
CREATE TABLE EMP_ALTER
    AS SELECT * FROM EMP;
SELECT * FROM EMP_ALTER;
--1) 열 추가
ALTER TABLE EMP_ALTER
    ADD PHONE VARCHAR2(15);
SELECT * FROM EMP_ALTER;
--2) 열 이름 변경 = RENAME 변경 전 이름 TO 변경 후 이름
ALTER TABLE EMP_ALTER
    RENAME COLUMN PHONE TO CP;
SELECT * FROM EMP_ALTER;
--3) 열의 데이터 타입 변경
DESC EMP_ALTER;
ALTER TABLE EMP_ALTER
    MODIFY EMPNO NUMBER(5);
DESC EMP_ALTER;
--4) 열 삭제
ALTER TABLE EMP_ALTER
    DROP COLUMN CP;
SELECT * FROM EMP_ALTER;
--테이블 이름 변경
RENAME EMP_ALTER TO EMP_ALTER_AFTER;
DESC EMP_ALTER;
SELECT * FROM EMP_ALTER;
DESC EMP_ALTER_AFTER;
SELECT * FROM EMP_ALTER_AFTER;
--데이터 삭제 = 테이블 비우기 = 열 구조는 남아 있고 행이 모두 삭제
TRUNCATE TABLE EMP_ALTER_AFTER;
SELECT * FROM EMP_ALTER_AFTER;
--테이블 삭제
DROP TABLE EMP_ALTER_AFTER;
SELECT * FROM EMP_ALTER_AFTER;
--
