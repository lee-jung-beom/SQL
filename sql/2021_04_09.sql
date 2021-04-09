2021-0409-01)USER DEFINED FUNCTION(FUNCTION)
 - 사용자가 정의한 함수
 - 반환값이 존재
 - 자주 사용되는 복잡한 query들을 모듈화 시켜 컴파일 한 후 호출하여 사용 
 (사용형식)
 CREATE [OR REPLACE] FUNCTION 함수명[(
   매개변수 [IN|OUT|INOUT] 데이터타입 [{:=|DEFAULT} expr][,]
                            :
   매개변수 [IN|OUT|INOUT] 데이터타입 [{:=|DEFAULT} expr])]
   RETURN 데이터타입
 AS|IS
   선언영역; --변수, 상수, 커서
 BEGIN 
   실행문;
   RETURN 변수|수식;
   [EXCEPTION 예외처리문;]
END;

사용예) 장바구니테이블에서 2005년 6월 5일 판매된 상품코드를 입력 받아 
       상품명을 출력하는 함수를 작성하시오.
       1. 함수명 : FN_PNAME_OUTPUT
       2. 매개변수 : 입력용 : 상품코드
       3. 반환값 : 상품명
       
  (함수 생성)
  CREATE OR REPLACE FUNCTION FN_PNAME_OUTPUT(
    P_CODE IN PROD.PROD_ID%TYPE)
    RETURN VARCHAR2
   IS
     V_PNAME PROD.PROD_NAME%TYPE;
   BEGIN 
     SELECT PROD_NAME INTO V_PNAME
       FROM PROD
      WHERE PROD_ID = P_CODE;
      
     RETURN V_PNAME ;
    END;
    
(실행)
SELECT CART_MEMBER, FN_PNAME_OUTPUT(CART_PROD)
  FROM CART
 WHERE CART_NO LIKE '20050605%';

사용예)2005년 5월 모든 상품별에 대한 매입현황을 조회하시오
      Alias는 상품코드, 상품명, 매입수량, 매입금액 
OUTER JOIN

SELECT B.PROD_ID AS 상품코드, 
       B.PROD_NAME AS 상품명, 
       SUM(A.BUY_QTY) AS 매입수량, 
       SUM(A.BUY_QTY*B.PROD_COST) AS 매입금액
  FROM BUYPROD A, PROD B
 WHERE A.BUY_PROD(+) = B.PROD_ID
   AND A.BUY_DATE BETWEEN '20050501' AND '20050531'
 GROUP BY B.PROD_ID, B.PROD_NAME;

(ANSI OUTER JOIN)
SELECT B.PROD_ID AS 상품코드, 
       B.PROD_NAME AS 상품명, 
       NVL(SUM(A.BUY_QTY), 0) AS 매입수량, 
       NVL(SUM(A.BUY_QTY*B.PROD_COST), 0) AS 매입금액
  FROM BUYPROD A 
 RIGHT OUTER JOIN PROD B ON(A.BUY_PROD = B.PROD_ID
   AND A.BUY_DATE BETWEEN '20050501' AND '20050531')
 GROUP BY B.PROD_ID, B.PROD_NAME;

(서브쿼리)
SELECT B.PROD_ID AS 상품코드,
       B.PROD_NAME AS 상품명,
       NVL(A.QAMT, 0) AS 구입수량,
       NVL(A.HAMT, 0) AS 구입금액
  FROM(SELECT BUY_PROD AS BID,
           SUM(BUY_QTY) AS QAMT,
           SUM(BUY_QTY*BUY_COST) AS HAMT
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN '20050501' AND '20050531'
        GROUP BY BUY_PROD) A, PROD B
 WHERE A.BID(+)=B.PROD_ID;
 

(함수 사용)
CREATE OR REPLACE FUNCTION FN_BUYPROD_AMT(
  P_CODE IN PROD.PROD_ID%TYPE)
  RETURN VARCHAR2
IS 
  V_RES VARCHAR2(100); --매입수량과 매입금액을 문자열로 변환하여 기억
  V_QTY NUMBER := 0; --매입수량 합계
  V_AMT NUMBER := 0; --매입금액 합계
BEGIN
  SELECT SUM(BUY_QTY), SUM(BUY_QTY*BUY_COST) INTO V_QTY, V_AMT
    FROM BUYPROD
   WHERE BUY_PROD=P_CODE
     AND BUY_DATE BETWEEN '20050501' AND '20050531';
    IF V_QTY IS NULL THEN
       V_RES:='0';
    ELSE 
       V_RES:='수량 : '||V_QTY||', '||'구매금액 : '||TO_CHAR(V_AMT, '99,999,999');
    END IF;
    RETURN V_RES;
