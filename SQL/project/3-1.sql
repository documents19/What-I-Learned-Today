-- 3-1
--월별 매출 및 전월 대비 증감률

-- 각 연월(YYYY-MM)별 총 매출과, 전월 대비 매출 증감률을 구하세요.
-- 결과는 연월 오름차순 정렬하세요.

WITH monthly_sales AS (
  SELECT 
    DATE_TRUNC('month', invoice_date) AS monthly, 
    SUM(total) AS sales,
    LAG(SUM(total)) OVER (ORDER BY DATE_TRUNC('month', invoice_date)) AS prev_sales
  FROM invoices 
  GROUP BY DATE_TRUNC('month', invoice_date)
)
SELECT 
  monthly,
  sales,
  ROUND((sales - prev_sales) * 100.0 / prev_sales, 2) AS monthly_rate
FROM monthly_sales
ORDER BY monthly;


