SELECT ename, job, ROWID
FROM emp
ORDER BY ename, job;

job, ename 컬럼으로 구성된 IDK_emp_03 인덱스 삭제

CREATE 객체타입 객체명
DROP 객체타입, 객체명;

DROP INDEX idx_emp_03;

CREATE INDEX idx_emp_04 ON emp(ename, job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT * 
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4077983371
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
   
SELECT ROWID, dept.*
FROM dept;


CREATE INDEX idx_dept_01 ON dept (deptno);

SELECT ename, dname, loc
FROM emp, dept 
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

응답성 : OLTP <- 우리가 오라클로 배우는 목적인 부분
퍼포먼스 : OLAP

인덱스 사용 시 단점(INDEX Access)
- 저장공간 부족

인덱스 사용 시 장점
- 소수의 데이터를 조회할 때 유리(웅답속도가 필요할 때)
    .INDEX를 사용하는 Input/output Single Block I/O
- 다량의 데이터를 인덱스로 접근할 경우 속도가 느리다
    
Table Access
 - 테이블의 모든 데이터를 읽고서 처리를 해야하는 경우 인덱스를 통해 모든 데이터를 테이블로 접근하는 경우보다 빠름
    - I/O 기준이 multi block

DDL(테이블에 인덱스가 많다면)
- 테이블의 빈공간을 찾아 데이터를 입력한다
- 인덱스의 구성 컬럼을 기준으로 정렬된 위치를 찾아  

<과제 : Index 실습 idx3>



달력 만들기
주어진 것 : 년월 6자리 문자열 ex- 202103
만들 것 : 해당 년월에 해당하는 달력(7칸 짜리 테이블)

SELECT TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'yyyymm')), 'DD')
FROM dual;


--(LEVEL은 1부터 시작)
SELECT DECODE(d, 1, iw + 1, iw),
       MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tues, MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) thurs, MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM
(SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'D') d,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'IW') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'yyyymm')), 'DD'))
GROUP BY DECODE(d, 1, iw + 1, iw)
ORDER BY DECODE(d, 1, iw + 1, iw);


계층쿼리 - 조직도, BOM(Bill of Material), 게시판(답변형 게시판)
        - 데이터의 상하 관계를 나타내는 쿼리
        
사용방법 : 1. 시작위치를 설정
          2. 행과 행의 연결조건을 기술
          
SELECT empno, ename, mgr
FROM emp
START WITH empno = 7839
CONNECT BY 내가 읽은 행의 사번과 = 앞으로 읽을 행의 mgr컬럼;
CONNECT BY PRIOR empno = mgr;
PRIOR - 이미 읽은 데이터

이미 읽은 데이터      앞으로 읽어야 할 데이터
KING의 사번 = mgr 컬럼의 값이 KING의 사번인 녀석
SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename, mgr, LEVEL
FROM emp
START WITH empno = 7839
CONNECT BY PRIOR empno = mgr;


SELECT LPAD('TEST', 1*10)
FROM dual;

계층쿼리 방향에 따른 분류
상향식 : 최하위 노드(leaf node)에서 자신의 부모를 방문하는 형태
하향식 : 최상위 노드(roof node)에서 모든 지식 노드를 방문하는 형태

상향식 쿼리
SMITH부터 시작하여 노드의 부모를 따라가는 계층형 쿼리 작성

SELECT empno, LAPD(' ', (LEVEL - 1)*4) || ename, mgr, LEVEL
FROM emp
START WITH empno = 7369
CONNECT BY PRIOR mgr = empno;

CONNECT BY SMITH의 mgr 컬럼값 = 내앞으로 읽을 행 empno
;