END;

(실행)
SELECT PROD_ID AS 상품코드, 
       PROD_NAME AS 상품명,
       FN_BUYPROD_AMT(PROD_ID) AS 구매내역
   FROM PROD;
   

상품코드를 입력받아 2005년도 평균판매횟수, 전체판매수량, 판매금액함계를 
출력할 수 있는 함수를 작성하시오.
1. 함수명 : FN_CART_QVAG(평균판매횟수), FN_CART_QAMT(전체판매수량), FN_CART_FAMT(판맨금액합계)
2. 매개변수 : 입력 : 상품코드, 년도

CREATE OR REPLACE FUNCTION FN_CART_QAVG(
  P_CODE IN PROD.PROD_ID%TYPE,
  P_YEAR CHAR)
  RETURN NUMBER
AS
  V_QAVG NUMBER:=0;
  V_YEAR CHAR(5):=P_YEAR||'%';
BEGIN 
  SELECT ROUND(AVG(CART_QTY)) INTO V_QAVG
    FROM CART
  WHERE CART_NO LIKE V_YEAR
    AND CART_PROD=P_CODE;
  
  RETURN V_QAVG;
END;

(실행)
SELECT PROD_ID,
       PROD_NAME,
       FN_CART_QAVG(PROD_ID, '2005')
  FROM PROD;

[문제] 2005년 2~3월 제품별 구매수량을 구하여 재고수불테이블을 UPDATE하시오
      처리일자는 2005년 3월 마지막 일임-함수이용
SELECT * FROM prod;      

CREATE OR REPLACE FUNCTION fn_stock_table(
    pdate IN prod.prod_insdate%TYPE;
)
RETURN NUMBER
IS 


--
CREATE OR REPLACE FUNCTION FN_REMAIN_UPDATE(
    P_PID IN PROD.PROD_ID%TYPE,
    P_QTY IN BUYPROD.BUY_QTY_%TYPE;
    P_DATE IN DATE)
RETURN VARCHAR2
AS
  V_MESSAGE VARCHAR2(100);
BEGIN
  UPDATE REMAIN
    SET(REMAIN_I, REMAIN_J_99, REMAIN_DATE)=(SELECT REMAIN_I+P_QTY,
                                                    REMAIN_J_99 + P_QTY,
                                                    P_DATE
                                                FROM REMAIN
                                              WHERE REMAIN_YEAR='2005'
                                                AND PROD_ID=P_PID)                                                
    WHERE REMAIN_YEAR='2005'
      AND PROD_ID=P_PID;
    V_MESSAGE :=P_PID||'제품 입고처리 완료';
    RETURN V_MESSAGE;
END;
      
DECLARE 
  CURSOR CUR_BUYPROD
  IS
    SELECT BUY_PROD, SUM(BUY_QTY) AS AMT
      FROM BUYPROD
    WHERE BUY_DATE BETWEEN '20050201' AND '20050331'
    GROUP BY BUY_PROD;
  V_RES VARCHAR2(100);
BEGIN
  FOR REC_BUYPROD IN CUR_BUYPROD LOOP
      V_RES:=FN_REMAIN_UPDATE(REC_BUYPROD.BUY_PROD,RED_BUYPROD.AMT,LAST_DAY('20050303'));
      DBMS_OUTPUT.PUT_LINE(V_RES);
  END LOOP;
END;

SELECT * 
  FROM REMAIN;
  

2021-0409-02)TRIGGER
 - 어떤 이벤트가 발생하면 그 이벤트의 발생 전(前), 후(後)로 자동적으로 실행되는 
   코드블럭(프로시저의 일종)
   (사용형식)
   CREATE TRIGGER 트리거명
     (timming)BEFORE|ALTER (event)INSERT|UPDATE|DELETE
     ON 테이블명
     [FOR EACH ROW]
     [WHEN 조건]
[DECLARE
   변수, 상수, 커서;
]    
  BEGIN
    명령문(들);--트리거 처리문
    [EXCEPTION
      예외처리문;
    ]
   END;    
 .'timming' : 트리거처리문 수행 시점(BEFORE : 이벤트 발생전, AFTER : 이벤트 발생 후)
 .'event' : 트리거가 발생될 원인 행위 (OR로 연결 사용 가능, ex) INSERT OR UPDATE OR DELETE)
 .'테이블명' : 이벤트가 발생되는 테이블이름
 .'FOR EACH ROW' : 행단위 트리거 발생, 생략되면 문장단위 트리거 발생
 . WHEN 조건 : 행단위 트리거에서만 사용 가능, 이벤트가 발생될 세부조건 추가 설정 
    
 
