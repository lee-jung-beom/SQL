SELECT * FROM emp;

SELECT * FROM dual

SELECT ename, empno, hiredate FROM emp WHERE hiredate BETWEEN TO_DATE('19810101', 'yyyymmdd') AND TO_DATE('19811231', 'yyyymmdd');

SELECT sal FROM emp WHERE sal BETWEEN 100 AND 3000;

SELECT TO_CHAR(hiredate, 'yyyymmdd')
FROM emp;

SELECT job, SUM(sal)
FROM Emp 
GROUP BY job
HAVING SUM(sal) > 8000;

SELECT * FROM emp;
SELECT * FROM dept;

SELECT * 
FROM emp e, dept d;

SELECT * FROM emp
WHERE deptno <> 20 AND job <> 'Manager';

SELECT ROWNUM, emp.* FROM emp;

SELECT ROWNUM empno, ename, job 
FROM (SELECT * 
        FROM emp
        ORDER BY ename)

--cid, pid, day, cnt
SELECT *
FROM cycle

--cid, cnm
SELECT *
FROM customer

--pid, pnm
SELECT *
FROM product

SELECT cycle.cid, cycle.pid, cycle.day, cycle.cnt, customer.cnm
FROM cycle, customer
WHERE cycle.cid = customer.cid;

SELECT * 
FROM emp;

SELECT ename AS "e", job AS B, CONCAT(ename, deptno) AS C, CONCAT(CONCAT(ename, deptno), mgr) AS O 
FROM emp;

SELECT ename, job, ename || deptno, (ename || deptno) || mgr
FROM emp;

-------------------------------------------------------------------
https://glutinousricecookie.tistory.com/52
Q1. emp 테이블에서 부서 인원이 4명 보다 많은 부서의 부서번호, 인원수, 급여의 합을 출력하라.
SELECT deptno 부서번호, COUNT(deptno) 인원수, SUM(sal) "총 급여"
FROM emp e
GROUP BY e.deptno
HAVING COUNT(e.deptno) > 4;

Q2. emp 테이블에서 가장 많은 사원이 속해 있는 부서의 부서번호와 사원 수를 출력하라.
SELECT deptno 부서번호, COUNT(deptno) "사원 수"
FROM emp e
GROUP BY e.deptno
    HAVING COUNT(deptno) = (SELECT MAX(COUNT(*)) 
                            FROM emp
                            GROUP BY deptno);

Q3. emp 테이블에서 가장 많은 사원을 갖는 mgr의 사원번호를 출력하라.
SELECT mgr empno
FROM emp  
GROUP BY mgr
HAVING COUNT(mgr) = (SELECT MAX(COUNT(*)) 
                    FROM emp 
                    GROUP BY mgr);

SELECT mgr empno
FROM emp
GROUP BY mgr
HAVING count(mgr) = (SELECT MAX(COUNT(*))
                    FROM emp
                    GROUP BY mgr);

Q4. emp 테이블에서 부서번호가 10인 부서의 사원수와 부서번호가 30인 부서의 사원 수를 각각 출력하라.
SELECT 
COUNT(DECODE(deptno, 10, 1)) CNT1,
COUNT(DECODE(deptno, 30, 1)) CNT2
FROM emp;



