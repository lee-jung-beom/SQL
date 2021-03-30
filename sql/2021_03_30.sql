https://myjamong.tistory.com/172    
FROM -> [START WITH] -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY

SELECT
FROM 
WHERE
START WITH
CONNECT BY
GROUP BY
ORDER BY

가지치기 : Pruning branch

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename AS ename, mgr, deptno, job
FROM emp
WHERE job != 'ANALYST'
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr;


계층 쿼리와 관련된 특수 함수
1. CONNECT_BY_ROOT(컬럼) : 최상위 노드의 해당 컬럼 값
2. SYS_CONNECT_BY_PATH(컬럼, '구분자문자열') : 최상위 행부터 현재 행까지의 해당 컬럼의 값을 구분자로 연결한 문자열
3. CONNECT_BY_ISLEAF : CHILD가 없는 leaf mode 여부 0 -false (no leaf node)/ 1 -true(leaf mode)(오라클에는 boolean이 없기 때문에) 

SELECT LPAD(' ', (LEVEL-1)*4) || ename AS ename, CONNECT_BY_ROOT(ename) root_ename
        , LTRIM(SYS_CONNECT_BY_PATH(ename, '-'), '-') path_ename
        --, INSTR('TEST', 'T')
        --, INSTR('TEST', 'T', 2)
        , CONNECT_BY_ISLEAF isleaf
FROM emp
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr;


SELECT *
FROM
(SELECT gn, CONNECT_BY_ROOT(seq) root_seq, 
seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title AS title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq)
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY root_seq DESC, seq ASC;


SELECT gn, 
seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title AS title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY gn DESC, seq ASC;


SELECT *
FROM 
(SELECT ROWNUM rn, a.*
FROM 
(SELECT gn, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title AS title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY gn DESC, seq ASC) a)
WHERE rn BETWEEN 6 AND 10;


--START WITH와 CONNECT BY는 오라클에서만 제공하는 것(다른 DBMS에선 다른 방법을 사용해야 한다(더 복잡))
--siblings : 정렬을 통해 계층 구조를 그대로 유지해주는 것

시작(ROOT)글은 작성 순서의 역순으로 
답글은 작성 순서대로 정렬

DESC board_test;


시작글부터 관련 답글까지 그룹번호를 부여하기 위해 새로운 컬럼 추가
ALTER TABLE board_test ADD (gn NUMBER);

DESC board_test;

UPDATE board_test SET gn =1
WHERE seq IN(1, 9);

UPDATE board_test SET gn =2
WHERE seq IN(2, 3);

UPDATE board_test SET gn =4
WHERE seq NOT IN(1, 2, 3, 4);
COMMIT;


SELECT a.MAX(sal)
FROM ((SELECT ename, sal, deptno FROM emp WHERE deptno = 10) a)
WHERE deptno = 10;

SELECT ename, MAX(sal)
FROM emp
WHERE deptno = 10;

SELECT *
FROM emp
WHERE deptno = 10
    AND sal = (SELECT MAX(sal) FROM emp WHERE deptno = 10);


분석함수(window 함수)
    SQL에서 행간 연산을 지원하는 함수
    
    해당 행의 범위를 넘어서 다른 행과 연산이 가능
    . SQL의 약점 보완
    . 이전 행의 특정 컬럼을 참조
    . 특정 범위의 행들의 컬럼의 합
    . 특정 범위의 행 중 특정 컬럼을 기준으로 순위, 행 번호 부여
    . SUM, COUNT, AVG, MAX, MIN
    . RANK, LEAD , LAC....
    

사원의 부서별 급여(sal)별 순위 구하기
SELECT ename, sal, deptno
FROM emp
GROUP BY deptno
HAVING deptno = 10
ORDER BY sal DESC;

SELECT *
FROM emp;

DESC emp;


분석함수 / window함수(해설)
. RANK() over(PARTITION BY deptno ORDER BY sal DESC) sal_rank
. PARTITION BY deptno : 같은 부서 코드를 갖는 row를 그룹으로 묶는다.
. ORDER BY sal : 그룹에서 sal로 row의 순서를 정한다.
. RANK() : 파티션 단위안에서 정렬 순서대로 순위를 부여한다.


SELECT ename, sal, deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS sal_RANK
FROM emp;

SELECT a.*, ROWNUM 
FROM 
(SELECT ename, sal, deptno FROM emp OREDER BY deptno, sal DESC ) a;

SELECT * 
FROM (SELECT ROWNUM rn FROM emp) a,

SELECT ROWNUM
FROM
(SELECT a.rn rank FROM 
(SELECT ROWNUM rn  FROM emp)a, (SELECT  deptno, COUNT(*) cnt 
FROM emp
GROUP BY deptno
ORDER BY deptno) b)
WHERE a.rn <= b.cnt
ORDER BY b.deptno, a.rn;


순위 관련된 함수 (중복값을 어떻게 처리하는가)
RANK : 동일 값에 대해 동일 순위 부여하고, 후순위는 동일값만 건너뛴다
        (ex)1등 2명이면 그 다음 순위는 3위
DENSE_RANK : 동일 값에 대해 동일 순위 부여하고, 후순위는 이어서 부여한다.
        (ex)1등이 2명이면 그 다음 순위는 2위
ROW_NUMBER : 중복 없이 행에 순차적인 번호를 부여(ROWNUM)

SELECT ename, sal ,deptno, 
    RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank,
    DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_dense_rank,
    ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_row_rank
FROM emp;


SELECT WINDOW_FUNCTION({인자}) OVER ({PARTITION BY 컬럼} {ORDER BY 컬럼})
FROM ....

PARTITION BY : 영역 설정
ORDER BY (ASC/DESC) : 영역 안에서의 순서 정하기


분석함수 / window함수(실습 ana1)
.사원의 전체 급여 순위를 rank, dense_rank, row_number를 이용하여 구하세요
.단 급여가 동일한 경우 사번이 빠른 사람이 높은 순위가 되도록 작성하세요.
SELECT ename, empno, sal, 
    RANK() OVER (ORDER BY sal DESC, empno) sal_rank,
    DENSE_RANK() OVER (ORDER BY sal DESC, empno) sal_rank,
    ROW_NUMBER() OVER (ORDER BY sal DESC, empno) sal_rank
FROM emp;


분석함수 / window함수(실습 no_ana2)
.기존의 배운 내용을 활용하여 모든 사원에 대해 사원번호, 사원이름, 해당 사원이 속한 부서의 사원 수를 조회하는 쿼리를 작성하세요.
SELECT empno, ename, (PARTITION BY COUNT(deptno)) AS deptno
FROM emp;


SELECT emp.empno, emp.ename, emp.deptno, b.cnt
FROM emp,
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) b
WHERE emp.deptno = b.deptno
ORDER BY emp.deptno;

SELECT empno, ename, deptno, 
        COUNT(*) OVER (PARTITION BY deptno) cnt 
FROM emp;




