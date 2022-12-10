-- language_id, language_code
-- time_id, time_year, time_month, time_date
-- movie_id, movie_name, movie_country, 
-- genre_id, genre_name,
-- scenarist_id, scenarist_full_name, scenarist_gender, scenarist_year_of_birth,
-- director_id, director_full_name, director_gender, director_year_of_birth,
-- word_count, number_of_replicas, number_of_characters

DROP VIEW IF EXISTS subtitle_fact_data;

CREATE VIEW subtitle_fact_data AS
SELECT DISTINCT * FROM
(SELECT
    2 as language_id, 'cs' as language_code,
    time_id, time_year, time_month, time_date,
    movie_id, movie_name, movie_country, 
    genre_id, genre_name,
    scenarist_id, scenarist_full_name, scenarist_gender, scenarist_year_of_birth,
    director_id, director_full_name, director_gender, director_year_of_birth
FROM movie_fact_cs) AS mfc;

-- SELECT * FROM subtitle_fact_data;

DROP VIEW IF EXISTS subtitle_fact_count_data;

CREATE VIEW subtitle_fact_count_data AS
SELECT sub.id_film as movie_id,
    sum(line.word_count) as word_count,
    count(*) as number_of_replicas,
    sum(length(line.text)) as number_of_characters
FROM subtitle as sub, line
WHERE sub.id_subtitle = line.id_subtitle AND sub.id_film <= 1000
GROUP BY movie_id
ORDER BY sub.id_film;

-- SELECT * FROM subtitle_fact_count_data;

DROP TABLE IF EXISTS subtitle_fact_cs;

CREATE TABLE subtitle_fact_cs AS
SELECT 
    sfd.language_id, sfd.language_code,
    sfd.time_id, sfd.time_year, sfd.time_month, sfd.time_date,
    sfd.movie_id, sfd.movie_name, sfd.movie_country, 
    sfd.scenarist_id, sfd.scenarist_full_name, sfd.scenarist_gender, sfd.scenarist_year_of_birth,
    sfd.director_id, sfd.director_full_name, sfd.director_gender, sfd.director_year_of_birth,
    sfd.genre_id, sfd.genre_name,
    sfcd.word_count, sfcd.number_of_replicas , sfcd.number_of_characters
FROM subtitle_fact_data AS sfd
INNER JOIN subtitle_fact_count_data as sfcd ON sfcd.movie_id = sfd.movie_id;

SELECT * FROM subtitle_fact_cs;