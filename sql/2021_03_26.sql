INSERT 단 건, 여러 건

INSERT INTO 테이블명
SELECT -----

UPDATE 테이블명 SET 컬럼명1 = (스칼라 서브쿼리),
                    컬럼명2 = (스칼라 스버쿼리), 
                    컬럼명3 = "TEST"
                    
Q1. 9999사번(empno)을 갖는 "brown" 직원(ename)을 입력
ROLLBACK;
INSERT INTO emp(empno, ename) VALUES(9999, 'brown');

DESC emp;

SELECT * 
FROM emp;

Q2. 9999사번의 행에 job과 deptno를 SMITH사원의 정보로 업데이트 하여라.
UPDATE emp SET job = (SELECT job
                      FROM emp
                      WHERE = 'SMITH')
                deptno = " "
WHERE ename = 'SMITH'                

DELETE : 기존에 존재하는 데이터를 삭제
DELETE 테이블명 WHERE 조건;


DBMS는 DML 문장을 실행하게 되면 LOG를 남긴다
UNDO(REDO) LOG

로그를 넘기지 않고 더 빠르게 데이터를 삭제하는 방법 : TRUNCATE
- DML이 아님(DDL)
- ROLLBACK이 불가(복구 불가)
- 주로 테스트 환경에서 사용

TRUNCATE TABLE 테이블명;

Transaction
-트랜잭션 예시
 .게시글 입력시(제목, 내용, 복수개의 첨부파일)
 .게시글 테이블, 게시글 첨부파일 테이블
 .1.DML: 게시글 입력
 .2.DML: 게시글 첨부파일 입력

읽기 일관성 레벨(0 ~ 3)
트랜잭션에서 실행한 결과가 다른 트랜잭션에 어떻게 영향을 미치는지 정의한 레벨(단계)

LEVEL 0 : READ UNCOMMITED
    - dirty(변경이 가해졌다) read
    - 커밋을 하지 않은 변경 사항도 다른 트랜잭션에서 확인 가능
    - oracle에서는 지원하지 않음
LEVEL  1 : READ COMMITED
    - 대부분의 DBMS 읽기 일관성, 설정 레벨
    - 커밋한 데이터만 다른 트랜잭션에서 읽을 수 있다

LEVEL 2 : Reapeatable Read
    - 선행 트랜잭션에서 읽은 데이터를 후행 트랜잭션에서 수정하지 못하도록 방지
    - 선행 트랜잭션에서 읽었던 데이터를 트랜잭션의 마지막에서 다시 조회를 해도 동일한 결과가 나오게끔 유지
    - 신규 입력 데이터에 대해서는 막을 수 없음
        => Phantom Read - 없던 데이터가 조회되는 현상
    기존 데이터에 대해서는 동일한 데[이터가 조회되도록 유지
    - oracle에서는 LEVEL2에 대해 공ㅇ식적으로 지원하지 않으나 FOR UPDATE 구문을 이용하여 효과를 만들어낼 수 있다.
    
LEVEL 3 : Serialirable Read 직렬화 읽기
    - 후행 트랜재겻넹서 수정, 입력 삭제한 데이터가 선행 트랜잭션에 영향을 주지 않음
    

인덱스
 - 눈에 안보임
 - 테이블의 일부 커럼을 사용하여 데이터를 정렬한 객체
    ==> 원하는 데이터를 빠르게 찾을 수 있다
    . 일부 컬럼과 함께 그 컬럼의 행을 찾을 수 있는 ROWID가 같이 저장됨
 - ROWID : 테이블에 저장된 행의 물리적 위치, 집 주소 같은 개념 주소를 통해서 해당 행의 위치로 빠르게 접근하는 것이 가능
            데이터가 입력이 될 때 생성

SELECT emp.*
FROM emp
WHERE ROWID = 'AAAE5gAAFAAAACPAAA';

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);


오라클 객체 생성
CREATE 객체 타입(INDEX, TABLE...) 객체명

인덱스 생성
CREATE [UNIQUE] INDEX ( 인덱스이름 ON 테이블명(컬럼1, 컬럼2....);
CREATE UNIQUE INDEX PK_emp ON emp(empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

DROP INDEX PK_EMP;

CREATE INDEX IDK_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7702;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 536972831
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDK_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7702)
 
Note
-----
   - dynamic sampling used for this statement (level=2)
   
DELETE emp
WHERE 
   
job 컬럼에 인덱스 생성
CREATE INDEX idx_emp_02 ON emp (job);

SELECT job, ROWID
FROM emp
ORDER By job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';
