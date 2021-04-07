2021-0407-01)반복문
    - 개발언어의 반복문과 같은 기능 제공
    - loop, while, for문
 1)LOOP문
 - 반복문의 기본 구조
 - JAVA의 DO문과 유사한 구조임
 - 기본적으로 무한 루프 구조
 (사용형식)
 LOOP
    반복처리문(들);
    [EXIT WHEN 조건;]
 END LOOP;
  - 'EXIT WHEN 조건' : '조건'이 참인 경우 반복문의 범위를 벗어남
  
사용예) 구구단의 7단을 출력
DECLARE 
 V_CNT NUMBER := 1;
 V_RES NUMBER := 0;
BEGIN 
 LOOP
  RES := 7 * V_CNT;
  DBMS_OUTPUT.PUT_LINE(7||'*'||V_CNT||'='||V_RES);
  V_CNT := V_CNT + 1;
  EXIT WHEN V_CNT > 9;  
 END LOOP;
END;
  
사용예) 1-50사이의 피보니치수를 구하여 출력하시오
       FIBONACCI NUMBER : 첫번째와 두번째 수가 1, 1로 주어지고 세번째 수부터 전 두수의
       합이 현재수가 되는 수열 -> 검색 알고리즘에 사용
DECLARE
    V_PNUM NUMBER := 1; --전 수
    V_PPNUM NUMBER := 1; --전전 수
    V_CURRUM NUMBER := 0; --현재 수
    V_RES VARCHAR(100);
BEGIN
    V_RES := V_PPNUM||', '||V_PNUM;
    
    LOOP
      V_CURRNUM := V_PPNUM + V_PNUM;
      EXIT WHEN V_CURRNUM >= 50;
      V_RES := V_RES||', '||V_CURRNUM;
      V_PPNUM := V_PNUM;
      V_PNUM := V_CURRNUM;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('1~50사이의 피보나치 수 : '||V_RES);
END;


 2)WHILE문
  . 개발언어의 WHILE문과 같은 기증
  . 조건을 미리 체크하여 조건이 참인 경우에만 번복 처리
  (사용형식)
  WHILE 조건 
    LOOP
        반복처리문(들);
  END LOOP;
  
사용예) 첫날에 100원 두쨋날 부터 전날의 2배씩 저축할 경우 최초로 100만원을 
        넘는 날과 저축한 금액을 구하시오

DECLARE 
    V_DAYS NUMBER := 0; --날짜
    V_AMT NUMBER := 100; --날짜별 저축할 금액
    V_SUM NUMBER := 0; --저축한 금액 합계
BEGIN
    WHILE V_SUM < 1000000 LOOP
      V_SUM := V_SUM + V_AMT;
      V_DAYS := V_DAYS + 1;
      V_AMT := V_AMT * 2;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('날수 : ' || V_DAYS - 1);
    DBMS_OUTPUT.PUT_LINE('저축액수 : '|| V_SUM);
END;


사용예)회원테이블(MEMBER)에서 마일리지가 3000이상인 회원들을 찾아
      그들이 2005년 5월 구매한 횟수와 구매금액함계를 구하시오(커서사용)
      출력은 회원번호, 회원명, 구매횟수, 구매금액 
      
(LOOP를 사용한 커서 실행)
DECLARE
    V_MID MEMBER.MEM_ID%TYPE; --회원번호
    V_MNAME MEMBER.MEM_NAME%TYPE; --회원명
    V_CNT NUMBER := 0; --구매횟수
    V_AMT NUMBER := 0; --구매금액 합계
    
    CURSOR CUR_CART_AMT
    IS 
        SELECT MEM_ID, MEM_NAME
          FROM MEMBER
        WHERE MEM_MILEAGE >= 3000;
BEGIN 
  OPEN CUR_CART_AMT;
  
  LOOP
    FETCH CUR_CART_AMT INTO V_MID, V_MNAME;
    EXIT WHEN CUR_CART_AMT % NOTFOUND;
    SELECT SUM(A.CART_QTY * B.PROD_PRICE),
           COUNT(A.CART_PROD) INTO V_AMT, V_CNT
        FROM CART A, PROD B
     WHERE A.CART_PROD = B.PROD_ID
       AND A.CART_MEMBER = V_MID
       AND SUBSTR(A.CART_NO, 1, 6)='200505';
     
     DBMS_OUTPUT.PUT_LINE(V_MID||', '||V_MNAME||' => '||V_AMT||'('||V_CNT||')');  
     END LOOP;
     CLOSE CUR_CART_AMT;
    END;
    
(WHILE문 사용)    
DECLARE
    V_MID MEMBER.MEM_ID%TYPE; --회원번호
    V_MNAME MEMBER.MEM_NAME%TYPE; --회원명
    V_CNT NUMBER := 0; --구매횟수
    V_AMT NUMBER := 0; --구매금액 합계
    
    CURSOR CUR_CART_AMT
    IS 
        SELECT MEM_ID, MEM_NAME
          FROM MEMBER
        WHERE MEM_MILEAGE >= 3000;
BEGIN 
  OPEN CUR_CART_AMT;
  FETCH CUR_CART_AMT INTO V_MID, V_MNAME;
  WHILE CUR_CART_AMT%FOUND LOOP
    
    SELECT SUM(A.CART_QTY * B.PROD_PRICE),
           COUNT(A.CART_PROD) INTO V_AMT, V_CNT
        FROM CART A, PROD B
     WHERE A.CART_PROD = B.PROD_ID
       AND A.CART_MEMBER = V_MID
       AND SUBSTR(A.CART_NO, 1, 6)='200505';
     
     DBMS_OUTPUT.PUT_LINE(V_MID||', '||V_MNAME||' => '||V_AMT||'('||V_CNT||')');  
        FETCH CUR_CART_AMT INTO V_MID, V_MNAME;
     END LOOP;
     CLOSE CUR_CART_AMT;
    END;


    3)FOR문
    . 반복횟수를 알고 있거나 횟수가 중요한 경우 사용
    (사용형식 - 1 : 일반적 FOR)
    FOR 인덱스 IN[REVERSE] 최소값..최대값
    LOOP
     반복처리문(들);
    END LOOP;
    
