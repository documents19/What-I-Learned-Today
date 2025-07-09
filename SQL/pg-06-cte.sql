-- pg-06-cte.sql


-- 1. 평균 구하기
WITH avg_order AS(
	SELECT AVG(amount) AS avg_amount
	FROM orders
)
-- 2단계: 평균보다 큰 주문 찾기
SELECT c.customer_name, o.amount, ao.avg_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN avg_order ao ON o.amount > ao.avg_amount
LIMIT 10;





-- <연습문제1>
-- 각 지역별 주문한 고객 수(DISTINCT customer_id)와 주문 수

SELECT 
	c.region AS 지역,
	COUNT(DISTINCT c.customer_id) AS 주문고객수,
	COUNT(o.order_id) AS 주문수
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;

-- 지역별 평균 금액 함께 표시

SELECT 
	c.region AS 지역,
	COUNT(DISTINCT c.customer_id) AS 주문고객수,
	COUNT(o.order_id) AS 주문수,
	COALESCE(AVG(o.amount), 0) AS 평균주문금액
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;

-- 고객 수가 많은 지역 순으로 정렬

WITH region_summary AS (
	SELECT 
		c.region AS 지역,
		COUNT(DISTINCT c.customer_id) AS 주문고객수,
		COUNT(o.order_id) AS 주문수,
		COALESCE(AVG(o.amount), 0) AS 평균주문금액
	FROM customers c
	LEFT JOIN orders o ON c.customer_id = o.customer_id
	GROUP BY c.region
)
SELECT
	지역,
	주문고객수,
	주문수,
	ROUND(평균주문금액) AS 평균주문금액
FROM region_summary
ORDER BY 주문고객수 DESC;
-- 다른 사람이 코드를 읽을 때에 훨씬 원활하게 확인 가능


-- <연습문제2>
-- 상품의 총 판매량과 총 매출액

SELECT
	p.category AS 카테고리,
	p.product_name AS 상품명,
	p.price AS 상품가격,
	SUM(o.quantity) AS 총판매량,
	SUM(o.amount) AS 총매출액,
	COUNT(o.order_id) AS 주문건수,
	AVG(o.amount) AS 평균주문금액
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY p.category, p.product_name, p.price;

-- 상품 카테고리 별로 그룹화하여 표시
-- 카테고리 내에서 매출액이 높은 순으로 정렬
-- 상품의 평균 주문 금액 표시

WITH product_sales AS(
	SELECT
		p.category AS 카테고리,
		p.product_name AS 상품명,
		p.price AS 상품가격,
		SUM(o.quantity) AS 총판매량,
		SUM(o.amount) AS 총매출액,
		COUNT(o.order_id) AS 주문건수,
		AVG(o.amount) AS 평균주문금액
	FROM products p
	LEFT JOIN orders o ON p.product_id = o.product_id
	GROUP BY p.category, p.product_name, p.price
)
SELECT
	카테고리,
	상품명,
	총판매량,
	총매출액,
	ROUND(평균주문금액,2) AS 평균주문금액,
	주문건수,
	상품가격
FROM product_sales
ORDER BY 카테고리, 총매출액 DESC;


-- cf)
WITH product_sales AS(
	SELECT
		p.category AS 카테고리,
		p.product_name AS 상품명,
		p.price AS 상품가격,
		SUM(o.quantity) AS 총판매량,
		SUM(o.amount) AS 제품총매출액,
		COUNT(o.order_id) AS 주문건수,
		AVG(o.amount) AS 평균주문금액
	FROM products p
	LEFT JOIN orders o ON p.product_id = o.product_id
	GROUP BY p.category, p.product_name, p.price
),
 category_total AS (
	SELECT
	카테고리,
	SUM(제품총매출액) AS 카테고리총매출액
FROM product_sales
GROUP BY 카테고리
 )
SELECT
	ps.카테고리,
	ps.상품명,
	ps.제품총매출액,
	ct.카테고리총매출액,
	ROUND(ps.제품총매출액 *100 / ct.카테고리총매출액, 2) AS 카테고리매출비중
FROM product_sales ps 
INNER JOIN category_total ct ON ps.카테고리=ct.카테고리
ORDER BY ps.카테고리, ps.제품총매출액 DESC;




--<연습문제3>
-- 고객 구매 금액에 따라 VIP(상위 20%) / 일반 (전체평균보다 높음)/ 신규로 나누어 등급통계를 보자
-- [등급, 등급별 회원 수, 등급별 구매액총합, 등급별평균주문수]

SELECT 
c.customer_id AS 고객,
COALESCE(SUM(o.amount), 0) AS 고객구매금액
FROM customers c
LEFT JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_id;



-- 1. 고객별 총 구매 금액 + 주문수
WITH customer_total AS (
	SELECT
		customer_id,
		SUM(amount) as 총구매액,
		COUNT(*) AS 총주문수
	FROM orders
	GROUP BY customer_id
),
-- 2. 구매 금액 기준 계산
purchase_threshold AS (
	SELECT
		AVG(총구매액) AS 일반기준,
		-- 상위 20% 기준값 구하기
		PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY 총구매액) AS vip기준
	FROM customer_total
),
-- 3. 고객 등급 분류
customer_grade AS (
	SELECT
		ct.customer_id,
		ct.총구매액,
		ct.총주문수,
		CASE 
			WHEN ct.총구매액 >= pt.vip기준 THEN 'VIP'
			WHEN ct.총구매액 >= pt.일반기준 THEN '일반'
			ELSE '신규'
		END AS 등급
	FROM customer_total ct
	CROSS JOIN purchase_threshold pt
)
-- 4. 등급별 통계 출력
SELECT
	등급,
	COUNT(*) AS 등급별고객수,
	SUM(총구매액) AS 등급별총구매액,
	ROUND(AVG(총주문수), 2) AS 등급별평균주문수
FROM customer_grade
GROUP BY 등급;