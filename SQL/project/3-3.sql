-- 3-3
-- 고객별 누적 구매액 및 등급 산출

-- 각 고객의 누적 구매액을 구하고,
-- 상위 20%는 'VIP', 하위 20%는 'Low', 나머지는 'Normal' 등급을 부여하세요.

SELECT * FROM customers;
SELECT * FROM invoices;

WITH customer_purchase AS(
	SELECT
		customer_id,
		SUM(total) OVER(ORDER BY invoice_date) AS purchase_amount
	FROM invoices
)
SELECT
	customer_id,
	purchase_amount,
	CASE
		WHEN PERCENT_RANK() OVER (ORDER BY purchase_amount DESC) <=0.2 THEN 'VIP'
		WHEN PERCENT_RANK() OVER (ORDER BY purchase_amount DESC) <=0.8 THEN 'Normal'
		ELSE 'Low'
	END AS customer_rank
FROM customer_purchase;