사용예) 구구단의 7단을 FOR문을 이용하여 구성
DECLARE 
    -- V_RES NUMBER:=0; --결과
BEGIN
    FOR I IN 1..9 LOOP
        -- V_RES := 7*I;
        DBMS_OUTPUT.PUT_LINE(7||'*'||I||'='||7*I);
    END LOOP;
END;

    (사용형식-2:CURSOR에 사용하는 FOR)
    FOR 레코드명 IN커서명|(커서선언문)
    LOOP
        반복처리문(들);
    END LOOP;
    . '레코드명'은 시스템에서 자동으로 설정
    . 커서 컬럼을 참조형식 : 레코드명.커서컬럼명
    . 커서명 대신 커서 선언문(선언부에 존재했던)이 INLINE형식으로
      기술할 수 있음
    . FOR문을 사용하는 경우 커서의 OPEN, FETCH, CLOSE문은 생략함 
    
(FOR문 활용)
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


2021-0407-02)저장프로시져(Stored procedure: Procedure)
 - 특정 결과를 산출하기 위한 코드의 집합(모듈) 
 - 반환 값이 없음
 - 컴파일되어 서버에 보관(실행속도를 증가, 은닉성, 보안성)
 (사용형식)
 CREATE [OR REPLACE] PROCEDURE 프로시져명[(
   매개변수명 [IN | OUT | INOUT] 데이터타입 [[:= | DEFAULT] expr],  --중간에 데이터타입에는 크기는 삽입하지 않고 타입만 선언하도록 유의한다
   매개변수명 [IN | OUT | INOUT] 데이터타입 [[:= | DEFAULT] expr],
                                :
   매개변수명 [IN | OUT | INOUT] 데이터타입 [[:= | DEFAULT] expr])]
 AS | IS
   선언영역;
 BEGIN
   실행영역;
 END;
*FUNCTION은 SELECT절에서 선언가능
*procedure은 결과값이 반환되지 않는다 : procedure은 독립적으로 실행해야 한다

 **다음 조건에 맞는 재고수불 테이블을 생성하시오
 1. 테이블명 : REMAIN
 2. 커럼
 ================================================
 컬럼명          데이터타입                제약사항
 ================================================
 REMAIN_YEAR    CHAR(4)                  PK
 PROD_ID        VARCHAR2(10)             PK & PK
 REMAIN_J_00    NUMBER(5)                DEFAULT 0 --기초재고
 REMAIN_I       NUMBER(5)                DEFAULT 0 --입고수량
 REMAIN_O       NUMBER(5)                DEFAULT 0 --출고수량
 REMAIN_J_99    NUMBER(5)                DEFAULT 0 --기말재고
 REMAIN_DATE    DATE                     DEFAULT SYSDATE --처리일자
 
 **테이블 생성명령
 CREATE TABLE 테이블명(
    컬럼명1 데이터타입[(크기)] [NOT NULL][DEFAULT 값|수식] [,]
    컬럼명2 데이터타입[(크기)] [NOT NULL][DEFAULT 값|수식] [,]    
    컬럼명n 데이터타입[(크기)] [NOT NULL][DEFAULT 값|수식] [,]
    
    CONSTRAINT 기본키 설정명 PRIMARY KEY (컬럼명1 [, 컬럼명2,....]) [,]
    CONSTRAINT 외래키 설정명 FOREIGN KEY (컬럼명1 [, 컬럼명2,....]) 
        REFERENCES 테이블명1(컬러명1 [, 컬럼명2,....])[,]
    
    CONSTRAINT 외래키설정명n FOREIGN KEY (컬럼명1[, 컬럼명2,....])
        REFERENCES 테이블명n(컬러명1 [, 컬럼명2,....])[,]
 )
 
 CREATE TABLE REMAIN(
     REMAIN_YEAR    CHAR(4),
     PROD_ID        VARCHAR2(10),
     REMAIN_J_00    NUMBER(5) DEFAULT 0,
     REMAIN_I       NUMBER(5) DEFAULT 0, --입고수량
     REMAIN_O       NUMBER(5) DEFAULT 0, --출고수량
     REMAIN_J_99    NUMBER(5) DEFAULT 0, --기말재고
     REMAIN_DATE    DATE, --처리일자
     
     CONSTRAINT pk_reamin PRIMARY KEY(REMAIN_YEAR, PROD_ID),
     CONSTRAINT fk_remain_prod FOREIGN KEY (PROD_ID)
        REFERENCES PROD(PROD_ID)
);

**REMAIN 테이블에 기초자료 삽입 
  년도 : 2005
  상품코드 : 상품테이블의 상품코드
  기초재고 : 상품테이블의 적정재고(PROD_PROPERSTOCK)
  입고수량/출고수량 : 없음
  처리일자 : 2004/12/31
  
INSERT INTO REMAIN(REMAIN_YEAR, PROD_ID, REMAIN_J_00, REMAIN_J_99, REMAIN_DATE)
    SELECT '2005', PROD_ID, PROD_PROPERSTOCK, PROD_PROPERSTOCK, TO_DATE('20041231')
        FROM PROD;
        
SELECT *
FROM REMAIN;

  