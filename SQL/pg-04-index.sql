-- pg-04-index.sql

-- 인덱스 조회
SELECT
	tablename,
	indexname,
	indexdef
FROM pg_indexes
WHERE tablename IN('large_orders', 'large_customers')

-- 실제 운영에서는 X (캐시 날리기)
SELECT pg_stat_reset();

EXPLAIN ANALYZE
SELECT * FROM large_orders
WHERE customer_id = 'CUST-25000'; -- 37506 /145.545ms

EXPLAIN ANALYZE
SELECT * FROM large_orders
WHERE amount between 800000 AND 1000000; -- 46296 / 192.534ms

EXPLAIN ANALYZE
SELECT * FROM large_orders -- 14310 / 142ms
WHERE region = '서울' AND amount > 500000 AND order_date >= '2024-07-08';

EXPLAIN ANALYZE
SELECT * FROM large_orders
WHERE region = '서울'
ORDER BY amount DESC -- 39823 / 157.941ms
LIMIT 100;


CREATE INDEX idx_orders_customer_id ON large_orders (customer_id);
CREATE INDEX idx_orders_amount ON large_orders(amount);
CREATE INDEX idx_orders_region ON large_orders(region);

EXPLAIN ANALYZE
SELECT * FROM large_orders
WHERE customer_id = 'CUST-10254'; -- 67 / 0,04ms

EXPLAIN ANALYZE
SELECT * FROM large_orders
WHERE amount between 800000 AND 1000000; -- 46296 / 192.534ms
-- 인덱스가 성능을 그다지 끌어올리지 못하는 경우 

EXPLAIN ANALYZE
SELECT COUNT(*) FROM large_orders WHERE region ='서울'; -- 37655 / 100ms
SELECT COUNT(*) FROM large_orders WHERE region ='서울'; -- 3574 / 11ms


-- 복합 인덱스 추가

CREATE INDEX idx_orders_region_amount ON large_orders(region,amount);

EXPLAIN ANALYZE
SELECT * FROM large_orders
WHERE region = '서울' AND amount > 800000; -- 247ms  -> 129ms



CREATE INDEX idx_orders_id_order_date ON large_orders(customer_id, order_date);

EXPLAIN ANALYZE
SELECT * FROM large_orders
WHERE customer_id = 'CUST-25000.'
	AND order_date >= '2024-07-01'
ORDER BY order_date DESC;



-- 복합 인덱스 순서의 중요도

CREATE INDEX idx_orders_region_amount ON large_orders(region, amount);
CREATE INDEX idx_orders_amount_region ON large_orders(amount, region);

SELECT 
    indexname,
    pg_size_pretty(pg_relation_size(indexname::regclass)) AS index_size
FROM pg_indexes 
WHERE tablename = 'large_orders' 
  AND indexname LIKE '%region%amount%' OR indexname LIKE '%amount%region%'
ORDER BY indexname;


-- 인덱스 순서의 가이드라인

-- 고유값 비율

SELECT
	COUNT(DISTINCT region) AS 고유지역수,
	COUNT(*) AS 전체행수,
	ROUND(COUNT(DISTINCT region) * 100 / COUNT(*), 2) AS 선택도
FROM large_orders;  -- 0.0007%

SELECT
	COUNT(DISTINCT amount) AS 고유금액수,
	COUNT(*) AS 전체행수
FROM large_orders;  -- 선택도 99%

SELECT
	COUNT(DISTINCT customer_id) AS 고유고객수,
	COUNT(*) AS 전체행수
FROM large_orders;  -- 선택도 13.6%

