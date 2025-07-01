-- p05.sql

USE practice;
SHOW TABLES;
SELECT * FROM userinfo;

ALTER TABLE userinfo ADD COLUMN age INT DEFAULT 20;
UPDATE userinfo SET age=30 WHERE id BETWEEN 1 and 5;

-- 이름 오름차순 상위 3명
SELECT * FROM userinfo ORDER BY nickname LIMIT 3;
-- email이 gmail인 사람 나이 순 정렬
SELECT * FROM userinfo WHERE email LIKE '%@gmail.com' ORDER BY age DESC;
-- 나이 많은 사람들 중 핸드폰 번호 오름차순 3명의 이름, 전화번호, 나이만 확인
SELECT nickname, phone, age FROM userinfo ORDER BY age DESC, phone LIMIT 3; 
-- 이름 오름차순인데 이름이 가장 빠른 사람 1명을 제외한 3명만 조회 >>페이지네이션 기능을 만들 때에 주로 씀 (스크롤 할 때마다 페이지가 바뀌고 이전 데이터가 없어지는)
SELECT * FROM userinfo ORDER BY nickname 
	LIMIT 3 
	OFFSET 1;