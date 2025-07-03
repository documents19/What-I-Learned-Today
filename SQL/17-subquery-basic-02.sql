-- 17-subquery-basic-02.sql

USE lecture;
-- Scala -> 한 개의 데이터
-- Vecor -> 한 줄로 이루어진 데이터
-- Matrix -> 행과 열로 이루어진 데이터
SELECT * FROM customers;

-- 모든 VIP의 id
SELECT customer_id FROM customers WHERE customer_type = 'VIP';

-- 모든 VIP의 주문 내역
SELECT * FROM sales
WHERE customer_id IN(
	SELECT customer_id FROM customers 
    WHERE customer_type = 'VIP'
    );

-- 전자제품을 구매한 모든 고객들의 주문

SELECT * FROM sales
WHERE customer_id IN(
	SELECT DISTINCT customer_id FROM sales 
    WHERE category = '전자제품'
    ); -- ORDER BY customer_id, total_amount;로 좀 더 보기 좋게 정리 가능

