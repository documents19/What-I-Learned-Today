-- 14-group-by.sql

-- 카테고리별 매출 (피벗테이블 행=카테고리, 값=매출액)
SELECT
	category AS 카테고리,
    COUNT(*) AS 주문건수,
    SUM(total_amount) AS 총매출,
    AVG(total_amount) AS 평균매출
FROM sales
GROUP BY category
ORDER BY 총매출 DESC;

-- 지역별 매출 분석
SELECT
	region AS 지역,
    COUNT(*) AS 주문건수,
    SUM(total_amount) AS 매출액,
    -- 지역별 고객 수
	COUNT(DISTINCT customer_id) AS 고객수,
    COUNT(*) / COUNT(DISTINCT customer_id) AS 고객당주문수,
    -- 고객당 평균 매출
    ROUND (SUM(total_amount) / COUNT(DISTINCT customer_id)
    ) AS 고객당평균매출
FROM sales
GROUP BY region;

-- 다중 Grouping
SELECT
	region as 지역,
    category as 카테고리,
    count( * )  AS 주문건수,
	SUM(total_amount) AS 총매출액,
    ROUND(AVG(total_amount)) AS 평균매출액
FROM sales
GROUP BY region, category
ORDER BY 지역, 총매출액 DESC;

-- 영업사원(sales_rep) 월별 성과
SELECT
	sales_rep AS 사원,
    DATE_FORMAT(order_date, '%Y-%m') AS 월,
    SUM(total_amount) AS 월매출액,
    ROUND(AVG(total_amount)) AS 월평균매출액
FROM sales
GROUP BY sales_rep, DATE_FORMAT(order_date, '%Y-%m')
ORDER BY 월, 월매출액 DESC;

-- 월별 매출 트렌드
SELECT
	DATE_FORMAT(order_date, '%Y-%m') AS 월,
    COUNT(*) AS 주문건수,
    SUM(total_amount) AS 월매출액,
    COUNT(DISTINCT customer_id) AS 월활성화고객수
FROM sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m');

-- 요일별 매출 패턴
SELECT
	DAYNAME(order_date) AS 요일,
    DAYOFWEEK(order_date) AS 요일번호,
    COUNT(*) AS 주문건수,
    SUM(total_amount) AS 총매출액,
    ROUND(AVG(total_amount)) AS 평균매출액
FROM sales
GROUP BY DAYNAME(order_date), DAYOFWEEK(order_date)
ORDER BY 총매출액 DESC;