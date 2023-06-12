--함수
--내장함수
--문자열 관련 함수
--대문자, 소문자, 첫글자만 대문자 나머지 소문자로 변경
SELECT ENAME, UPPER(ENAME), LOWER(ENAME), INITCAP(ENAME) FROM EMP;
--응용
SELECT * FROM EMP WHERE ENAME = 'SCOTT';
SELECT * FROM EMP WHERE UPPER(ENAME) = 'SCOTT';
SELECT * FROM EMP WHERE LOWER(ENAME) = 'scott';
SELECT * FROM EMP WHERE LOWER(ENAME) LIKE 's%';
--문자열 길이
SELECT ENAME, LENGTH(ENAME) FROM EMP;
SELECT ENAME, LENGTH(ENAME) FROM EMP WHERE LENGTH(ENAME) >= 5;
SELECT ENAME, LENGTH(ENAME) FROM EMP WHERE LENGTH(ENAME) < 5;
--문자열 바이트
--DUAL: 관리자 계정 SYS 소유 테이블, 함수 기능이나 연산 등 테스트 목적으로 사용하는 가상 테이블
SELECT LENGTH('HELLO'), LENGTHB('HELLO') FROM DUAL;
SELECT LENGTH('안녕'), LENGTHB('안녕') FROM DUAL;
--문자열 일부 추출
--첫 번째 숫자: 시작 위치, 두 번째 숫자: 글자 수 (생략하면 끝까지)
SELECT JOB, SUBSTR(JOB, 1, 2) FROM EMP; -- 2글자
SELECT JOB, SUBSTR(JOB, 3, 5) FROM EMP; -- 5글자
SELECT JOB, SUBSTR(JOB, 3) FROM EMP; -- 시작위치부터 끝까지
--응용, 글자수를 예측하기 어려울 때 LENGTH()
--LENGTH('CLERK') : 1 ~ 5
SELECT JOB, LENGTH(JOB) FROM EMP;
--처음부터 끝까지
---LENGTH('CLERK') : -5 ~ -1
SELECT JOB, SUBSTR(JOB, -LENGTH(JOB)) FROM EMP;
SELECT JOB, SUBSTR(JOB, -LENGTH(JOB), 2) FROM EMP;
--뒤에서 찾고 싶을 때
SELECT JOB, SUBSTR(JOB, LENGTH(JOB)) FROM EMP; -- 뒤에서부터 1글자
SELECT JOB, SUBSTR(JOB, LENGTH(JOB)-1) FROM EMP; -- 뒤에서부터 2글자
SELECT JOB, SUBSTR(JOB, LENGTH(JOB)-2) FROM EMP; -- 뒤에서부터 3글자
SELECT JOB, SUBSTR(JOB, LENGTH(JOB)-3) FROM EMP; -- 뒤에서부터 4글자
--특정 문자 위치
SELECT INSTR('HELLO, ORACLE!','L'), -- L 글자가 처음 나타나는 위치
       INSTR('HELLO, ORACLE!','L',5), -- 5번째부터 L 글자가 처음 나타나는 위치
       INSTR('HELLO, ORACLE!','L',2,2) -- 2번째부터 L 글자가 두번째 나타나는 위치
    FROM DUAL;
--다른 문자로 대체
SELECT '010-1234-5678',
       REPLACE('010-1234-5678', '-', ' '), -- 대시(-) 기호를 BLANK 로 대체
       REPLACE('010-1234-5678', '-', '*'), -- 대시(-) 기호를 * 로 대체
       REPLACE('010-1234-5678', '-') -- 대시(-) 기호를 ''로 대체 = 삭제
    FROM DUAL;
--빈칸을 특정 문자로 채우기
--LPAD: LEFT 에서 채움
--RPAD: RIGHT 에서 채움
SELECT 'Oracle',
       LPAD('Oracle', 10, '#'), -- 10자리, Oracle 글자를 오른쪽부터 넣고, 남은자리를 왼쪽에서 # 채움
       RPAD('Oracle', 10, '*'), -- 10자리, Oracle 글자를 왼쪽부터 넣고, 남은자리를 오른쪽에서 # 채움
       LPAD('Oracle', 10), -- 10자리, Oracle 글자를 오른쪽부터 넣고, 남은자리를 왼쪽에서 BLANK 채움
       RPAD('Oracle', 10) -- 10자리, Oracle 글자를 왼쪽부터 넣고, 남은자리를 오른쪽에서 BLANK 채움
    FROM DUAL;
