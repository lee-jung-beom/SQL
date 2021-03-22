SELECT * FROM emp;

SELECT lprod.lprod_gu, lprod.lprod_nm 
FROM lprod, prod 
WHERE lprod.lprod_gu = prod.prod_lgu;

SELECT * FROM prod;

SELECT *
FROM lprod;

데이터 결합(join2)
erd다이어그램을 참고하여 buyer, prod 테이블을 조인하여 buyer별 담당하는 제품 정보를 다음과 같은 결과가 나오도록 퀴리를 작성하시오.
SELECT buyer.buyer_id, buyer.buyer_name, prod.prod_id, prod.prod_name
FROM buyer, prod
WHERE prod.prod_buyer = buyer.buyer_id;


데이터 결합(join3)
erd 다이어그램을 참고하여 member, cart, prod테이블을 조인하여 회원별 장바구니에 담은 제품 정보를 다음과 같은 결과가 나오는 쿼리를 작성해보세요.
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, prod, cart   
WHERE member.mem_id = cart.cart_member AND cart_prod = prod_id;

SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member)
            JOIN prod ON(cart.cart_prod = prod.prod_id);
            
SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM cycle;

SELECT * 
FROM customer, cycle;
WHERE
customer.cid = cycle.pid;
--customer.cnm IN('brown', 'sally');
SELECT * 
FROM customer, cycle;
WHERE customer.cid IN(1, 2) AND customer.cid = cycle.cid;

join4)
SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid;
AND cycle.pid = product.pid
AND customer.cnm IN ('brown', 'sally');

----------------------------------------
SELECT * 
FROM dba_users;

ALTER USER hr ACCOUNT UNLOCK;
ALTER USER hr IDENTIFIED BY java;
---------------------------------------

OUTER JOIN: 컬럼 연결이 실패해도 (기준)이 되는 테이블 쪽의 컬럼 정보는 나오도록 조인
LEFT OUTER JOIN: 기준이 왼쪽에 기술한 테이블이 되는 OUTER_JOIN
RIGHT OUTER JOIN: 기준이 오른쪽에 기술한 테이블이 되는 OUTER_JOIN
FULL OUTER JOIN: LEFT OUTER + RIGHT OUTER - 중복 데이터 제거 <-사용빈도는 떨어진다

테이블1 JOIN 테이블2
테이블1 LEFT OUTER JOIN 테이블2
==
테이블2 RIGHT OUTER JOIN 테이블1

직원의 이름, 직원의 상사 이름 두개의 컬럼이 나오도록 join query 작성
13건(KING이 안나와도 괜찮음)

SELECT e.ename, m.ename 
FROM emp e, emp m
WHERE e.mgr = m.empno;

--ORACLE SQL OUTER JOIN 표기 : (+)
--OUTER 조인으로 인해 데이터가 안나오는 쪽 컬럼에 (+)을 붙여준다
SELECT e.name, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

SELECT e.name, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(empno AND m.deptno = 10);

SELECT e.ename, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;

SELECT e.ename, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

SELECT e.ename, m.ename, m.deptno
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno);

SELECT e.ename, m.ename, m.deptno
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno);

SELECT * FROM emp;

--FULL OUTER : LEFT OUTER + RIGHT OUTER - 중복 데이터 1개만 남기고 제거
SELECT e.name, m.ename 
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);

--FULL OUTER 조인은 오라클 SQL 문법으로 제공하지 않는다
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr(+) = m.empno(+);

outerjoin1)
SELECT *
FROM buyprod;

SELECT *
FROM buyprod
WHERE buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD');

모든 제품을 다 보여주고, 실제 구매가 있을 때는 구매수량을 조회, 없을 경우는 null로 표현

데이터 결합(outer join 실습 outerjoin1)
buyprod테이블에 구매일자가 2005년 1월 25일인 데이터는 3품목 밖에 없다.
모든 품목이 나올 수 있또록 쿼리를 작성 해보세요
>
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON(buyprod.buy_prod = prod.prod_id AND buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD'));

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod
FROM buyprod.boy_prod(+) =  RIGHT OUTER JOIN prod ON(buyprod.buy_prod = prod.prod_id AND buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD'));
