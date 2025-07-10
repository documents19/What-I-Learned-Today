-- pg-09-partition.sql

-- partition by : 데이터를 특정 그룹으로 나누고 windows 함수로 결과를 확인

SELECT
	region,
	customer_id,
	amount,
	ROW_NUMBER() OVER (ORDER BY amount DESC) AS 전체순위,
	ROW_NUMBER() OVER (PARTITION BY region ORDER BY amount DESC) AS 지역순위
FROM orders LIMIT 10;


-- SUM() OVER
-- 일별 누적 매출액
WITH daily_sales AS(
	SELECT 
		order_date,
		SUM(amount) AS 일매출
	FROM orders
	WHERE order_date BETWEEN '2024-06-01' AND '2024-07-31'
	GROUP BY order_date
	ORDER BY order_date
)
SELECT
	order_date,
	일매출,
	-- 범위 내에서 계속 누적
	SUM(일매출) OVER (ORDER BY order_date) AS 누적매출,
	-- 범위 내에서 partition이 바뀔 때에 초기화
	SUM(일매출) OVER (
		PARTITION BY DATE_TRUNC('month', order_date)
		ORDER BY order_date
	) AS 월누적매출
FROM daily_sales;


-- AVG() OVER()
WITH daily_sales AS(
	SELECT 
		order_date,
		SUM(amount) AS 일매출
	FROM orders
	WHERE order_date BETWEEN '2024-06-01' AND '2024-07-31'
	GROUP BY order_date
	ORDER BY order_date
)
SELECT
	order_date,
	일매출,
	ROUND(AVG(일매출) OVER(
		ORDER BY order_date
	)) AS 일평균,
	ROUND(AVG(일매출) OVER(
		ORDER BY order_date
		ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
	)) AS 이동평균3일	
FROM daily_sales;

-- 이동 평균: 평균을 구하는 범위가 계속 이동, 날짜 기준 n일간의 평균(예:6/3 - 6/1~6/3까지, 6/10 - 6/8~6/10까지)
-- 이동 평균을 구하는 이유: 추세(상승, 하락, 횡보) 파악... 급격한 변동을 줄여 추세의 흐름을 파악하기 쉬움
-- 이동 평균을 활용하여 미래 데이터를 예측해볼 수 있음



-- <연습문제>
-- 카테고리 별 인기 상품(매출순위) TOP 5
-- CTE
-- [상품 카테고리, 상품id, 상품이름, 상품가격, 해당상품의주문건수, 해당상품판매개수, 해당상품총매출]
-- 위에서 만든 테이블에 WINDOW함수 컬럼추가 + [매출순위, 판매량순위]
-- 총데이터 표시(매출순위 1 ~ 5위 기준으로 표시)

WITH product_sales AS (
	SELECT
		p.category,
		p.product_id,
		p.product_name,
		p.price,
		COUNT(o.order_id) AS 주문건수,
		SUM(o.quantity) AS 판매개수,
		SUM(o.amount) AS 총매출
	FROM products p
	LEFT JOIN orders o ON o.product_id=p.product_id
	GROUP BY p.product_id
),
ranked_products AS(
	SELECT 
		*,
		DENSE_RANK() OVER (PARTITION BY category ORDER BY 총매출 DESC) AS 매출순위,
		DENSE_RANK() OVER (PARTITION BY category ORDER BY 판매개수 DESC) AS 판매량순위
	FROM product_sales
)
SELECT
	 category AS 카테고리, 
	 product_name AS 상품명, 
	 price AS 가격, 
	 주문건수, 
	 판매개수, 
	 매출순위, 
	 판매량순위
FROM ranked_products
WHERE 매출순위 <=5;
 