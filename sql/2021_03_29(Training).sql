SELECT *
FROM dept_h;

최상위 노드부터 리프 노드까지 탐색하는 계층 쿼리 작성
(LPAD를 이용한 시각적 표현까지 포함)
SELECT LPAD(' ', (LEVEL -1))||deptnum
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;


SELECT LEVEL, deptcd, LPAD(' ', (LEVEL - 1) * 3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;


SELECT LEVEL, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, 
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT *
FROM h_sum;

SELECT LEVEL,  LPAD(' ', (LEVEL-1) * 4) || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

