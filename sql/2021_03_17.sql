WHERE 조건1 : 10건

WHERE 조건 
AND 조건2 : 10건을 넘을 수 없음

예시)
WHERE deptno = 10
AND sal > 500

SELECT ROWNUM empno, ename FROM emp ORDER BY sal;
-> 
SELECT ROWNUM a.*()

시험에 나오는 것
-- 트랜잭션
-- LIKE
-- 페이징

<오늘 수업내용 시작>
Function
--Single row function
단일 행을 기준으로 작업하고, 행당 하나의 결과를 반환
, 특정 컬럼의 문자열 길이: length(ename)
--Multi row function
어러 행을 기준으로 작업하고, 하나의 결과를 반환
, 그룹 함수
count, sum, avg

함수명을 보고
1. 파라미터가 어떤게 들어갈까?
2. 몇개의 파라미터가 들어갈까?
3. 반환되는 값은 무엇일까?

LOWER, UPPER, INITCAP
SELECT * | {컬럼 | expression}
SELECT ename, LOWER(ename), UPPER(ename), INITCAP('TEST'), SUBSTR(ename, 1, 3), SUBSTR(ename, 2), REPLACE ('M', 'SMITH', 'S') FROM emp;

문자열 조작
CONCAT : 인자가 2개다, 우리에게 결합되는 문자열은 1개이다
SUBSTR : 예를 들어 어는 문자열이 있으면 그 문자열의 일부를 빼오는 것이다 ex) SUBSTR(ename, 1, 3) 칼럼의 문자열의 1~3번째 문자들만 가져옴
LENGTH : 
INSTR :
LPAD|RPAD : 좌|우에 특정한 문자열을 집어 넣는 것
TRIM : 문자열의 좌우 끝부터 공백을 제거하는 것(문자열의 중간 공백은 제거하지 않는다)
REPLACE : 인자가 3개이다(대상 문자열, 원래 문자열, 바꾸고 싶은 문자열) ex) REPLACE ename('M', 'SMITH', 'S')

DUAL table
sys계정에 있는 테이블
누구나 사용 가능
DUMMY컬럼 하나만 존재하며 값은 'X'이며 데이터는 한 행만 존재

사용용도
데이터와 관련 없이
 - 함수 실행
 - 시퀀스 실행
merge문에서 
데이터를 복사할 때

SELECT LENGTH('TEST') FROM emp;
emp테이블에 등록된 직원들 중에 직원의 이름의 길이가 5글자를 초과하는 직원만 조회
SELECT * FROM emp WHERE LENGTH(ename) > 5;

SELECT * FROM emp WHERE LOWER(ename) = 'smith';

SELECT * FROM emp WHERE ename = UPPER('smith');

*참고회사 : 엔코아

ORACLE 문자열 함수
SELECT CONCAT('HEllo', 'WORLD') FROM dual;

SELECT 'HEllO' || 'WORLD', 
        CONCAT('HELLO', CONCAT(', ', 'WORLD')) CONCAT, 
        SUBSTR('HELLO, WORLD', 1, 5) SUBSTR,
        LENGTH('HELLO, WOLRD') LENGTH,
        INSTR('HELLO, WOLRD', 'O') INSTR,
        INSTR('HELLO, WORLD', 'O', 6) INSTR2,
        LPAD('HELLO, WORLD', 15, '*') LPAD,
        RPAD('HELLO, WORLD', 15, '-') RPAD,
        REPLACE('HELLO, WORLD', 'O', 'X') REPLACE
        --공백을 제거, 문자열의 앞과, 뒷부분에 있는 공백만
        TRIM('  HELLO, WORLD  ') TRIM,
        TRIM('D' FROM 'HELLO, WORLD') TRIM
FROM dual;

number
숫자조작
 ROUND : 반올림
 TRUNC : 내림
 MOD : 나눗셈의 나머지
 
피제수, 제수
SELECT MOD(10, 3)
FROM dual;

ROUND(105.54, 1) round1, --반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째 자리에서 반올림 : 105.5
ROUND(105.55, 1) round2, --반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째 자리에서 반올림 : 105.6
ROUND(105.55, 0) round3, --반올림 결과가 첫번째 자리(일의 자리)까지 나오도록 : 소수점 첫째 자리에서 반올림 : 106
ROUND(105.55, -1) round4 --반올림 결과가 두번째 자리(십의 자리)까지 나오도록 : 정수 첫째 자리에서 반올림 : 110
ROUND(105.55) round5
FROM dual;


SELECT 
ROUND(105.54, 1) trunc1, --절삭 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째 자리에서 절삭 : 105.5
ROUND(105.55, 1) trunc2, --절삭 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째 자리에서 절삭 : 105.6
ROUND(105.55, 0) trunc3, --절삭 결과가 첫번째 자리(일의 자리)까지 나오도록 : 소수점 첫째 자리에서 절삭 : 105
ROUND(105.55, -1) trunc4, --절삭 결과가 두번째 자리(십의 자리)까지 나오도록 : 정수 첫째 자리에서 절삭 : 100
ROUND(105.55) trunc5
FROM dual;

--ex : 7499, ALLEN, 1600, 1, 600
SELECT empno, enmae, sal, sal을 1000으로 나눴을 때의 몫, sal을 1000으로 나눴을 때의 나머지
FROM emp;

SELECT * FROM emp;
SELECT empno, ename, TRUNC(sal/1000), MOD(sal, 1000) FROM emp;


날짜 <==> 문자
서버의 현재 시간
SELECT SYSDATE FROM dual;

SELECT SYSDATE, SYSDATE + 1/24/60/60 FROM dual;

1. 2019년 12월 31일을 date형으로 표현
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDAY, 
        TO_DATE('2019/12/31', 'YYYY/MM/DD') -5 LASTDAY_BEFOERS,
        SYSDAE NOW,
        SYSDATE -3  NOW_BEFORES
FROM dual;
2. 2019년 12월 31일을 date형으로 표현하고 5일 이전 날짜
SELECT SYSDATE  FROM dual;
3. 현재 날짜
SELECT SYSDATE  FROM dual;
4. 현재 날짜에서 3일 전 값
SELECT SYSDATE  FROM dual;

SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDAY FROM dual;
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDAY FROM dual;

위 4개 컬럼을 생성하여 다음과 같이 조회하는 쿼리를 작성하세요.
SELECT SYSDATE  FROM dual;

SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD') FROM dual;

--과제 유튜브 Grit이라 검색하면 TED쇼 Grit작가

NLS : YYYY/MM/DD HH24:MI:SS

SELECT SYSDATE, TO_CHAR(SYSDATE, 'IW'), TO_DATE(SYSDATE, 'D') 
FROM dual;

date
FORMAT 
 -YYYY : 4자리 년도
 -MM : 2자리 월
 -DD : 2자리 일자
 -D : 주간 일자(1~7)
 -IW : 주차(1~53주)
 -HH, HH12 : 2자리 시간(12시간 표현)
 -HH24 : 2자리 시간(24시간 표현)
 -MI : 2자리 분
 -SS : 2자리 초
 
오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하시오.
년-월-일, 년-월-일, 시간(24)-분-초, 일-월-년
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH,
        TO_CHAR(SYSDATE, 'YYY-MM-DD HH24:MI:SS') DT_DASH_WITH_TIME,
        TO_CHAR(SYSDATE, 'DD-MM-YYYY') 
FROM dual;

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')
FROM dual;

TO_CHAR(날짜, 문자열,

날짜에서 배운 것
SYSDATE, TO_DATE, TO_CHAR