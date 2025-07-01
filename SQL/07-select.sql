-- 07-select.sql
-- SELECT column
-- FROM table
-- WHERE 조건
-- ORDER BY 정렬기준
-- LIMIT 개수

USE lecture;

CREATE TABLE students (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20),
    age INT
);
DESC students;
INSERT INTO students (name, age) VALUES 
	('가가가', '30'),
	('나나나', '50'),
    ('다다다', '28'),
    ('라라라', '42'),
	('마마마', '32'),
	('바바바', '44'),
	('사사사', '30'),
	('아아아', '30'),
	('자자자', '50'),
	('가가가', '27');
SELECT * FROM students;
SELECT * FROM students WHERE name='나나나';
SELECT * FROM students WHERE age >= 30; -- 이상
SELECT * FROM students WHERE age > 30; -- 초과
SELECT * FROM students WHERE id <> 1; -- 여집합(해당 조건이 아닌)
SELECT * FROM students WHERE id != 1; -- 여집합(해당 조건이 아닌)

SELECT * FROM students WHERE age BETWEEN 20 AND 40; -- 20 이상, 40 이하

SELECT * FROM students WHERE id IN (1,3,5,7,83); -- 여러 데이터 한 번에