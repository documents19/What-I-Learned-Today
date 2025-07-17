-- 3-4
-- 국가별 재구매율(Repeat Rate)

-- 각 국가별로 전체 고객 수, 2회 이상 구매한 고객 수, 재구매율을 구하세요.
-- 결과는 재구매율 내림차순 정렬.

SELECT * FROM invoices;


	SELECT
		billing_country,
		COUNT(DISTINCT customer_id) AS customer_number
	FROM invoices
	GROUP BY billing_country;
