2021-0412-01)TRIGGER
 - 어떤 이벤트가 발생하면 그 이벤트의 발생 전(前), 후(後)로 자동적으로 실행되는 
   코드블럭(프로시저의 일종)
   (사용형식)
   CREATE TRIGGER 트리거명
     (timming)BEFORE|AFTER (event)INSERT|UPDATE|DELETE
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
 
*문장단위 트리거, 행 단위 트리거 

문장단위 트리거 예) 상품분류테이블에 자료를 삽입하시오. 자료 삽입 후 
 '상품분류코드가 추가 되었습니다'라는 메시지를 트리거를 이용하여 출력하시오
[자료]
.lprod_gu : 'P701'
.lprod_nm : '신선식품'

(트리거 생성)
CREATE OR REPLACE TRIGGER TG_LPROD_INSERT
    AFTER INSERT ON LPROD
BEGIN
    DBMS_OUTPUT.PUT_LINE('상품분류코드가 추가되었습니다');
END;

(이벤트)
INSERT INTO LPROD 
  VALUES(10, 'p701', '드림식품');

SELECT * FROM LPROD;

사용예)매입테이블에서 2005년 4월 16일 상품'P202000001'을 매입한 다음 재고수량을 
      UPDATE하시오.
      [매입정보]
      1. 상품코드 : 'P101000001'
      2. 날짜 '2005-04-16'
      3. 매입수량 : 5
      4. 매입단가 : 210000
      
(트리거 생성)
CREATE OR REPLACE TRIGGER TG_REMAIN_UPDATE --트리거명_작업 대상 테이블명_동작설명
  AFTER INSERT OR UPDATE OR DELETE ON BUYPROD
  FOR EACH ROW
BEGIN 
  UPDATE REMAIN 
    SET (REMAIN_I, REMAIN_J_99, REMAIN_DATE)=(
         SELECT REMAIN_I+:NEW.BUY_QTY, REMAIN_J_99+:NEW.BUY_QTY, '20050416'
           FROM REMAIN
          WHERE REMAIN_YEAR='2005'
            AND REMAIN_DATE=TO_DATE('20050416')
            AND PROD_ID=:NEW.BUY_PROD)
  WHERE REMAIN_YEAR='2005'
    AND REMAIN_DATE=TO_DATE('20050416')
    AND PROD_ID=:NEW.BUY_PROD;
END;

INSERT INTO BUYPROD
  VALUES(TO_DATE('20050416'), 'P101000001', 5, 210000);
  
SELECT * FROM REMAIN;  


**트리거
  - 데이터의 무결성 제약을 강화
  - 트리거 내부에는 트렌잭션 제어문(COMMIT, ROLLBACK, SAVEPOINT 등)을 사용할 수 없음
  - 트리거 내부에 사용되는 PROCEDURE, FUNCTION에서도 트랜잭션 제어문을 사용할 수 없음
  - LONG, LONG RAW 등의 변수 선언 사용할 수 없음

**트리거 의사레코드
  1) :NEW - INSERT, UPDATE에서 사용, 
            데이터가 삽입(갱신)될 때 새롭게 들어오는 자료
            DELETE 시에는 모두 NULL로 SETTING
  2) :OLD - DELETE, UPDATE에서 사용,
            데이터가 삭제(갱신)될 때 이미 존재하고 있던 자료
            INSERT 시에는 모두 NULL로 SETTING

**트리거 함수
  - 트리거를 유발시킨 DML을 구별하기 위해 사용
  ----------------------------------------------------------------
  함수                     의미
  ----------------------------------------------------------------
  INSERTING                트리거의 EVENT가 INSERT 이면 참(TRUE)반환
  UPDATING                 트리거의 EVENT가 UPDATE 이면 참(TRUE)반환
  DELETING                 트리거의 EVENT가 DELETE 이면 참(TRUE)반환
  
사용예)장바구니 테이블에 신규 판매자료가 삽입될 때 재고를 처리하는 트리거를 작성하시오
(트리거 생성)
CREATE OR REPLACE TRIGGER TG_REMAIN_CART_UPDATE 
  AFTER INSERT OR UPDATE OR DELETE ON CART
  FOR EACH ROW 
DECLARE 
  V_QTY CART.CART_QTY%TYPE;
  V_PROD PROD.PROD_ID%TYPE;
BEGIN 
  IF INSERTING THEN 
    V_QTY:=:NEW.CART_QTY;
    V_PROD:=:NEW.CART_PROD;
  ELSIF UPDATING THEN
    V_QTY:=:NEW.CART_QTY - :OLD.CART_QTY;
    V_PROD:=:NEW.CART_PROD;
  ELSE 
    V_QTY:=:OLD.CART_QTY;
    V_PROD:=:OLD.CART_PROD;
  END IF;
  UPDATE REMAIN
    SET REMAIN_O=REMAIN_O - V_QTY,
        REMAIN_J_99=REMAIN_J_99 - V_QTY,
        REMAIN_DATE=SYSDATE
   WHERE REMAIN_YEAR='2005'
     AND PROD_ID=V_PROD;
     
  DBMS_OUTPUT.PUT_LINE(V_PROD||'상품 재고수량 변동 :');
END;  

(EVENT가 INSERT인 경우)
'a001'회원이 상품 'P101000003'을 5개 구매한 경우
INSERT INTO CART 
  VALUES('a001', '2021041200001', 'P101000003', 5);
  
SELECT * FROM REMAIN 
  WHERE REMAIN_YEAR='2005'
    AND PROD_ID='P101000003';
    
(EVENT가 UPDATE인 경우)
UPDATE CART
  SET CART_QTY=10
 WHERE CART_NO = '2021041200001'
   AND CART_PROD = 'P101000003';

COMMIT;

(DELETE가 EVENT인 경우)
DELETE CART 
 WHERE CART_NO='2021041200001'
   AND CART_PROD='P101000003';

SELECT * FROM REMAIN 
  WHERE REMAIN_YEAR='2005'
    AND PROD_ID='P101000003';

UPDATE MEMBER
  SET PROD_MILEAGE=19
 WHERE PROD_ID='P202000001';
 
UPDATE PROD
  SET PROD_MILEAGE=ROUND(PROD_PRICE*0.01);
COMMIT;


문제)'f001'회원이 오늘 상품 'P202000001'을 15개 구매했을 때
     이 정보를 cart테이블에 저장한 후 재고수불 테이블과 회원테이블(마일리지)를 
     변경하는 트리거를 작성하시오.
--CART, MEMBER, PROD
CREATE OR REPLACE TRIGGER MEMBER
  AFTER 
               









  












      
      
