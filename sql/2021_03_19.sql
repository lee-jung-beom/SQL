Function(group function 실습 grp3)
-emp테이블을 이용하여 다음을 구하시오.
grp2에서 작성한 쿼리를 활용하여 deptno 대신 부서명이 나올 수 있도록 수정하시오
SELECT DECODE(deptno,
FROM emp;

Functino(group function 실습 grp4)
-emp테이블을 이용하여 다음을 구하시오.
직원의 입사 년월별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요.
SELECT TO_CAHR(hiredate, 'YYYYMM'), hire_yyyymm, COUNT(*)cnt  
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

Function(group function 실습 grp5)
-emp테이블을 이용하여 다음을 구하시오
직원의 입사 년별로 몇명의 직
SELECT TO_CAHR(hiredate, 'YYYY'), hire_yyyy, COUNT(*)cnt  
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

Functino(group function 실습 grp6)
-회사에서 
SELECT COUNT(*)
FROM dept;

Function(group function 실습 grp7)
SELECT * FROM emp;
-직원이 속한 부서의 개수를 조회하는 쿼리를 작성하시오(emp테이블 사용)
SELECT COUNT(*)
FROM 
(SELECT deptno
FROM emp
GROUP BY deptno);


데이터 결합
JOIN
-ROBMS 중복을 최소화 하는 형태의 데이터베이스
-다른 테이블과 결합하여 데이터를 조회

데이터를 확장(결합)
1. 컬럼에 대한 확장 : JOIN
2. 행에 대한 확장 : 집합연산자(UNION ALL, UNION(합집합), MINUS(차집합), INTERSECT(교집합)

JOIN
-중복을 최소화 하는 RDBMS방식으로 설계한 경우
-emp테이블에는 부서코드만 존재, 부서정보를 담은 dept테이블 별도로 생성
-emp테이블과 dept테이블의 연결고리(deptno)로 조인하여 실제 부서명을 조회한다

JOIN
1. 표준 SQL => ANSI SQL
2. 비표준 SQL - DBMS를 만드는 회사에서 만든 고유의 sql문법

ANSI : SQL
ORACLE : SQL

ANSI- NATURAL JOIN
-조인하고자 하는 테이블의 연결컬럼 명(타입도 동일)이 동일한 경우(emp-deptno, dpet-deptno)
-연결 컬럼의 값이 동일할 때(=) 컬럼이 확장된다
SELECT emp.empno, emp.ename, deptno FROM emp NATURAL JOIN dept;
SELECT ename, dname FROM emp NATURAL JOIN dept;

ORACLE join : 
1. FROM 절에 조인할 테이블을 (,)콤마로 구분하여 나열
2. WHERE : 조인할 테이블의 연결조건을 기술
--오라클에서는 전부 밑의 코드와 같이 조인을 한다
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

7369 SMITH, 7902 FORD
SELECT e.empno, e.ename, m.empno, m.ename FROM emp e, emp m
WHERE e.mgr =  m.empno;

ANSI SQL : JOIN WITH USING 
조인 하려고 하는 테이블의 컬럼명과 타입이 같은 컬럼이 두개 이상인 상황에서 
두 컬럼을 모두 조인 조건을 참여시키지 않고, 개발자가 원하는 특정 컬럼으로만 연결을 시키고 싶을 때 사용

--자주 사용하는 방법은 아니다
SELECT * FROM emp JOIN dept USING(deptno); 
=> 오라클방식으로 
SELECT * FROM emp, dept WHERE emp.deptno = dept.deptno;

JOIN WITH ON : NATURAL, JOIN, JOIN WITH USING을 대체할 수 있는 보편적인 문법
조인 컬럼 조건을 개발자가 임의로 지정

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT * FROM dept;
--사원 번호, 사원 이름, 해당사원의 상사 사번, 해당사원의 상사 이름 : JOIN WITH ON을 이용하여 쿼리 작성
SELECT e.empno, e.ename, m.empno, m.ename FROM emp e JOIN emp m ON (e.mgr = m.empno) 
WHERE e.empno BETWEEN 7369 AND 7698;

SELECT e.empno, e.ename, m.empno, m.ename 
FROM emp e, emp m 
WHERE e.empno BETWEEN 7369 AND 7698
AND e.mgr = m.empno;

논리적인 조인 형태
1. SELF JOIN : 조인 테이블이 같은 경우
    - 계층구조 
2. NONEQUI-JOIN : 조인 조건이 =(equals)가 아닌 조인

//시험에 나옴
SELECT * 
FROM emp, dept
WHERE emp.deptno != dept.deptno;

SELECT * 
FROM salgrade;

--salgrade를 이용하여 직원의 급여 등급 구하기
--empno, ename, sal, 급여 등급
--ansi, oracle
SELECT emp.empno, emp.ename, emp.sal, salgrade.grade  
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.local AND salgrade.hisal;

데이터 결합(실습 join0)
emp, dept테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
SELECT empno, ename, deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

데이터 결합(실습 join0_1)
emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요(부서번호가 10, 30인 데이터만 조회)
SELECT empno, ename, emp.deptno, dname 
FROM emp, dept 
WHERE emp.deptno = dept.deptno
AND dept.deptno IN (10, 30);

emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요(급여가 2500 초과)
SELECT em
FROM emp, dept

emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
(급여 2500 초과, 사번이 7600보다 큰 직원)
SELECT  
FROM emp, dept
WHERE emp.empno > 7600 AND dept.

emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
(급여 2500 초과, 사번이 7600보다 크고, RESEARCH 부서에 속하는 직원)
SELECT *
FROM emp, dept 
WHERE emp.deptno = dept.deptno
AND emp.sal > 2500 
AND emp.empno > 7600 
AND dname = 'RESEARCH';

SELECT * FROM emp;