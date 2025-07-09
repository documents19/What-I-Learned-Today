-- pg-07-recursive-cte.sql

-- recursive : 재귀

WITH RECURSIVE numbers AS(
	-- 초기값
	SELECT 1 AS num
	-- 
	UNION ALL
	-- 재귀 부분
	SELECT num+1
	FROM numbers
	WHERE num <10
)
SELECT * FROM numbers;


SELECT * FROM employees;

WITH RECURSIVE org_chart AS(
	SELECT
		employee_id,
		employee_name,
		manager_id,
		department,
		1 AS 레벨,
		employee_name::text AS 조직구조
	FROM employees e
	WHERE manager_id IS NULL
	UNION ALL
	SELECT
		e.employee_id,
		e.employee_name,
		e.manager_id,
		e.department,
		oc.레벨 + 1,
		(oc.조직구조 || '>>' || e.employee_name)::text
	FROM employees e
	INNER JOIN org_chart oc ON e.manager_id=oc.employee_id
	-- WHERE manager_id IS NULL (이미 앞에 입력됨)
)
SELECT * FROM org_chart
ORDER BY 레벨;
