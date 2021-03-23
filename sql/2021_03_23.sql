outerjoin2

SELECT TO_DATE('yyyymmdd', 'YYYY/MM/DD'), buy_prod, prod_id, prod_name, NVL(buy_qty, 0)
FROM buyprod, prod;

SELECT * FROM cycle;
SELECT * FROM product;


outerjoin4
cycle, product 테이블을 이용하여 고객이 애응하는 제품 명칭을 표현하고, 애음하지 않는 제품도 다음과 같이 조회되도록 쿼리를 작성하세요
(고객은 cid=1인 고객만 나오도록 제한, null처리)
SELECT p.*, 1, c.cid, c.day, c.cnt
FROM product p LEFT OUTER JOIN cycle c ON(p.pid = c.pid AND cid = 1); 

SELECT p.*, :cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
FROM product p cycle c
WHERE p.pid = c.pid(+)
AND cid(+) = :cid;

실습5 과제
WHERE, GROUP BY(그룹핑), JOIN

JOIN
문법
 : ANSI / ORACLE
논리적 형태
 : SELF JOIN, NON-EQUI-JOIN
연결조건 성공 실패에 따라 조회여부 결정
 : OUTERJOIN <==> INNER JOI: 연결이 성공적으로 이루어진 행에 대해서만 조회가 되는 조인
 
SELECT *
FROM dept JOIN emp ON (dept.deptno = emp.deptno);


CROSS JOIN
.별도의 연결조건이 없는 조인
.묻지마 조인
.두 테이블의 행간 연결 가능한 모든 경우의 수로 연결
==> CROSE JOIN의 결과는 두 테이블의 행의 수를 곱한 값과 같은 행이 반환된다

[.데이터 복제를 위해 사용]

SELECT * 
FROM emp CROSS JOIN dept;

데이터 결합(cross join실습 crossjoin1)
.customer, product테이블을 이용하여 고객이 애음 가능한 모든 제품의 정보를 결합하여 다음과 같이 조회되도록 쿼리를 작성하세요
SELECT *
FROM customer c CROSS JOIN product c;

SELECT STORECATEGORY 
FROM burgerstore
WHERE SIDO = '대전'
GROUP BY STORECATEGORY;

--대전 중구의 버거 지수
SELECT 
도시발전지수 : (kfc + 맥도날드 + 버거킹) / 롯데리아

SELECT *
FROM BURGERSTORE
WHERE SIDO = '대전'
AND SIGUNGU = '중구';

SELECT *
FROM BURGERSTORE;

--문제----------------------------
SELECT SIDO, SIGUNGU, 도시발전지수
FROM BURGERSTORE
WHERE SIDO = '대전'
AND SIGUNGU = '중구';
----------------------------------
----------------------
ALTER TABLE BURGERSTORE ADD urbanDevelopment BINARY_FLOAT;
----------------------
SELECT SIDO, SIGUNGU
FROM BURGERSTORE
WHERE SIDO = '대전'
AND SIGUNGU = '중구';


SELECT SUM(STORECATEGORY), b.SIDO, b.SIGUNGU
FROM BURGERSTORE b
GROUP BY SIDO, SIGUNGU;

SELECT STORECATEGORY, COUNT(STORECATEGORY), '대전' SIDO, '중구' SIGUNGU
FROM BURGERSTORE b
GROUP BY STORECATEGORY
HAVING ;
--GROUP BY STORECATEGORY
--HAVING SUM(COLINT('BURGER KING' STORECATEGORY) AND COLINT('KFC' STORECATEGORY));


--행을 컬럼으로 변경(PIVOT)
SELECT sido, sigungu,
    (SUM(DECODE(storecategory, 'BURGER KING', 1, 0)) bk,
    SUM(DECODE(storecategory, 'KFC', 1, 0)) kfc,
    SUM(DECODE(storecategory, 'MACDONALD', 1, 0)) ) /
    DECODE(SUM(DECODE(storecategory, 'LOTTERIA', 1, 0)) idx
--CASE WHEN storecategory = 'BURGER KING' THEN 1
--ELSE 0
--END bk
--storecategory가 burger king 이면 1, 0
--storecategory가 kfc 이면 1, 0
--storecategory가 macdonald 이면 1, 0
--storecategory가 lotteria 이면 1, 0
FROM burgerstore
GROUP BY sido, sigungu
ORDER BY sido, sigungu;



