--실습 문제
8)
SELECT r.region_id, r.region_name, c.country_name  
FROM regions r INNER JOIN countries c ON(r.region_id = c.region_id AND r.region_name = 'Europe');

9)
SELECT r.region_id, r.region_name, c.country_name, l.city
FROM countries c, regions r, locations l;
--WHERE r.region_name = 'Europe';

3)
