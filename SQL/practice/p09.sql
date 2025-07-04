-- p09.sql
 USE practice;
 
 SELECT COUNT(*) FROM sales
 UNION
 SELECT COUNT(*) FROM customers;
 
 -- 주문거래액이 가장 높은 10건을 높은 순으로 고객명, 상품명, 주문금액
 SELECT 
	c.customer_name AS 고객명,
    s.product_name AS 상품명,
    s.total_amount AS 주문금액
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
ORDER BY s.total_amount DESC LIMIT 10;

-- 고객 유형별 고객유형, 주문건수, 평균주문금액을 평균주문금액 높은 순으로 정렬
	-- (참고: INNER JOIN은 구매자들끼리의 평균 / customers LEFT JOIN은 모든 고객을 분석)
 SELECT 
	c.customer_type AS 고객유형,
    COUNT(*) AS 주문건수,
    ROUND(AVG(s.total_amount)) AS 평균주문금액
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_type
ORDER BY 평균주문금액 DESC;

-- 문제 1: 모든 고객의 이름과 구매한 상품명 조회
SELECT 
	c.customer_name as 고객명,
    COALESCE(s.product_name, 'X') as 상품명
FROM customers c
LEFT JOIN sales s ON s.customer_id = c.customer_id
ORDER BY 고객명;

-- 문제 2: 고객 정보와 주문 정보를 모두 포함한 상세 조회
SELECT
	c.customer_name as 고객명,
    c.customer_type as 고객유형,
    c.join_date as 가입일,
    s.product_name as 상품명,
    s.category as 카테고리,
    s.total_amount as 주문금액,
    s.order_date as 주문날짜
FROM customers c
INNER JOIN sales s ON s.customer_id = c.customer_id;


-- 문제 3: VIP 고객들의 구매 내역만 조회
SELECT *
FROM customers c
INNER JOIN sales s ON s.customer_id = c.customer_id
WHERE c.customer_type='VIP'
ORDER BY s.total_amount DESC;

-- 문제 4: 건당 50만원 이상 주문한 기업 고객들
SELECT *
FROM customers c
INNER JOIN sales s ON s.customer_id = c.customer_id
WHERE s.total_amount>=500000 AND c.customer_type='기업';
		-- 고객별 분석을 하기 위해서는 GROUP BY를 사용

-- 문제 5: 2024년 하반기(7월~12월) 전자제품 구매 내역
SELECT *
FROM customers c
INNER JOIN sales s ON s.customer_id = c.customer_id
WHERE category='전자제품' 
	AND s.order_date BETWEEN '2024-07-01' AND '2024-12-31'
ORDER BY s.order_date;

-- 문제 6: 고객별 주문 통계 (INNER JOIN) [고객명, 유형, 주문횟수, 총구매, 평균구매, 최근주문일]
SELECT
	c.customer_name AS 고객명,
    c.customer_type AS 유형,
    COUNT(*) AS 주문횟수,
    SUM(s.total_amount) AS 총구매,
	ROUND(AVG(s.total_amount)) AS 평균구매,
    MAX(s.order_date) AS 최근주문일
FROM customers c
INNER JOIN sales s ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type;

-- 문제 7: 모든 고객의 주문 통계 (LEFT JOIN) - 주문 없는 고객도 포함
SELECT
	c.customer_name AS 고객명,
    c.customer_type AS 유형,
    COALESCE(COUNT(s.id), 0) AS 주문횟수,
    COALESCE(SUM(s.total_amount), 0) AS 총구매,
	COALESCE(ROUND(AVG(s.total_amount)), 0) AS 평균구매,
    COALESCE(MAX(s.order_date), 0) AS 최근주문일
FROM customers c
LEFT JOIN sales s ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type;

-- 문제 8: 카테고리별 고객 유형 분석
SELECT
	c.customer_type AS 유형,
	s.category AS 카테고리,
	COUNT(*) AS 주문건수,
	SUM(s.total_amount)
FROM customers c
INNER JOIN sales s ON s.customer_id = c.customer_id
GROUP BY s.category, c.customer_type
ORDER BY c.customer_type, s.category;

-- 문제 9: 고객별 등급 분류
-- 활동등급(구매횟수) : [0(잠재고객) < 브론즈 < 3 <= 실버 < 5 <= 골드 < 10 <= 플래티넘]
-- 구매등급(구매총액) : [0(신규) < 일반 <= 10만 < 우수 <= 20만 < 최우수 < 50만 <= 로얄]
SELECT
	c.customer_id, 
    c.customer_name, 
    c.customer_type,
    COUNT(s.id) AS 구매횟수,
    COALESCE(SUM(s.total_amount),0) AS 총구매액,
	CASE
		WHEN COUNT(s.id) = 0 THEN '브론즈'
        WHEN COUNT(s.id) >= 10 THEN '플래티넘'
        WHEN COUNT(s.id) >= 5 THEN '골드'
        WHEN COUNT(s.id) >= 3 THEN '실버'
        ELSE '브론즈'
    END AS 활동등급,
    CASE
		WHEN COALESCE(SUM(s.total_amount),0) >=500000 THEN '로얄'
        WHEN COALESCE(SUM(s.total_amount),0) >=200000 THEN '최우수'
        WHEN COALESCE(SUM(s.total_amount),0) >=100000 THEN '우수'
        WHEN COALESCE(SUM(s.total_amount),0) >0 THEN '일반'
        ELSE '신규'
    END AS 구매등급
FROM customers c
LEFT JOIN sales s ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type;
-- 문제 10: 활성 고객 분석
-- 고객상태(최종구매일) [NULL(구매없음) | 활성고객 <= 30 < 관심고객 <= 90 관심고객 < 휴면고객]별로
-- 고객수, 총주문건수, 총매출액, 평균주문금액 분석
SELECT
	고객상태,
    COUNT(*) AS 고객수,
    SUM(총주문건수) AS 상태별총주문건수,
    SUM(총매출액) AS 상태별총매출액,
	ROUND(AVG(평균주문금액)) AS 상태별주문금액
FROM(
SELECT 
	c.customer_id ,
	c.customer_name,
	COUNT(s.id) AS 총주문건수,
	COALESCE(SUM(s.total_amount),0) AS 총매출액,
	COALESCE(ROUND(AVG(s.total_amount)),0) AS 평균주문금액
	CASE 
		WHEN MAX(order_date) IS NULL '구매없음'
		WHEN DATEDIFF('2023-12-31', MAX(s.order_date)) <= '30' THEN '활성고객'
		WHEN DATEDIFF('2023-12-31', MAX(s.order_date)) <= '90' THEN '관심고객'
		ELSE '휴면고객'
	END AS 고객상태
FROM customers c
LEFT JOIN sales s ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name)
AS customer_analysis
;