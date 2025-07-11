-- pg-08-windows.sql
-- windows 함수 --> OVER() 구문

-- 전체구매액 평균
SELECT AVG(amount) FROM orders;

-- 고객별 구매액 평균
SELECT
	customer_id,
	AVG(amount)
FROM orders
GROUP BY customer_id;

-- 각 데이터와 전체 평균을 동시에 확인

SELECT
	order_id,
	customer_id,
	amount,
	AVG(amount) OVER() AS 전체평균
FROM orders
LIMIT 10;



-- ROW_NUMBER() -> 줄세우기 [ROW_NUMBER() OVER(ORDER BY 정렬기준)]
-- 주문 금액이 높은 순서로
SELECT
	order_id,
	customer_id,
	amount,
	ROW_NUMBER() OVER (ORDER BY amount DESC) AS 번호
FROM orders
ORDER BY 번호
LIMIT 20 OFFSET 20;

-- 주문 날짜가 최신인 순서대로 번호 매기기
SELECT
	order_id,
	customer_id,
	order_date,
	ROW_NUMBER() OVER(ORDER BY order_date DESC) AS 최신주문,
	RANK() OVER (ORDER BY order_date DESC) AS 랭크,
	DENSE_RANK() OVER(ORDER BY order_date DESC) AS 덴스랭크
FROM orders
ORDER BY 최신주문
LIMIT 20;


-- 7월 매출 top3 고객 찾기
-- [이름, (해당고객)7월구매액, 순위]
-- CTE

-- 1. 고객별 7월의 총구매액 구하기 [고객id, 총구매액]
WITH july_sales AS(
	SELECT
		customer_id,
		SUM(amount) AS 월구매액
	FROM orders
	WHERE order_date BETWEEN '2024-07-01' AND '2024-07-31'
	GROUP BY customer_id
),
-- 2. 기존 컬럼에 번호 붙이기 [고객id, 이름, 구매액, 순위]
ranking AS(
	SELECT
		customer_id,
		월구매액,
		ROW_NUMBER() OVER(ORDER BY 월구매액) AS 순위
	FROM july_sales
)
-- 3. 보여주기
SELECT 
	r.customer_id,
	c.customer_name,
	r.월구매액,
	r.순위
FROM ranking r 
INNER JOIN customers c ON r.customer_id=c.customer_id
WHERE r.순위 <10;

	



-- 각 지역에서 총구매액 1위 고객 ->> ROW_NUMBER()로 숫자를 매기고, 컬럼의 값이 1인 사람
-- [지역, 고객이름, 총구매액]
-- CTE

-- 1.지역-사람별 "매출데이터" 생성 [지역, 고객id, 이름, 해당 고객의 총 매출]

WITH 매출데이터 AS (SELECT 
		c.region AS 지역,
		c.customer_id AS 고객id,
		c.customer_name AS 고객이름,
		SUM(o.amount) AS 고객별총매출
	FROM customers c
	INNER JOIN orders o ON c.customer_id=o.customer_id
	GROUP BY c.customer_id
),
-- 2. "매출데이터"에 새로운 열(ROW_NUMBER) 추가
지역별순위 AS(
	SELECT
		지역,
		고객이름,
		고객별총매출,
		ROW_NUMBER() OVER(PARTITION BY 지역 ORDER BY 고객별총매출 DESC) AS 지역순위
	FROM 매출데이터
)
-- 3. 최종데이터 표시
SELECT
	지역,
	고객이름,
	고객별총매출,
	지역순위
FROM 지역별순위
WHERE 지역순위 < 4; -- 1~3위