-- 1-5
-- 각 장르별 트랙 수 집계

-- 각 장르(genres.name)별로 트랙 수를 집계하고, 트랙 수 내림차순으로 정렬하세요.

SELECT
	genres.name,
	COUNT(tracks.track_id)
FROM tracks
JOIN genres ON tracks.genre_id=genres.genre_id
GROUP BY genres.name
ORDER BY COUNT(tracks.track_id) DESC;