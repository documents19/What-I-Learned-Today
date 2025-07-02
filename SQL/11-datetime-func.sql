-- 11-datetime-func.sql

USE lecture;
SELECT * FROM dt_demo;

-- 현재 날짜/시간
-- 날짜+시간
SELECT NOW() AS 지금시간;
SELECT CURRENT_TIMESTAMP;

-- 날짜
SELECT CURDATE();
SELECT CURRENT_DATE;

-- 시간
SELECT CURTIME();
SELECT CURRENT_TIME;

SELECT 
	name,
	birth AS 원본,
	DATE_FORMAT(birth, '%Y년 %m월 %m일') AS 한국식,
	DATE_FORMAT(birth, '%Y-%m') AS 년월,
	DATE_FORMAT(birth, '%M %d, %Y') AS 영문식,
	DATE_FORMAT(birth, '%w') AS 요일번호,
	DATE_FORMAT(birth, '%W') AS 요일이름
FROM dt_demo; -- 실제 데이터베이스는 년-월-일 (- 표시) 형식으로 저장됨... 그러나 %이니셜응 활용해 다양하게 표현 가능

SELECT 
	created_at AS 원본시간,
    DATE_FORMAT(created_at, '%Y-%m-%d %H:%i') AS 분까지만,
    DATE_FORMAT(created_at, '%p %h:%i') AS 12시간
FROM dt_demo;

-- 날짜 계산 함수
SELECT
	name,
    birth,
    DATEDIFF(CURDATE(), birth) AS 살아온날들,
    -- TIMESTAMPDIFF(결과 단위, 날짜 1, 날짜 2)
    TIMESTAMPDIFF(YEAR, birth, CURDATE()) AS 나이
FROM dt_demo;

-- 더하기/빼기
SELECT
	name, birth,
    DATE_ADD(birth, INTERVAL 100 DAY) AS 백일후,
    DATE_ADD(birth, INTERVAL 1 YEAR) AS 돌,
    DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AS 한달전
FROM dt_demo;

-- 예: 계정 생성 후 경과 시간
SELECT 
	name, created_at,
    TIMESTAMPDIFF(HOUR, created_at, NOW()) AS 가입후시간,
    TIMESTAMPDIFF(DAY, created_at, NOW()) AS 가입후일수
FROM dt_demo;

-- 날짜 추출
SELECT 
	name, 
    birth, -- birth -> DATE정보
    YEAR(birth),
    MONTH(birth),
    DAY(birth),
    DAYOFWEEK(birth) AS 요일번호,
    DAYNAME(birth) AS 요일,
	QUARTER(birth) AS 분기
FROM dt_demo;

-- 월별, 연도별
SELECT
	YEAR(birth) AS 출생년도,
    COUNT(*) AS 인원수
FROM dt_demo
GROUP BY YEAR(birth)
ORDER BY 출생년도;