--문자열 합치기 CONCAT
SELECT EMPNO, ENAME FROM EMP WHERE ENAME = 'SCOTT';
SELECT CONCAT(EMPNO, ENAME) FROM EMP WHERE ENAME = 'SCOTT';
SELECT CONCAT(':',ENAME), CONCAT(EMPNO, CONCAT(':',ENAME)) FROM EMP WHERE ENAME = 'SCOTT';
--|| 로 변환
SELECT EMPNO || ENAME FROM EMP WHERE ENAME = 'SCOTT';
SELECT ':' || ENAME, EMPNO || ':' || ENAME FROM EMP WHERE ENAME = 'SCOTT';
--특정 문자를 지우는 함수
--TRIM = 앞뒤 = TRIM BOTH FROM
--LTRIM = 앞 = 왼쪽 = TRIM LEADING FROM
--RTRIM = 뒤 = 오른쪽 = TRIM TRAILING FROM
--어떤 문자를 지울지 정하지 않으면 공백 제거
SELECT '['||' _ _Oracle_ _ '||']',
       '['||TRIM(' _ _Oracle_ _ ')||']', -- = TRIM => [_ _Oracle_ _]
       '['||TRIM(BOTH FROM ' _ _Oracle_ _ ')||']', -- = TRIM => [_ _Oracle_ _]
       '['||TRIM(LEADING FROM ' _ _Oracle_ _ ')||']', -- = LTRIM => [_ _Oracle_ _ ]
       '['||TRIM(TRAILING FROM ' _ _Oracle_ _ ')||']' -- = RTRIM => [ _ _Oracle_ _]
    FROM DUAL;
--TRIM, LTRIM, RTRIM 함수로 바꿔서 그대로 재현
SELECT '['||' _ _Oracle_ _ '||']',
       '['||TRIM(' _ _Oracle_ _ ')||']', -- = TRIM => [_ _Oracle_ _]
       '['||LTRIM(' _ _Oracle_ _ ')||']', -- = LTRIM => [_ _Oracle_ _ ]
       '['||RTRIM(' _ _Oracle_ _ ')||']' -- = RTRIM => [ _ _Oracle_ _]
    FROM DUAL;
--지우고 싶은 문자 지정해서 사용
SELECT '['||'_ _Oracle_ _'||']',
       '['||TRIM('_ _Oracle_ _')||']', -- = TRIM => [_ _Oracle_ _]
       '['||TRIM(BOTH '_' FROM '_ _Oracle_ _')||']', -- = TRIM => [ _Oracle_ ]
       '['||TRIM(LEADING '_' FROM '_ _Oracle_ _')||']', -- = LTRIM => [ _Oracle_ _ ]
       '['||TRIM(TRAILING '_' FROM '_ _Oracle_ _')||']' -- = RTRIM => [ _ _Oracle_ ]
    FROM DUAL;
--TRIM, LTRIM, RTRIM 함수로 바꿔서 그대로 재현
SELECT '['||'_ _Oracle_ _'||']',
       '['||TRIM('_ _Oracle_ _')||']', -- = TRIM => [_ _Oracle_ _]
       '['||LTRIM('_ _Oracle_ _', '_')||']', -- = LTRIM => [ _Oracle_ _ ]
       '['||RTRIM('_ _Oracle_ _', '_')||']' -- = RTRIM => [ _ _Oracle_ ]
    FROM DUAL;
--
--숫자함수
--반올림, 소수점 이하에서 표현할 자리수
SELECT ROUND(1234.5678),
       ROUND(1234.5678, 0),
       ROUND(1234.5678, 1),
       ROUND(1234.5678, 2),
       ROUND(1234.5678, -1),
       ROUND(1234.5678, -2)
    FROM DUAL;
--버리기
SELECT TRUNC(1234.5678),
       TRUNC(1234.5678, 0),
       TRUNC(1234.5678, 1),
       TRUNC(1234.5678, 2),
       TRUNC(1234.5678, -1),
       TRUNC(1234.5678, -2)
    FROM DUAL;
--정수 반환 함수
--CEIL = 천장 = 높은 정수값, 3 < 3.14 < 4
--FLOOR = 바닥 = 낮은 정수값, 3 < 3.14 < 4
--CEIL = 천장 = 높은 정수값, -4 < -3.14 < -3
--FLOOR = 바닥 = 낮은 정수값, -4 < -3.14 < -3
SELECT CEIL(3.14),
       FLOOR(3.14),
       CEIL(-3.14),
       FLOOR(-3.14)
    FROM DUAL;
