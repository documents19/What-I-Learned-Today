-- p02.sql

-- practice db 이동
USE practice;
-- userinfo 테이블에 진행
DESC userinfo;

-- 데이터 5건 넣기 (별명, 핸드폰) > 별명 bob을 포함 (C)
INSERT INTO userinfo (nickname, phone) VALUES
	('갑갑갑', '01011112222'),
    ('을을을', '01022223333'),
    ('병병병', '01033334444'),
    ('bob', '01055556666'),
    ('신신신', '01000000000');
-- 전체 조회 (실행하며 지속적으로 모니터링) (R)
SELECT * FROM userinfo;
-- id가 3인 사람 조회 (R)
SELECT * FROM userinfo WHERE id=3;
-- 별명이 bob인 사람을 조회 (R)
SELECT * FROM userinfo WHERE nickname='bob';
-- 별명이 bob인 사람의 핸드폰 번호를 01099998888 로 수정 (id로 수정) (U)
UPDATE userinfo SET phone= '01099998888' WHERE id=4;
-- 별명이 bob인 사람 삭제 (id로 수정) (D)
DELETE FROM userinfo WHERE id=4;

