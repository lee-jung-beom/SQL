-- SMITH가 속한 부서에 있는 직원들을 조회하기 -> 20번 부서에 속하는 직원들 조회하기
1. SMITH가 속한 부서 이름을 알아낸다
2. 1번에서 알아낸 부서번호로 해당 부서에 속하는 직원을 emp테이블에서 검색한다.

1.
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

2. : SUBQUERY를 이용 
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');


평균급여 보다 높은 급여를 받는 직원의 수를 조회하세요
SELECT AVG(sal) FROM emp;
SELECT COUNT(*) FROM emp WHERE sal >= 2073;

SELECT COUNT(*) 
FROM emp 
WHERE sal >= (SELECT AVG(sal) FROM emp);

평균급여보다 높은 급여를 받는 직원의 정보를 조회하세요
SELECT AVG(sal) FROM emp;

SELECT * 
FROM emp 
WHERE sal >= (SELECT AVG(sal) FROM emp);


SMITH와 WARD사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리를 다음과 같이 작성하세요
SELECT * 
FROM emp;
WHERE ename IN('SMITH', 'WARD');

SELECT * 
FROM emp 
WHERE deptno IN(SELECT deptno 
FROM emp
WHERE ename IN('SMITH', 'WARD'));

MULTI ROW 연산자
IN : = + OR
비교 연산자 ANY
비교 연산자 ALL

SELECT * 
FROM emp;

SELECT MAX(sal)
FROM emp;

-- 직원의 급여가 800보다 작고 1250보다 작은 직원 조회

SELECT ename, sal FROM emp e WHERE ename IN('SMITH', 'WARD');

SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr 
                    FROM emp);
                    
SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr, 9999) 
                    FROM emp);
                    
SELECT job, NVL(comm, 123)
FROM emp;

SELECT * 
FROM emp
WHERE job IN('CLERK'); 


PAIR WISE : 순서쌍

SELECT * FROM emp
WHERE mgr IN (SELECT mgr FROM emp WHERE empno IN(7499, 7782))
AND deptno IN(SELECT deptno FROM emp WHERE empno IN(7499, 7782));

SELECT ename, mgr, deptno FROM emp WHERE empno IN(7499, 7782);

요구사항: ALLEN 또는 CLARK의 소속 부서번호와 같으면서 상사도 같은 직원들을 조회
SELECT * FROM emp WHERE (mgr, deptno) IN(SELECT mgr, deptno FROM emp WHERE ename IN('SMITH', 'CLARK'));


스칼라 서브쿼리: SELECT 절에 사용된 쿼리, 하나의 행, 하나의 컬럼을 반환하는 서브쿼리

emp테이블에는 해당 직원이 속한 부서번호는 관리하지만 해당 부서명 정보는 dept 테이블에만 있다
해딩 직원이 속한 부서 이름을 알고 싶으면 dept 테이블과 조인을 해야한다.

상호연관 서브쿼리는 항상 메인쿼리가 먼저 실행된다
비상호연관 서브쿼리는 메인쿼리가 먼저 실행될 수도 있고, 서브쿼리가 먼저 실행 될 수도 있다. => 성능측면에서 유리한 쪽으로 오라클이 선택

인라인 뷰 : SELECT QUERY
.inline : 해당위치에 직접 기술함
 inline view : 해당위치에 직접 기술한 view
view : QUERY (O) ==> view table (X)

SELECT*
FROM(SELECT deptno, ROUND(AVG(sal), 2) avg_sal 
FROM emp
GROUP BY deptno;


아래 쿼리는 전체 직원의 급여 평균보다 높은 급여를 받는 직원을 조회하는 쿼리
SELECT empno, ename, sal, deptno
FROM emp e
WHERE e.sal > (SELECT AVG(sal)
                FROM emp a
                WHERE a.deptno = e.deptno);
직원이 속한 부서의 급여 평균보다 높은 급여를 받는 직원을 조회
SELECT empno, ename, sal, deptno
FROM emp e
WHERE e.sal > (SELECT AVG(sal)
                FROM emp a
                WHERE a.deptno = e.deptno);


SELECT empno, ename, sal, deptno FROM emp;

10번 부서의 급여 평균 (2916)
SELECT AVG(sal)
FROM emp
WHERE deptno = 10;

SELECT * FROM dept;


INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
commit;

SELECT * FROM emp;


dept테이블에는 신규 등록된 99번 부서에 속한 사람은 없음
직원이 속하지 않은 부서를 조회하는 쿼리를 작성해보세요.
SELECT *
FROM dept
WHERE deptno NOT IN(SELECT deptno
                    FROM emp);
                    
SELECT * FROM cycle;            

--실습문제5
cycle, product 테이블을 이용하여 cid=1인 고객이 애응하지 않는 제품을 조회하는 쿼리를 작성하세요
SELECT p.pid, p.pnm
FROM cycle 
WHERE cid NOT IN(SELECT pid 
                    FROM product p);

