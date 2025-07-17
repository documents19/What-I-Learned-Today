-- 2-5
-- 각 고객의 최근 구매 내역

-- 각 고객별로 가장 최근 인보이스(invoice_id, invoice_date, total) 정보를 출력하세요.

SELECT 
  c.customer_id,
  i.invoice_id,
  i.invoice_date,
  i.total
FROM invoices i
JOIN customers c ON c.customer_id = i.customer_id
WHERE i.invoice_date = (
	SELECT MAX(i.invoice_date)
	FROM invoices i
	WHERE c.customer_id = i.customer_id
);



SELECT 
	customer_id, 
	invoice_id, 
	invoice_date, 
	total
FROM (
    SELECT
        customer_id,
        invoice_id,
        invoice_date,
        total,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY invoice_date DESC) AS rn
    FROM invoices
) t
WHERE rn = 1;

