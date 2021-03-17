--입사 일자가 1982년 1월 1일 이후인 모든 직원 조회하는 SELECT 쿼리를 작성하시오.
SELECT * FROM emp WHERE hiredate >= TO_DATE('19820101', 'RRRRMMDD');

--"숫자 > 숫자" 비교도 가능하고, "날짜 > 날짜" 비교도 가능하다. (예시)2020-03-15 > 2021 - 03 -12
-- 년도를 표기 할 때 YYYY 또는 RRRR 4 자리로 표기하는 것을 추천(년도 표기의 확실성을 위해서)

SELECT * FROM emp;

SELECT * FROM emp WHERE sal > 1500 AND hiredate >= TO_DATE('19820101', 'RRRRMMDD');

WHERE절에서 사용 가능한 연산자
(이전까지 배운 것: 비교 연산자(<, >, =, !=))

BETWEEN AND는 삼항연산자이다

비교대상 BETWEEN 비교대상의 허용 시작값 AND 비교대상의 허용 종료값
ex : 부서번호가 10번에서 20번 사이의 속한 직원들만 조회
SELECT * FROM emp WHERE deptno BETWEEN 10 AND 20;

emp 테이블에서 급여(sal)가 1000보다 크거나 같고 2000보다 작거나 같은 직원들만 조회
SELECT * FROM emp WHERE sal >= 1000 AND sal <= 2000;
SELECT * FROM emp WHERE sal BETWEEN 1000 AND 2000;
SELECT * FROM emp WHERE sal BETWEEN 1000 AND 2000;

emp테이블에서 입사 일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전인 사원의 ename, hiredate 데이터를 조회하는 쿼리를 작성하시오.
단 연산자는 between을 사용한다
SELECT * FROM emp WHERE hiredate BETWEEN TO_DATE('19820101', 'YYYYMMDD') AND TO_DATE('19830101', 'YYYYMMDD');
SELECT * FROM emp WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD') AND hiredate <= TO_DATE('19830101', 'YYYYMMDD');

BETWEEN AND : 포함(이상, 이하)의 개념
초과, 미만의 개념을 적용하려면 비교연산자를 사용해야 한다

IN연산자
대상자 IN (대상자와 비교할 값1, 대상자와 비교할 값2, 대상자와 비교할 값3.....)
deptno IN(10, 20 ==> deptno값이 10이나 20번이면 TRUE이다)

SELECT * FROM emp WHERE deptno IN (10, 20);

SELECT * FROM emp WHERE deptno = 10 OR deptno = 20;

SELECT * FROM emp WHERE 10 IN (10, 20);

user테이블에서 userid가 brown, cony, sally인 데이터를 다음과 같이 조회 하시오(IN연산자 사용)
SELECT * FROM users WHERE userid IN ('brown', 'cony', 'sally');

SELECT * FROM users WHERE userid = 'brown' OR userid = 'cony';

SELECT userid AS 아이디, usernm AS 이름, alias AS 별명 FROM users WHERE userid = 'brown' OR userid = 'cony';

SELECT * FROM users;

LIKE연산자 : 문자열 매칭 조회
게시글 : 제목, 검색, 내용 검색 제목에 (맥북에어)가 들어가는 게시글만 조회

% : 0개 이상의 문자
_ : 1개의 문자

SELECT * FROM users WHERE userid LIKE 'c%';

userid가 c로 시작하면서 c 이후에 3개의 글자가 오는 사용자
SELECT * FROM users WHERE userid LIKE 'c___';

userid에 l이 들어가는 모든 사용자 조회
SELECT * FROM users WHERE userid LIKE '%l%';

member테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오
SELECT mem_id, mem_name FROM member WHERE mem_name LIKE'신%';
SELECT * FROM member;

member테이블에서 회원의 이름에 글자[이]가 들어가는 모든 사람의 mem_id, meme_name을 조회하는 쿼리를 작성하시오
SELECT mem_id, mem_name FROM member WHERE mem_name LIKE '%이%' AND mem_name LIKE '%이%';

IS(NULL 비교)
emp 테이블에서 comm 컬럼의 값이 NULL인 사람만 조회
SELECT * FROM emp WHERE comm IS NOT NULL;

emp테이블에서 매니저가 없는 직원만 조회
SELECT * FROM emp WHERE mgr IS NULL;

BETWEEN AND, IN, LIKE, IS

논리연산자 : AND, OR, NOT
AND : 두 가지 조건을 동시에 만족시키는지 확인할 때
    조건1 AND 조건2
OR : 두 가지 조건 중 하나라도 만족 시키는지 확인할 때 
    조건1 OR 조건2
NOT : 부정형 논리연산자, 특정 조건을 부정
    mgr IS NULL : mgr 컬럼의 값이 NULL인 사람만 조회
    mgr IS NOT NULL : mgr 컬럼의 값이 NULL이 아닌 사람만 조회

emp 테이블에서 mgr의 사번이 7698이면서 sal값이 1000보다 큰 직원만 조회;
(조거읜 순서는 결과와 무관하다)
SELECT * FROM emp WHERE mgr = 7698 AND sal > 1000;

AND조건이 많아지면 : 조회되는 데이터 건수는 감소
OR조건이 많아지면 : 조회되는 데이터 건수는 증가

NOT : 부정형 연산자, 다른 연산자와 결합하여 쓰인다 
    IS NOT, NOT IN, NOT LIKE
    
SELECT * FROM emp WHERE deptno NOT IN(10);
SELECT * FROM emp WHERE ename NOT LIKE 'S%';

NOT IN연산자 사용시 주의점
SELECT * FROM emp WHERE mgr IN (7698, 7839, NULL);
==> mgr = 7698 OR mgr = 7839 OR mgr = NULL

SELECT * FROM emp WHERE mgr NOT IN (7698, 7839, NULL);
==> mgr != 7698 AND mgr != 7839 AND mgr != NULL --개념적으로 중요한 부분 
    TRUE FALSE 의미가 없음 AND FALSE 

    
NOT IN 연산자 사용시 주의점 : 비교값 중에 NULL이 포함되면 데이터가 조회되지 않는다

논리연산(AND, OR 실습)
emp테이블에서 job이 SALESMAN이고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회 하세요.
SELECT * FROM emp WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

emp테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회 하세요(IN, NOT IN 연산자 사용금지)
SELECT * FROM emp WHERE deptno != 10 AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

emp테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회 하세요(IN, NOT IN 연산자 사용)
SELECT * FROM emp WHERE deptno NOT IN(10) AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

emp테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회 하세요(부서는 10, 20, 30만 있다고 가정하고 IN연산자를 사용)
SELECT * FROM emp WHERE deptno IN(10, 20, 30) AND deptno != 10 AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

emp테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회 하세요
SELECT * FROM emp WHERE job = 'SALESMAN' OR hiredate >= TO_DATE('19810601', 'YYYYMMDD');

where 12번 문제
emp테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회 하세요
SELECT * FROM emp WHERE job = 'SALESMAN' OR empno LIKE '78%';

--♠과제♠
where 13번 문제 : where 12번 문제를 LIKE연산자 사용하지 않고 풀기
SELECT * FROM emp WHERE job = 'SALESMAN' OR empno BETWEEN 7800 AND 7899 
OR empno BETWEEN 780 AND 789 
OR empno = 78;

SELECT * FROM emp;