DECLARE
  V_CNT NUMBER:=0;--구매횟수
  V_AMT NUMBER:=0;--구매금액 합계
  
  CURSOR CUR_CART_AMT
  IS 
    SELECT MEM_ID,MEM_NAME
      FROM MEMBER
     WHERE MEM_MILEAGE>=3000; 
BEGIN
  FOR REC_CART IN CUR_CART_AMT LOOP 
    SELECT SUM(A.CART_QTY*B.PROD_PRICE),
           COUNT(A.CART_PROD) INTO V_AMT,V_CNT
      FROM CART A, PROD B
     WHERE A.CART_PROD=B.PROD_ID
       AND A.CART_MEMBER=REC_CART.MEM_ID
       AND SUBSTR(A.CART_NO,1,6)='200505';   
    DBMS_OUTPUT.PUT_LINE(REC_CART.MEM_ID||', '||REC_CART.MEM_NAME||
                         ' => '||V_AMT||'('||V_CNT||')'); 
  END LOOP;
END; 
  


(FOR문에서 INLINE 커서 사용)  
DECLARE
  V_CNT NUMBER:=0;--구매횟수
  V_AMT NUMBER:=0;--구매금액 합계
BEGIN
  FOR REC_CART IN (SELECT MEM_ID,MEM_NAME
                     FROM MEMBER
                    WHERE MEM_MILEAGE>=3000)
  LOOP 
    SELECT SUM(A.CART_QTY*B.PROD_PRICE),
           COUNT(A.CART_PROD) INTO V_AMT,V_CNT
      FROM CART A, PROD B
     WHERE A.CART_PROD=B.PROD_ID
       AND A.CART_MEMBER=REC_CART.MEM_ID
       AND SUBSTR(A.CART_NO,1,6)='200505';   
    DBMS_OUTPUT.PUT_LINE(REC_CART.MEM_ID||', '||REC_CART.MEM_NAME||
                         ' => '||V_AMT||'('||V_CNT||')'); 
  END LOOP;
END; 
 
 
 
[문제] 2005년 2~3월 제품별 매입수량을 구하여 재고수불테이블을 UPDATE하시오
      처리일자는 2005년 3월 마지막일임-함수이용
CREATE OR REPLACE FUNCTION FN_REMAIN_UPDATE(
  P_PID IN PROD.PROD_ID%TYPE,
  P_QTY IN BUYPROD.BUY_QTY%TYPE,
  P_DATE IN DATE)
  
  RETURN VARCHAR2
AS
  V_MESSAGE VARCHAR2(100);
BEGIN
  UPDATE REMAIN
     SET(REMAIN_I,REMAIN_J_99,REMAIN_DATE)=(SELECT REMAIN_I+P_QTY,
                                                   REMAIN_J_99+P_QTY,
                                                   P_DATE
                                              FROM REMAIN
                                             WHERE REMAIN_YEAR='2005'
                                               AND PROD_ID=P_PID)
   WHERE REMAIN_YEAR='2005'
     AND PROD_ID=P_PID;   
   V_MESSAGE:=P_PID||'제품 입고처리 완료';
   RETURN V_MESSAGE;
END;   


DECLARE
  CURSOR CUR_BUYPROD
  IS 
    SELECT BUY_PROD,SUM(BUY_QTY) AS AMT
      FROM BUYPROD
     WHERE BUY_DATE BETWEEN '20050201' AND '20050331'
     GROUP BY BUY_PROD;
  V_RES VARCHAR2(100);   
BEGIN
  FOR REC_BUYPROD IN CUR_BUYPROD LOOP
      V_RES:=FN_REMAIN_UPDATE(REC_BUYPROD.BUY_PROD,REC_BUYPROD.AMT,LAST_DAY('20050301'));
      DBMS_OUTPUT.PUT_LINE(V_RES);
  END LOOP;
END;  


SELECT *
 FROM REMAIN;
 
--JAVA과제: 테이블 연결하여 게시판 만들기
CREATE TABLE TB_JDBC_BOARD
(
    BOARD_NO NUMBER(4) NOT NULL,
    TITLE VARCAHR2(500),
    CONTENT VARCAHR2(2000),
    USER_ID VARCAHR2(50),
    REG_DATE DATE
);

CREATE TABLE testTABLE(
    NO NUMBER(4)
);

SELECT * FROM testTABLE;

--tip
INSERT INTO MEMBER
SELECT * 
FROM MEMBER AS OF TIMESTAMP(SYSTIMESTAMP - INTERVAL '10' MINUTE)
WHERE MEM_ID = 'a001';
 
