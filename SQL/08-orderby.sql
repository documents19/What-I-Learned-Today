-- 08-orderby.sql
USE lecture;
-- 특정 column을 기준으로 정렬함
-- ASC 오름차순 | DESC 내림차순
SELECT * FROM students;

-- 이름 ㄱㄴㄷ 순으로 정렬 (기본Default 정렬 방식 = ASC )
SELECT * FROM students ORDER BY name;
SELECT * FROM students ORDER BY name ASC;
SELECT * FROM students ORDER BY name DESC;

-- 테이블 구조 변경 > column 추가 > grade VARCHAR(1) > 기본값 'B' 
ALTER TABLE students ADD COLUMN grade VARCHAR(1) DEFAULT('B');
-- 데이터 변경. id 1~3 A / id 9~11 C
UPDATE students SET grade = 'A' WHERE id BETWEEN 1 AND 3;
UPDATE students SET grade = 'C' WHERE id BETWEEN 9 AND 11;

-- 다중 컬럼 정렬 > 앞에서 말한 게 우선 정렬
SELECT * FROM students ORDER BY
	age ASC,
    grade DESC;
SELECT * FROM students ORDER BY
	grade DESC,
    age ASC;

-- 나이 40 미만 학생 중에서 학점 순, 나이 많은 순으로 상위 5명 뽑기
SELECT * FROM students 
	WHERE age < 40
	ORDER BY grade, 
    age DESC
    LIMIT 5;
