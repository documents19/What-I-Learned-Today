-- 26-cross-join.sql

-- 카르테시안 곱(모든 경우의 수 조합)

SELECT 
	c.customer_name,
    p.product_name,
    p.category,
    p.selling_price
FROM customers c
CROSS JOIN products p -- on이 필요없음.. 그냥 냅다 모든 경우의 수를 가져오는 것이기 때문에
WHERE c.customer_type = 'VIP'
ORDER BY C.customer_name, P.category;

-- 구매하지 않은 상품 추천

SELECT

FROM customers c
CROSS JOIN produtcs p -- VIP고객이며, 구매하지 않은 상품만
WHERE c.customer_type = 'VIP'
AND NOT EXISTS (
	SELECT 1 
    FROM sales s
    WHERE s.customer_id = c.customer_id
    AND s,product.id = p.product_id
 );
 
SELECT 1 FROM sales WHERE id=0;

 