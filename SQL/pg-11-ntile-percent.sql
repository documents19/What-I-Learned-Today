-- pg-11-ntile-percent.sql

-- NTILE : 균등하게 나누기 (ex: NTILE(4) -- 4등분)
-- (ex: NTILE(4) OVER (ORDER BY 총구매금액) AS 4분위)

WITH customer_totals AS(
	SELECT
		customer_id,
		SUM(amount) AS 총구매금액,
		COUNT(*) AS 구매횟수
	FROM orders
	GROUP BY customer_id
),
customer_grade AS(
	SELECT 
		customer_id,
		총구매금액,
		구매횟수,
		NTILE(4) OVER (ORDER BY 총구매금액) AS 분위수4
	FROM customer_totals
	ORDER BY 총구매금액 DESC
)
SELECT 
	c.customer_name,
	cg.총구매금액,
	cg.구매횟수,
	CASE
		WHEN 분위수4=1 THEN 'D'
		WHEN 분위수4=2 THEN 'C'
		WHEN 분위수4=3 THEN 'B'
		WHEN 분위수4=4 THEN 'A'
	END AS 고객등급
FROM customer_grade cg
INNER JOIN customers c ON cg.customer_id=c.customer_id;


--PERCENT_RANK()
SELECT
	product_name,
	category,
	price,
	RANK() OVER (ORDER BY price) AS 가격순위,
	PERCENT_RANK() OVER(ORDER BY price) AS 백분위순위,
	CASE
		WHEN PERCENT_RANK() OVER (ORDER BY price) >= 0.9 THEN '최고가(상위 10%)'
		WHEN PERCENT_RANK() OVER (ORDER BY price) >= 0.7 THEN '고가(상위 30%)'
		WHEN PERCENT_RANK() OVER (ORDER BY price) >= 0.3 THEN '중간가(상위 70%)'
		ELSE '저가(하위 30%)'
	END AS 가격등급
FROM products;


-- PARTITION의 최고 최저 윈도우 함수
SELECT
	category,
	product_name, 
	price,
	FIRST_VALUE(product_name) OVER(
		PARTITION BY category
		ORDER BY price DESC
	) AS 최고가상품명,
	FIRST_VALUE(price) OVER(
		PARTITION BY category
		ORDER BY price DESC
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS 최고가격,
		LAST_VALUE(product_name) OVER(
		PARTITION BY category
		ORDER BY price DESC
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS 최저가상품명,
		LAST_VALUE(price) OVER(
		PARTITION BY category
		ORDER BY price DESC
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS 최저가격
FROM products;