--나머지
SELECT MOD(15, 6), --15/6 = 몫 2 나머지 3
       MOD(10, 2), --10/2 = 몫 5 나머지 0
       MOD(11, 2) --11/2 = 몫 5 나머지 1
    FROM DUAL;
--날짜함수
--현재 날짜
SELECT SYSDATE FROM DUAL;
SELECT SYSDATE - 1 FROM DUAL;
SELECT SYSDATE + 1 FROM DUAL;
SELECT SYSDATE + 100 FROM DUAL;
--특정 개월 후의 날짜
SELECT SYSDATE, ADD_MONTHS(SYSDATE, 3) FROM DUAL;
SELECT SYSDATE, ADD_MONTHS(SYSDATE, 120) FROM DUAL;
--입사 10주년
SELECT ENAME, HIREDATE, ADD_MONTHS(HIREDATE, 120) FROM EMP;
--과거 날짜 작은 값
--미래날짜 큰 값
--내일은 오늘보다 큰 값
--입사 41주년 미만 = 입사일 41주년 > 현재날짜 = 미래날짜 > 현재날짜
SELECT ENAME, HIREDATE, ADD_MONTHS(HIREDATE, 492), SYSDATE 
    FROM EMP 
   WHERE ADD_MONTHS(HIREDATE, 492) > SYSDATE;
--입사 41주년 초과 = 입사일 41주년 < 현재날짜 = 과거날짜 < 현재날짜
SELECT ENAME, HIREDATE, ADD_MONTHS(HIREDATE, 492), SYSDATE 
    FROM EMP 
   WHERE ADD_MONTHS(HIREDATE, 492) < SYSDATE;
--개월수 차이
SELECT EMPNO, ENAME, HIREDATE, SYSDATE,
       MONTHS_BETWEEN(HIREDATE, SYSDATE), --과거날짜 - 현재날짜 = 작은값 - 큰값 = 음수(우리가 원하는 결과 아님)
       MONTHS_BETWEEN(SYSDATE, HIREDATE), --현재날짜 - 과거날짜 = 큰값 - 작은값 = 양수(우리가 원하는 결과)
       TRUNC(MONTHS_BETWEEN(SYSDATE, HIREDATE)) -- 소수점 첫째자리 이하 버림 = 정수 형태
    FROM EMP;
--돌아오는 요일의 날짜
--해당 월의 마지막 날짜
SELECT SYSDATE, NEXT_DAY(SYSDATE, '수요일'), LAST_DAY(SYSDATE) FROM DUAL;
--날짜 반올림 = 중앙값을 찾아라
SELECT SYSDATE,
       ROUND(SYSDATE, 'CC'), --세기(100년)의 중앙값 51년 이상 반올림 2001
       ROUND(SYSDATE, 'YYYY'), --연도(1년)의 중앙값 7월 1일부터 반올림 23-01-01
       ROUND(SYSDATE, 'Q'), --분기(3개월)의 중앙값은 중앙에 있는 달의 16일부터 23-07-01
       ROUND(SYSDATE, 'DDD'), --일(하루)의 중앙값은 12시부터 23-05-20
       ROUND(SYSDATE, 'HH') --시간(60분)의 중앙값은 31분부터 23-05-19
    FROM DUAL;
--날짜 버리기
SELECT SYSDATE,
       TRUNC(SYSDATE, 'CC'),
       TRUNC(SYSDATE, 'YYYY'),
       TRUNC(SYSDATE, 'Q'),
       TRUNC(SYSDATE, 'DDD'),
       TRUNC(SYSDATE, 'HH')
    FROM DUAL;
--형 변환 함수
--암시적 형 변환 = 문자 => 숫자로 자동으로 바꿔줌
SELECT EMPNO, EMPNO + '1000' FROM EMP;
--1,000 는 문자 = 숫자 변환 불가 = 에러 발생
SELECT EMPNO, EMPNO + '1,000' FROM EMP;
--명시적 형 변환
--문자 형 변환
--날짜를 문자로 변환
SELECT SYSDATE FROM EMP;
--날짜 시간 포맷 입력해야 함
--연월일은 / 로 연결
--시분초는 : 으로 연결
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') FROM EMP;
--월 일 요일
SELECT SYSDATE,
       TO_CHAR(SYSDATE, 'MM'), --숫자 월
       TO_CHAR(SYSDATE, 'MON'), --이름 월, 약자
       TO_CHAR(SYSDATE, 'MONTH'), --이름 월, FULL NAME
       TO_CHAR(SYSDATE, 'DD'), -- 숫자 일
       TO_CHAR(SYSDATE, 'DY'), -- 이름 요일, 약자
       TO_CHAR(SYSDATE, 'DAY') -- 이름 요일, FULL NAME
    FROM DUAL;
