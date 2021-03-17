-- ant계정에 있는 prod 테이블의 모든 컬럼명을 조회하는 SELECT 쿼리(SQL) 작성

SELECT *
FROM prod;

-- ant계정에 있는 prod 테이블의 모든 prod_id, prod_name을 조회하는 SELECT 쿼리(SQL) 작성

SELECT prod_id, prod_name
FROM prod;

SELECT *
FROM lprod;

SELECT buyer_id, buyer_name

FROM buyer;

SELECT *
FROM cart;

SELECT mem_id, mem_pass, mem_name
FROM member;

SELECT *
FROM users;

DESC emp;

empno : number ;
SELECT empno "empno", empno + 10, 10, hiredate, hiredate + 10
FROM emp;

NULL: 아직 모르는 값
        0과 공백은 NULL과 다르다
        **** NULL을 포함한 연산은 결과가 항상 NULL ****
        => NULL 값을 다른 값으로 치환해주는 함수(앞으로 배울 것)
        
SELECT ename, sal, comm, sal+comm, comm + 100
FROM emp;

(sel2) alias를 사용
SELECT prod_id AS "id", prod_name AS name
FROM prod;

SELECT lprod_gu AS gu, lprod_nm AS nm
FROM lprod;

SELECT buyer_id AS 바이어아이디, buyer_name AS 이름
FROM buyer;

literal: 값 자체
literal: 표기법: 값을 표현하는 방법

SELECT empno, 10, 'Hello World'
FROM emp;

문자열 연산
java: String str = "Hello" + ", World";

SELECT empno + 10 AS empno,ename || ', Hello' || ', World' AS ename, 
    CONCAT (ename, 'Hello', ', World') --결합할 두 개의 문자열을 입력받아 결합하고 하나의 결함된 문자열을 반환 해준다
FROM emp;

DESC emp;

아이디: brown
SELECT  '아이디: ' || userid,
CONCAT('아이디: ', userid)
FROM users;

SELECT table_name,
    CONCAT('SELECT * FROM ' || table_name, ':')AS QUERY
FROM user_tables;

-- WHERE절 조건연산자

-- 부서 번호가 10인 직원들만 조회
-- 부서 번호: deptno
SELECT * FROM users WHERE userid = 'brown';

-- emp테이블에서 부서번호가 20번 보다 큰 부서에 속한 직원
SELECT * FROM emp WHERE deptno > 20;

-- emp 테이블에서 부서번호가 20번 부서에 속하지 않은 모든 직원 조회
SELECT * FROM emp WHERE 1 = 2;

SELECT empno, ename, hiredate FROM emp WHERE hiredate >= '81/03/01';

문자열을 날짜 타입으로 변환하는 방법
TO_DATE(날짜 문자열, 날짜 문자열의 포맷팅)

SELECT empno, ename, hiredate FROM emp WHERE hiredate >= TO_DATE('1981/03/01', 'YYYY/MM/DD');


----------자습----------
--예시로 사용할 테이블: USERS
SELECT * FROM users;

--expression 활용하기
SELECT userid, usernm, pass FROM users;
