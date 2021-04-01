VIEW 객체
-VIEW는 TABLE과 유사한 객체이다.
-VIEW는 기존의 테이블이나 다른 VIEW객체를 행하여 새로운 SELECT문의 결과를 테이블처럼 사용한다. (가상테이블)
    -VIEW는 SELECT문에 귀속되는 것이 아니고, 독립적으로 테이블처럼 존재
-VIEW를 이용하는 경우
    -필요한 정보가 한 개의 테이블에 있지 않고, 여러 개의 테이블에 분산되어 있는 경우
    -테이블에 들어 있는 자료의 일부분만 필요하고 자료의 전체 row나 column이 필요하지 않은 경우
    -특정 자료에 대한 접근을 제한하고자 할 경우(보안)
객체 생성: CREATE / 객체 삭제 : DROP
요약 정리)
    -TABLE과 유사한 기능 제공
    -보안, QUERY 실행의 효율성, TABLE의 은닉성을 위하여 사용
    (사용형식)
    CREATE (OR REPLACE) [FORCE|NOFORCE} VIEW 뷰이름 (컬럼LIST)]
    AS
    SELECT 문;
    [WITH CHECK OPTION;]
    [WITH READ ONLY;]
    -'OR REPLACE' : 뷰가 존재하면 대체되고 없으면 신규로 생성 
    -'FORCE|NOFROCE : 원본 테이블의 존재하지 않아도 뷰를 생성(FORCE), 생성불가(NOFORCE)
    -'컬럼LIST' : 생성된 뷰의 컬럼명
    -'WITH CHECK OPTION' : SELECT문의 조건절에 위배되는 DML명령 실행 거부
    -'WITH READ ONLY' : 읽기전용 뷰 생성

사용 예) 사원테이블에서 부모부서코드가 90번 부서에 속한 사원정보를 조회하시오.
        조회할 데이터 : 사원번호, 사원명, 부서명, 급여 
사용 예) 회원테이블에서 마일리지가 3000이상인 회원의 회원번호, 회원명, 직업, 마일리지를 조회하시오.
    SELECT MEM_ID AS 회원번호, MEM_NAME AS 회원명, MEM_JOB AS 직업, MEM_MILEAGE AS 마일리지
    FROM MEMBER
    WHERE MEM_MILEAGE >= 3000;
    
=>뷰 생성
    CREATE OR REPLACE VIEW V_MEMBER01
    AS 
    SELECT MEM_ID AS 회원번호, 
           MEM_NAME AS 회원명, 
           MEM_JOB AS 직업, 
           MEM_MILEAGE AS 마일리지
    FROM MEMBER
    WHERE MEM_MILEAGE >= 3000;
    
SELECT * FROM V_MEMBER01;

(신용환 회원의 자료 검색)
SELECT MEM_NAME, MEM_JOB, MEM_MILEAGE
    FROM MEMBER
WHERE UPPER(MEM_ID) = 'C001';

(MEMBER테이블에서 신용환의 마일리지를 10,000으로 변경)
UPDATE MEMBER 
    SET MEM_MILEAGE = 10000
    WHERE MEM_NAME = '신용환';
    
(VIEW V_MEMBER01에서 신용환의 마일리지를 10,000으로 변경)
UPDATE V_MEMBER01
    SET 마일리지 = 500
    WHERE 회원명 = '신용환';

--WITH CHECK OPTION 사용 VIEW생성
 CREATE OR REPLACE VIEW V_MEMBER01(MID, MNAME, MJOB, MILE)
    AS 
    SELECT MEM_ID AS 회원번호, 
           MEM_NAME AS 회원명, 
           MEM_JOB AS 직업, 
           MEM_MILEAGE AS 마일리지
    FROM MEMBER
    WHERE MEM_MILEAGE >= 3000   
    WITH CHECK OPTION;

SELECT * FROM V_MEMBER01;

(테이블 MEMBER에서 신용환 회원의 마일리지를 2000으로 변경)
UPDATE MEMBER
    SET MEM_MILEAGE = 2000
    WHERE UPPER(MEM_ID) = 'C001';

SELECT * FROM V_MEMBER01;


--WITH READ ONLY 사용하여 VIEW생성******
CREATE OR REPLACE VIEW V_MEMBER01(MID, MNAME, MJOB, MILE)
    AS 
    SELECT MEM_ID AS 회원번호, 
           MEM_NAME AS 회원명, 
           MEM_JOB AS 직업, 
           MEM_MILEAGE AS 마일리지
    FROM MEMBER
    WHERE MEM_MILEAGE >= 3000   
    WITH READ ONLY;
    
        
    ROLLBACK;    
    
SELECT MEM_NAME, MEM_JOB, MEM_MILEAGE
    FROM MEMBER
WHERE UPPER(MEM_ID) = 'C001';

SELECT * FROM V_MEMBER01;

(뷰 V_MEMBER01에서 오철희 회원의 마일리지를 5700으로 변경)
UPDATE V_MEMBER01
SET MILE = 5700
WHERE UPPER(MID) = 'K001';

SELECT * FROM V_MEMBER01;

SELECT HR.DEPARTMENTS.DEPARTMENT_ID,
        DEPARTMENT_NAME
    FROM HR.DEPARTMENTS;


2021-0401-02)
문제] 사원테이블(employees)에서 50번 부서에 속한 사원 중 
     급여가 5000이상인 사원번호, 사원명, 입사일, 급여를 읽기 전용 뷰로 생성하시오.
     뷰이름은 v_emp_sal01이고 컬럼명은 원본테이블의 컬러명을 사용 
     뷰가 생성된 후 뷰와 테이블을 이용하여 해당 사원의 
     사원번호, 사원명, 직무명, 급여를 출력하는 sql작성

(뷰 생성)
CREATE OR REPLACE VIEW v_emp_sal01(사원번호, 사원명, 입사일, 급여)
    AS
    SELECT employee_id AS 사원번호, 
           first_name AS 사원명, 
           hire_date AS 입사일, 
           salary AS 급여
    FROM employees
    WHERE department_id = 50 
          AND salary >= 5000
    WITH READ ONLY;
    
CREATE SYNONYM v_emp_sal01 FOR v_exp_sal01;
    
SELECT * FROM v_emp_sal01;    

SELECT C.employee_id AS 사원번호, 
       C.emp_name AS 사원명, 
       B.job_title AS 직무명, 
       C.salary AS 급여
    FROM employees A, jobs B, v_emp_sal01 C
    WHERE A.employee_id = C.employee_id
   AND A.job_id = B.job_id;
     

SELECT C.사원번호,
       C.사원명,
       B.JOB_TITLE,
       C.급여
    FROM EMPLOYEES A, JOBS B, V_EMP_SAL01 C
    WHERE A.EMPLOYEE_ID = C.사원번호
    AND A.JOB_ID = B.JOB_ID;
     
     
SELECT employee_id, first_name, hire_date, salary 
FROM hr.employees
-WHERE salary >= 5000
GROUP 
WITH READ ONLY;

SELECT *
FROM hr.employees;


