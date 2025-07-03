-- 18-join.sql
USE lecture;

-- 고객정보 + 주문정보
SELECT
  *,
  (
    SELECT customer_name FROM customers c
    WHERE c.customer_id=s.customer_id
  ) AS 주문고객이름,
  (
    SELECT customer_type FROM customers c
    WHERE c.customer_id=s.customer_id
  ) AS 고객등급
FROM sales s;

-- JOIN
SELECT
  c.customer_name,
  c.customer_type
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
where s.total_amount >= 500000
ORDER BY s.total_amount DESC;

-- 모든 고객의 구매 현황 분석(구매를 하지 않았어도 분석)
SELECT 
	c.customer_id,
    c.customer_name,
    c.customer_type
    FROM customers c
-- LEFT JOIN -> 왼쪽 테이블(c)의 모든 데이터와 + 매칭되는 오른쪽 데이터 | 매칭되는 오른쪽 데이터 (없어도 등장)
LEFT JOIN sales s ON c.customer_id = s.customer_id
  -- WHERE s.id IS NULL; -> 한 번도 주문한 적 없는 사람들이 나옴
  WHERE s.customer_id IS NULL;
 
 SELECT
	c.customer_name,
    c.customer_type,
    COUNT(s.id) AS 구매건수,  -- *을 사용하는 경우 NULL 줄이 생겨 개수를 1개로 세게 됨...
    -- coalesce(첫번째 값, 10) -> 첫번째 값이 NULL인 경우, 10을 쓴다
    COALESCE(SUM(s.total_amount), 0) AS 총구매액,
    COALESCE(AVG(s.total_amount), 0) AS 평균구매액,
    CASE
		WHEN COUNT(s.id) = 0 THEN '잠재고객'
        WHEN COUNT(s.id) >= 5 THEN '충성고객'
        WHEN COUNT(s.id) >= 3 THEN '일반고객'
        ELSE '신규고객'
	END AS 활성도
    FROM customers c
    LEFT JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_id;