--
SELECT SYSDATE,
       TO_CHAR(SYSDATE, 'MM'),
       TO_CHAR(SYSDATE, 'MON', 'NLS_DATE_LANGUAGE = KOREAN'),
       TO_CHAR(SYSDATE, 'MON', 'NLS_DATE_LANGUAGE = JAPANESE'),
       TO_CHAR(SYSDATE, 'MON', 'NLS_DATE_LANGUAGE = ENGLISH'),
       TO_CHAR(SYSDATE, 'MONTH', 'NLS_DATE_LANGUAGE = KOREAN'),
       TO_CHAR(SYSDATE, 'MONTH', 'NLS_DATE_LANGUAGE = JAPANESE'),
       TO_CHAR(SYSDATE, 'MONTH', 'NLS_DATE_LANGUAGE = ENGLISH')
    FROM DUAL;
SELECT SYSDATE,
       TO_CHAR(SYSDATE, 'DD'),
       TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = KOREAN'),
       TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = JAPANESE'),
       TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = ENGLISH'),
       TO_CHAR(SYSDATE, 'DAY', 'NLS_DATE_LANGUAGE = KOREAN'),
       TO_CHAR(SYSDATE, 'DAY', 'NLS_DATE_LANGUAGE = JAPANESE'),
       TO_CHAR(SYSDATE, 'DAY', 'NLS_DATE_LANGUAGE = ENGLISH')
    FROM DUAL;
--시분초
SELECT SYSDATE, TO_CHAR(SYSDATE, 'HH24:MI:SS'), --24시간
                TO_CHAR(SYSDATE, 'HH12:MI:SS'), --12시간
                TO_CHAR(SYSDATE, 'HH12:MI:SS PM'), --12시간, 오전/오후
                TO_CHAR(SYSDATE, 'HH:MI:SS PM') --12시간, 오전/오후
    FROM DUAL;
--숫자 형식
--숫자를 문자로 변환
SELECT SAL, --숫자 월급
       TO_CHAR(SAL, '$999,999'), --$ & 천단위 , 구분
       TO_CHAR(SAL, 'L999,999'), --LOCAL 통화량 = 한국 원 & 천단위 , 구분
       TO_CHAR(SAL, '999,999.00'), --소수점 두자리 & 숫자로만 표현
       --총 11자리 = 정수 9자리수 & 소수점 두자리, & 천단위 , 구분, 숫자 채우고 남은 자리를 0으로 채움
       TO_CHAR(SAL, '000,999,999.00'), 
       TO_CHAR(SAL, '000999999.99'), --총 11자리 = 정수 9자리수 & 소수점 두자리
       TO_CHAR(SAL, '999,999,00')
    FROM EMP;
--숫자 형 변환
--암시적 형 변환 = 문자를 숫자로 변환 = TO_NUMBER 함수 사용하지 않음
SELECT 1300 - '1500', '1300' + 1500 FROM DUAL;
--명시적 형 변환
SELECT 1300 - TO_NUMBER('1500'), TO_NUMBER('1300') + 1500 FROM DUAL;
--TO_NUMBER 함수를 사용하여 문제 해결
SELECT '1,300' - '1,500' FROM DUAL;
SELECT TO_NUMBER('1,300', '999,999') - TO_NUMBER('1,500', '999,999') FROM DUAL;
--날짜 형 변환
SELECT TO_DATE('2023-05-19', 'YYYY/MM/DD') FROM DUAL;
SELECT TO_DATE('20230519', 'YYYY/MM/DD') FROM DUAL;
SELECT TO_DATE('2023-05-19', 'YYYY-MM-DD') FROM DUAL;
SELECT TO_DATE('20230519', 'YYYY-MM-DD') FROM DUAL;
SELECT TO_DATE('2023/05/19', 'YYYY-MM-DD') FROM DUAL;
SELECT TO_DATE('2023/05/19', 'YYYY/MM/DD') FROM DUAL;
--사원 데이터에서 81년 7월 1일 이후에 입사한 사람
SELECT * FROM EMP WHERE HIREDATE > TO_DATE('1981-07-01', 'YYYY-MM-DD');
--사원 데이터에서 81년 7월 1일 이전에 입사한 사람
SELECT * FROM EMP WHERE HIREDATE < TO_DATE('1981-07-01', 'YYYY-MM-DD');
--RR: 1950~2049
SELECT TO_DATE('49/12/10', 'YY/MM/DD') AS Y1, --2049
       TO_DATE('49/12/10', 'RR/MM/DD') AS Y2, --2049
       TO_DATE('50/12/10', 'YY/MM/DD') AS Y3, --2050
       TO_DATE('50/12/10', 'RR/MM/DD') AS Y4, --1950
       TO_DATE('51/12/10', 'YY/MM/DD') AS Y5, --2051
       TO_DATE('51/12/10', 'RR/MM/DD') AS Y6 --1951
    FROM DUAL;
