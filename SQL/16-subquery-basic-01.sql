-- 16-subquery-basic-01.sql
USE lecture;

-- 매출 평균보다 높은 금액을 주문한 판매데이터(*) 
SELECT avg(total_amount) FROM sales;
SELECT * FROM sales 
WHERE total_amount > 61282; -- 위 지시문으로 직접 계산한값

-- 서브쿼리
SELECT * FROM sales
WHERE total_amount > (SELECT AVG(total_amount) FROM sales); -- 쿼리 안에 쿼리를 만드는 방식

SELECT
	product_name AS 이름,
    total_amount AS 판매액,
    total_amount - (SELECT AVG(total_amount) FROM sales) AS 평균차이
FROM sales
WHERE total_amount > (SELECT AVG(total_amount) FROM sales); -- 평균보다 더 주문한

-- 데이터가 하나 나오는 경우
SELECT AVG(quantity) FROM sales;
-- 데이터가 여러 개 나오는 경우
SELECT * FROM sales;

-- sales에서 가장 큰 금액 주문 건
SELECT * FROM sales
WHERE total_amount=(SELECT MAX(total_amount) FROM sales);

-- 가장 최근 주문일의 데이터
SELECT * FROM sales
WHERE order_date = (SELECT MAX(order_date) FROM sales);
-- SELECT * FROM sales 
-- WHERE DATEDIFF(CURDATE(),order_date) =(SELECT MIN(DATEDIFF(CURDATE(),order_date)) FROM sales);

-- 주문액수 평균과 유사한 주문데이터 5개
SELECT * FROM sales
ORDER BY ABS(
			(SELECT AVG(total_amount) FROM sales) - total_amount
            )
LIMIT 5;