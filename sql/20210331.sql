분석함수 / window 함수 (실습 ana2)
window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 본인급여, 부서번호와 해당 사원이 속한 부서의 급여 평균을 조회하는 쿼리를 
작성하세요. (급여 평균은 소수점 둘째 자리까지 구한다.)

ana 2-4)
SELECT empno, ename, sal, deptno,
    ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal,
    MIN(sal) OVER (PARTITION BY deptno) min_sal,
    MAX(sal) OVER (PARTITION BY deptno) max_sal,
    SUM(sal) OVER (PARTITION BY deptno) sum_sal,    
    COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;
    --해당 부서의 가장 낮은 급여
    --해당 부서의 가장 높은 급여
    --COUNT(*) OVER (PARTITION BY deptno)cnt

분석함수/window
LAG(col)
LEAD(col)

자신보다 급여 순위가 한단계 낮은 사람의 급여를 5번째 컬럼으로 생성
SELECT empno, ename, hiredate, sal,
        LEAD(sal) OVER (ORDER BY sal DESC, hiredate)
FROM emp;

SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC;


분석함수/window함수(그룹내 행 순서 실습 ana5)
window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여, 전체 사원중 급여 순위가 1단계 높은 사람의 
급여를 조회하는 쿼리를 작성하세요.
SELECT empno, ename, hiredate, sal, 
    LAG(sal) OVER (ORDER BY sal DESC , hiredate) AS LAG_sal
FROM emp;

SELECT empno, ename, hiredate, sal, 
RANK () OVER (ORDER BY sal) AS rn
FROM emp;

SELECT empno, ename, hiredate, sal 
FROM emp
ORDER BY sal DESC, hiredate ASC;


SELECT a.empno, a.ename, a.hiredate, a.sal, b.sal
FROM 
(SELECT a.*, ROWNUM rn
FROM 
(SELECT empno, ename, hiredate, sal
FROM emp 
ORDER BY sal DESC, hiredate) a ) a,
(SELECT a.*, ROWNUM rn
FROM 
(SELECT empno, ename, hiredate,  sal
FROM emp
ORDER BY sal DESC, hiredate) a ) b
WHERE a.rn -1 = b.rn(+)
ORDER BY a.sal DESC, a.hiredate;



LAG, LEAD 함수의 두번째 인자 : 이전, 이후 몇번째 행을 가져올지 표기
SELECT empno, ename, hiredate, sal, 
        LEAD(sal, 2) OVER(ORDER BY sal DESC, hiredate ASC) AS LAG_SAL
FROM emp;

ana6
SELECT empno, ename, hiredate, job, sal, 
        LAG(sal) OVER(PARTITION BY job ORDER BY sal DESC, hiredate ASC) AS LAG_SAL
FROM emp;

no_ana3
SELECT empno, ename, sal, SUM(sal) OVER(ORDER BY sal ASC) AS C_SUM
FROM emp;

SELECT ROWNUM AS rn, empno, ename, sal
FROM emp
ORDER BY rn, 
(SELECT sal
FROM emp 
ORDER BY sal);

SELECT a.empno, a.ename, a.sal, SUM(b.sal)
FROM 
(SELECT  a.*, ROWNUM rn
FROM
(SELECT empno, ename, sal)
FROM emp
ORDER BY sal, empno) a ) a,
(SELECT a.*, ROWNUM rn
FROM 
SELECT 
ORDER BY sal, empno) a ) b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, a.empno;

1. ROWNUM
2. INLINE VIEW
3. NON_EQUI_JOIN
4. GROUP BY


분석함수() OVER( [PARTITION] (ORDER) [WINDOWING0])
WINDOWING : 윈도우함수의 대상이 되는 행을 지정
UNBOUNDED PRECEDING : 특정 행을 기준으로 모든 이전 행(LAG)
    n PRECEDING : 특정 행을 기준으로 N행 이전 행(LAG)
CURRENT ROW : 현재 행
UNBOUNDED FOLLOWING : 특정 행을 기준으로 모든 이후 행(LEAD)
    n FOLLOWING : 특정 행을 기준으로 n행 이후 행(LEAD)

SELECT empno, ename, sal, 
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_num, --하단 방법 보다는 이렇게 명확한 쿼리 작성 추천!
    SUM(sal) OVER (ORDER BY sal, empno ROWS UNBOUNDED PRECEDING) c_num
FROM emp
ORDER BY sal, empno;


SELECT empno, ename, sal, 
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_num --하단 방법 보다는 이렇게 명확한 쿼리 작성 추천!
FROM emp
ORDER BY sal, empno;
    
ana7
SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp; 


ROWS와 RANGE의 차이
SELECT empno, ename, sal, 
        SUM(sal) OVER (ORDER BY sal  ROWS UNBOUNDED PRECEDING) rows_c_sum,
        SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_c_sum,
        SUM(sal) OVER (ORDER BY sal) no_win_c_sum, --windowing을 적용하지 않으면 RANGE UNBOUNDED PRECEDING이 삽입된다. --ORDER BY 이후 윈도형 없을 경우 기본 설정 
        SUM(sal) OVER () no_ord_c_sum 
FROM emp
ORDER BY sal, empno; 

--책 소개 : SQL 전문가 가이드, 전문가로 가는 지름길 오라클 실습(https://blog.daum.net/why_i_am/45)(17장은 하지 않아도 됨), SQL 자격검정 시험문제, 불친절한 SQL 프로그래밍, 관계형 데이터 모델링(김기창 지음)
--, 새로 쓴 대요량 데이터 베이스 솔루션, 오라클 성능 고도화 원리와 해법