--널 처리 함수
--NVL 함수: 널값일 때 내가 원하는 값으로 변경, 나머지는 그대로
SELECT EMPNO, ENAME, SAL, COMM, SAL+COMM, NVL(COMM, 0), SAL+NVL(COMM, 0) FROM EMP;
--NVL2 함수
--첫번째 매개변수-널값이 아닐 때 내가 원하는 값으로 변경
--두번째 매개변수-널값일 때 내가 원하는 값으로 변경
SELECT EMPNO, ENAME, SAL, COMM, NVL2(COMM, 'O', 'X'), NVL2(COMM, SAL*12+COMM, SAL*12) FROM EMP;
--상황에 따라서 다른 데이터 반환
--DECODE: 같다는 조건만 가능
SELECT DISTINCT JOB FROM EMP;
SELECT EMPNO, ENAME, JOB, SAL,
       DECODE(JOB,
              'MANAGER', SAL*1.1,
              'SALESMAN', SAL*1.05,
              'ANALYST', SAL,
              SAL*1.03) AS UPSAL
    FROM EMP;
--CASE: 같다는 조건 말고도 가능
--앞의 DECODE 문을 CASE 문으로 재현
SELECT EMPNO, ENAME, JOB, SAL,
       CASE JOB
        WHEN 'MANAGER' THEN SAL*1.1
        WHEN 'SALESMAN' THEN SAL*1.05
        WHEN 'ANALYST' THEN SAL
        ELSE SAL*1.03
       END AS UPSAL
    FROM EMP;
--같다는 조건 말고도 사용
SELECT EMPNO, ENAME, COMM,
       CASE 
        WHEN COMM IS NULL THEN '해당 사항 없음'
        WHEN COMM = 0 THEN '수당 없음'
        WHEN COMM > 0 THEN '수당: ' || COMM
       END AS COMM_CMT
    FROM EMP;
--다중행 함수 = 결과가 하나 = 하나의 값으로 요약
SELECT SAL FROM EMP;
SELECT SUM(SAL) FROM EMP;
--한 번에 출력하려면 나오는 행의 개수가 같아야 함
SELECT ENAME, SUM(SAL) FROM EMP;
--NULL 값을 자동으로 제외하고 계산
SELECT SUM(COMM) FROM EMP;
--행의 개수가 같으므로 동시 출력이 가능
SELECT SUM(DISTINCT SAL), --중복 제거하여 합
       SUM(ALL SAL), --ALL 쓰지 않아도 결과 동일
       SUM(SAL) --ALL 쓰지 않아도 결과 동일
    FROM EMP;
--다음과 같이 사용하면 됨
SELECT SUM(SAL), SUM(COMM) FROM EMP;
--개수
SELECT COUNT(*) FROM EMP;
SELECT COUNT(*) FROM EMP WHERE DEPTNO = 30;
SELECT COUNT(DISTINCT SAL), --중복 제거하여 카운드
       COUNT(ALL SAL), --ALL 쓰지 않아도 결과 동일
       COUNT(SAL) --ALL 쓰지 않아도 결과 동일
    FROM EMP;
--NULL 값을 자동으로 제외하고 계산
SELECT COUNT(COMM) FROM EMP;
--위와 결과 동일함
SELECT COUNT(COMM) FROM EMP WHERE COMM IS NOT NULL;
--최대값
SELECT MAX(SAL) FROM EMP;
SELECT MAX(SAL) FROM EMP WHERE DEPTNO = 30;
--가장 최근에 (늦게) 입사한 입사일
SELECT MAX(HIREDATE) FROM EMP;
--최소값
SELECT MIN(SAL) FROM EMP;
SELECT MIN(SAL) FROM EMP WHERE DEPTNO = 30;
--가장 오래 전에 (일찍) 입사한 입사일
SELECT MIN(HIREDATE) FROM EMP;
--평균
SELECT AVG(SAL) FROM EMP;
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 30;
--NULL 값을 자동으로 제외하고 계산
SELECT AVG(COMM) FROM EMP;
SELECT AVG(COMM) FROM EMP WHERE DEPTNO = 30;
--
