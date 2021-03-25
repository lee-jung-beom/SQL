서브쿼리 ( 실습 sub6)
--cycle 테이블을 이용하여 cid=1인 고객이 애음하는 제품 중 cid=2인 고객도 애음하는 제품의 애음정보를 조회하는 쿼리를 작성하세요
SELECT * 
FROM cycle
WHERE cid = 1 AND pid IN (SELECT pid FROM cycle WHERE cid = 2);

서브쿼리 (실습 sub7)
--customer, cycle, product 테이블을 이용하여 cid=1인 고객이 애음하는 제품 중 cid=2인 고객도 애음하는 제품의 애음 정보를 조회하고 
--고객명과 제품명까지 포함하는 쿼리를 작성하세요
SELECT *
FROM  customer c, cycle cy, product p
WHERE cy.cid = 1 
AND cy.pid = c.cid
AND cy.pid = p.pid
AND pid IN(SELECT pid FROM cycle WHERE cy.cid = 2);


EXISTS 서브쿼리 연산자 : 단항
IN : WHERE 컬럼 | EXPRESSION IN (값1, 값2, 값3.....)
EXISTS : WHERE EXISTS (서브쿼리)
        ==>서브쿼리 실행결과로 조회되는 행이 있으면 TRUE, 없으면 FALSE 
        EXISTS연사자와 사용되는 서브쿼리는 상호연관, 비상호연관 서브쿼리 둘다 사용 가능하지만 
        행을 제한하기 위해서 상호연관 서브쿼리와 사용되는 경우가 일반적이다.
        
        서브쿼리에서 EXISTS 연산자를 만족하는 행을 하나라도 발견을 하면 더 이상 진행하지 않고 효율적으로 일을 끊어 버린다
        서브쿼리가 1000건이라 하더라도 10번째 행에서 EXISTS연산을 만족하는 행을 발견하면 나머지 990건 정도의 데이터는 확인 안한다.

--매니저가 존재하는 직원 
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

SELECT *
FROM emp e
WHERE EXISTS (SELECT empno
                FROM emp m
                WHERE e.mgr = m.empno);
                
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X' --관습적으로 'X'을 표시한다
                FROM emp m
                WHERE e.mgr = m.empno);
        
연산자 : 몇 항
1 + 5//
++. --

SELECT COUNT(*)
FROM emp
WHERE deptno = 10;

SELECT *
FROM emp
WHERE deptno = 10;

if(cnt > 0){
}

SELECT *
FROM dual
WHERE EXISTS (SELECT 'X' FROM emp WHERE deptno = 10);


서브쿼리(실습 sub9)
cycle, product 테이블을 이용하여 cid =1인 고객이 애음하는 제품을 조회하는 쿼리를 EXISTS연산자를 이용하여 작성하세요
SELECT *
FROM product 
WHERE EXISTS (SELECT 'X' 
                FROM cycle
                WHERE cycle.cid = 1
                AND cycle.pid = product.pid)
                
                SELECT *
FROM product 
WHERE EXISTS (SELECT 'X' 
                FROM cycle
                WHERE cycle.cid = 1
                AND cycle.pid = product.pid)
                
SELECT *
FROM product 
WHERE NOT EXISTS (SELECT 'X' 
                FROM cycle
                WHERE cycle.cid = 1
                AND cycle.pid = product.pid);
                
                
<집합연산>
UNION/UNION ALL
INTERSECT
MINUS

중복을 허용하는 합집합
UNION ALL : {a, b} ∪ {a, c} = {a, a, b, c}

-데이터를 확장하는 sql의 한 방법
-수학 시간에 배운 집합의 개념과 동일
-집합에는 중복, 순서가 없다

-집합연산
UNION : 합집합, 두 개의 SELECT 결과를 하나로 합친다, 단 중복되는 데이터는 중복을 제거한다 ==> 수학적 개념과 동일

SELECT empno, ename, NULL
FROM emp
WHERE empno IN (7369, 7499)

UNION

SELECT empno, ename, deptno
FROM emp
WHERE empno IN (7369, 7521);

------------------------------
UNION ALL : 중복을 허용하는 합집합
            중복 제거 로직이 없기 때문에 속도가 빠르다.
            합집합 하려는 집합간 중복이 없다는 것을 알고 있을 경우 UNION연산자 보다 UNION ALL 연산자가 유리하다
SELECT empno, ename, NULL
FROM emp
WHERE empno IN (7369, 7499)

UNION ALL

SELECT empno, ename, deptno
FROM emp
WHERE empno IN (7369, 7521);

------------------------------------
INTERSECT : 두 개의 집합 중 중복되는 부분만 조회

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);

-----------------------------------------
MINUS : 한쪽 집합에서 다른 한쪽 집합을 제외한 나머지 요소들을 반환

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);


교환법칙
A - B != B - A 주의!

집합연산 특징
1. 집합연산의 결과로 조회되는 데이터의 컬럼 이름은 첫번째 집합의 컬럼을 따른다.
2. 집합연산의 결과를 정렬하고 싶으면 가장 마지막 집합 뒤에 ORDER BY를 기술한다.
    - 개별 집합에 ORDER BY를 사용한 경우 에러
        단 ORDER BY를 적용한 인라인 뷰를 사용하는 것은 가능
        
3. 중복된 것은 제거 된다(예외 UNION ALL)
4. 9i 이전버전 그룹연산을 하게되면 기본적으로 오름차순으로 정렬되어 나온다.
    이후버전 ==> 정렬을 보장하지 않음

DML
    - SELECT 
    - 데이터 신규 입력 : INSERT
    - 기존 데이터 수정 : UPDATE
    - 기존 데이터 삭제 : DELETE
    
INSERT 문법
INSERT INTO 테이블명 {((column,))} VALUES {(value, )}

INSERT INTO 테이블명 (컬럼명1, 컬럼명2, 컬럼명3....)
            VALUES (값1, 값2, 값3....)

만약 테이블에 존재하는 모든 컬럼에 데이터를 입력하는 경우 컬럼을 생략 가능하고 
값을 기술하는 순서를 테이블에 정의된 컬럼 순서와 일치시킨다.

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept (deptno, dname, loc) VALUES (99, 'ddit', 'daejeon');

DESC dept;

INSERT INTO emp (empno, ename, job) VALUES (9999, 'brown', 'RANGER');

SELECT * FROM emp;

INSERT INTO emp (empno, ename, job, hiredate, sal, comm) VALUES (9998, 'SALLY', 'RANGER', TO_DATE('20210324', 'yyyymmdd'), 900, NULL);

여러건을 한번에 입력하기
INSERT INTO 테이블명
SELECT 쿼리

INSERT INTO dept;
SELECT 90, 'DDIT', '대전' FROM dual UNION ALL
SELECT 80, 'DDIT', '대전' FROM dual;

SELECT * FROM dept;

ROLLBACK;
SELECT * 
FROM emp;

ROLLBACK
SELECT *
FROM dept;

UPDATE : 테이블에 존재하는 기존 데이터의 값을 변경
UPDATE 테이블명 SET 컬럼명 = 값1, 컬러명2 , 컬럼명3 = 값3.....
WHERE;

SELECT * 
FROM dept;

부서번호 99번 부서정보를 부서명=대덕IT로, loc = 영민빌딩으로 변경
WHERE 절이 누락 된 경우 테이블의 모든 행에 대해 업데이트를 진행
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩' WHERE deptno = 99;

SELECT * FROM dept;

