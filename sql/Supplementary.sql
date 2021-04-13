--보충수업
EXTRA-LECTURE 01)
1. ROLLUP
  - GROUP BY절과 같이 사용하여 추가적인 집계정보를 제공함
  - 명시한 표현식의 수와 순서(오른쪽에서 왼쪽 순)에 따라 레벨별로 집계한 
    결과를 반환함
  - 표현식이 n개 사용된 경우 n+1 가지의 집계 반환
  (사용형식)
  SELECT 컬럼list
    FROM 테이블명
   WHERE 조건
   GROUP BY [컬럼명] ROLLUP(컬럼명1, 컬럼명2,....컬럼명n]
   . ROLLUP 안에 기술된 컬럼명1, 컬럼명2,....컬럼명n을 오른쪽부터 왼쪽순으로 
     레벨화 시키고 그것을 기준으로한 집계결과 반환
     
사용예)우리나라 광역시도의 대출현황테이블에서 기간별(년), 지역별 구분별
      잔액합계를 조회하시오
  (GROUP BY 절 사용)      
  SELECT SUBSTR(PERIOD,1,4) AS "기간별(년)", 
         REGION AS 지역별,
         GUBUN AS 구분별,
         SUM(LOAN_JAN_AMT) AS 잔액합계      
    FROM KOR_LOAN_STATUS
   GROUP BY SUBSTR(PERIOD,1,4),REGION,GUBUN
   ORDER BY 1;
     
(ROLLUP 사용)     
SELECT SUBSTR(PERIOD,1,4) AS "기간별(년)", 
         REGION AS 지역별,
         GUBUN AS 구분별,
         SUM(LOAN_JAN_AMT) AS 잔액합계      
    FROM KOR_LOAN_STATUS
   GROUP BY ROLLUP(SUBSTR(PERIOD,1,4),REGION,GUBUN)
   ORDER BY 1;      
   
2. CUBE
  - GROUP BY 전과 같이 사용하여 추가적인 집계정보를 제공함
  - CUBE절 안에 사용된 컬럼의 조합가능한 가지수 만큼의 집계반환
(CUBE 사용)
SELECT SUBSTR(PERIOD,1,4) AS "기간별(년)", 
         REGION AS 지역별,
         GUBUN AS 구분별,
         SUM(LOAN_JAN_AMT) AS 잔액합계      
    FROM KOR_LOAN_STATUS
   GROUP BY CUBE(SUBSTR(PERIOD,1,4),REGION,GUBUN)
   ORDER BY 1; 
   
(부분 ROLLUP)
SELECT SUBSTR(PERIOD,1,4) AS "기간별(년)", 
         REGION AS 지역별,
         GUBUN AS 구분별,
         SUM(LOAN_JAN_AMT) AS 잔액합계      
    FROM KOR_LOAN_STATUS
   GROUP BY SUBSTR(PERIOD,1,4), ROLLUP(REGION,GUBUN)
   ORDER BY 1; 
   
   
   
2021-0413-01)조인
  - 다수개의 테이블로부터 필요한 자료 추출
  - rdbms에서 가장 중요한 연산
  1. 내부조인
    . 조인조건을 만족하지 않는 행은 무시
  예) 상품테이블에서 상품의 분류별 상품의 수를 조회하시오
      Alias는 분류코드, 분류명, 상품의 수 
**상품테이블에서 사용한 분류코드의 종류    
SELECT DISTINCT PROD_LGU
  FROM PROD;
    
SELECT A.LPROD_GU AS 분류코드, 
       A.LPROD_NM AS 분류명,
       COUNT(*) AS "상품의 수" 
    FROM LPROD A, PROD B
  WHERE LPROD_GU=PROD_LGU
  GROUP BY A.LPROD_GU, A.LPROD_NM
  ORDER BY 1;
  
예) 2005년 5월 매출자료와 거래처 테이블을 이용하여 거래처별 상품매출정보를 
    조회하시오
    Alias는 거래처코드, 거래처명, 매출액
        
SELECT B.PROD_BUYER AS 거래처코드, 
       C.BUYER_NAME AS 거래처명, 
       SUM(A.CART_QTY*B.PROD_PRICE) AS 매출액
   FROM CART A, PROD B, BUYER C  
  WHERE A.CART_PROD=B.PROD_ID
    AND B.PROD_BUYER=C.BUYER_ID
    AND A.CART_NO LIKE '200505%'
  GROUP BY B.PROD_BUYER, C.BUYER_NAME
  ORDER BY 1;
  
SELECT 
FROM CART, PROD, BUYER
WHERE 
  
  
(ANSI 내부조인)
SELECT 컬럼list
    FROM 테이블명
  INNER JOIN 테이블명2(조인조건
  [AND 일반조건])
  INNER JOIN 테이블명3 (조인조건
  [AND 일반조건])
        :
  WHERE 조건;
  
문제1) 2005년 1월~3월 거래처별 매입정보를 조회하시오
       Alias는 거래처코드, 거래처명, 매입금액합계이고
       매입금액 합계가 500만원 이상인 거래처만 검색하시오.
--거래날짜정보 컬럼: CART_NO       
SELECT B.PROD_BUYER AS 거래처코드, 
       C.BUYER_NAME AS 거래처명, 
       SUM() AS 매입금액합계
    FROM CART C, PROD P, BUYER B
    WHERE C.CART_PROD = P.PROD_ID
      AND P.PROD_LGU = B.BUYER_LGU
    GROUP BY C.BUYER_NAME
    HAVING 

    
       
문제2) 사원테이블(EMPLOYEES)에서 부서별 평균급여보다 급여를 많이 받는 
       직원들의 수를 부서별로 조회하시오.
       Alias는 부서코드, 부서명, 부서평균급여, 인원수
















  
 
  
   
