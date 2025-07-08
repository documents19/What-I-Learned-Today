-- pg-03-explain-analyze.sql

-- 실행 계획을 보자
EXPLAIN
SELECT * FROM large_customers WHERE customer_type = 'VIP';

-- "Seq Scan on large_customers  (cost=0.00..3746.00(마지막 행을 가져올 때까지 소모된 비용. 낮을 수록 좋음) rows=10067 width=160(byte))"
-- cost = 점수(낮을 수록 좋음)  |  rows * width = 총 메모리 사용량
-- "  Filter: (customer_type = 'VIP'::text)"

-- 실행+통계
EXPLAIN ANALYZE
SELECT * FROM large_customers WHERE customer_type = 'VIP';

-- "Seq Scan on large_customers  (cost=0.00..3746.00 rows=10067 width=160) (actual time=0.027..11.636 rows=10040 loops=1)"
-- actual time = 실제 소모된 시간(가져오는 데에 걸린 시간)
-- seq scan >> 인덱스 없고, 테이블 대부분의 행을 읽어야 하고, 순차 스캔이 빠를 때에
-- planning time = 예상 시간
-- execution time = 실제 실행~통계까지 진행된 시간



-- EXPLAIN 옵션들

-- 자주 사용하는 데이터는 버퍼에서 가져옴
-- 버퍼 사용량 포함
EXPLAIN(ANALYZE, BUFFERS)
SELECT * FROM large_customers WHERE loyalty_points > 8000;

-- 상세 정보 포함
EXPLAIN(ANALYZE, VERBOSE, BUFFERS)
SELECT * FROM large_customers WHERE loyalty_points > 8000;

-- JSON 형태
EXPLAIN(ANALYZE, VERBOSE, BUFFERS, FORMAT JSON)
SELECT * FROM large_customers WHERE loyalty_points > 8000;


-- 진단 (score is too high)

EXPLAIN ANALYZE
SELECT 
	c.customer_name,
	COUNT(o.order_id)
FROM large_customers c
LEFT JOIN large_orders o ON c.customer_name = o.customer_id -- 잘못된 JOIN 조건으로 시도해보는 중
GROUP BY c.customer_name;

--  메모리 부족

