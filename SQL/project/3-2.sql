-- 3-2
-- 장르별 상위 3개 아티스트 및 트랙 수

-- 각 장르별로 트랙 수가 가장 많은 상위 3명의 아티스트(artist_id, name, track_count)를 구하세요.
-- 동점일 경우 아티스트 이름 오름차순 정렬.

WITH artist_album AS(
	SELECT
		ar.artist_id,
		ar.name,
		a.album_id,
		a.title
	FROM artists ar
	JOIN albums a ON ar.artist_id=a.artist_id
),
artist_tracks AS(
	SELECT
		aa.artist_id,
		aa.name AS artist,
		g.name AS genre,
		COUNT(*) AS track_count,
		ROW_NUMBER() OVER(PARTITION BY g.name ORDER BY COUNT(*)DESC, aa.name) AS rank
	FROM tracks t
	JOIN artist_album aa ON t.album_id=aa.album_id
	JOIN genres g ON t.genre_id=g.genre_id
	GROUP BY aa.artist_id, aa.name, g.name
)
SELECT
	artist_id,
	artist,
	genre,
	track_count,
	rank
FROM artist_tracks
WHERE rank <=3;