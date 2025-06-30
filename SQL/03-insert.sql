-- 03-insert.sql

USE lecture;
DESC members;

-- 데이터 입력 (Create)
INSERT INTO members (name, email) VALUES ('유태영', 'yu@a.com');
INSERT INTO members (name, email) VALUES ('김재석', 'kim@a.com');

-- 여러 줄, (col1, col2) 순서 잘 맞추기
INSERT INTO	members (email, name) VALUES
('lee@a.com', '이재필'),
('park@a.com', '장재인');

-- 데이터 전체 조회(Read)
SELECT * FROM members;
-- 데이터 단일 조회
SELECT * FROM members WHERE id=1;