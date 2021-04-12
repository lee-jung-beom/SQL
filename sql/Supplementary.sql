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
