CREATE VIEW all_movies AS
SELECT
    null as time_id,
    film.release_year::NUMERIC as time_year,
    null as time_month,
    null as time_date,
    film.id::INTEGER as movie_id,
    film.title::TEXT as movie_name,
    country.name::TEXT as movie_country,

    actor.person_id::INTEGER as actor_id,
    full_actor.whole_name::TEXT as actor_full_name,
    CASE
        WHEN full_actor.gender_id = 1 THEN 'M'::CHARACTER
        WHEN full_actor.gender_id = 2 THEN 'F'::CHARACTER
        ELSE null
    END as actor_gender,
    null as actor_year_of_birth,

    scenarist.person_id::INTEGER as scenarist_id,
    full_scenarist.whole_name::TEXT as scenarist_full_name,
    CASE
        WHEN full_scenarist.gender_id = 1 THEN 'M'::CHARACTER
        WHEN full_scenarist.gender_id = 2 THEN 'F'::CHARACTER
        ELSE null
    END as scenarist_gender,
    null as scenarist_year_of_birth,

    director.person_id::INTEGER as director_id,
    full_director.whole_name::TEXT as director_full_name,
    CASE
        WHEN full_director.gender_id = 1 THEN 'M'::CHARACTER
        WHEN full_director.gender_id = 2 THEN 'F'::CHARACTER
        ELSE null
    END as director_gender,
    null as director_year_of_birth,

    genre.id::INTEGER as genre_id,
    genre.name::TEXT as genre_name,
    economy.budget::DOUBLE PRECISION as budget,
    rating.votes::INTEGER as number_of_votes,
    rating.rank::REAL as rating,
    film.duration::INTEGER as duration
FROM film

    LEFT JOIN film_country ON film.id = film_country.film_id
    LEFT JOIN country ON film_country.country_id = country.id

    LEFT JOIN film_person actor ON film.id = actor.film_id AND actor.department = 'Actors'
    LEFT JOIN person full_actor ON actor.person_id = full_actor.id
    LEFT JOIN film_person director ON film.id = director.film_id AND director.department = 'Directing'
    LEFT JOIN person full_director ON director.person_id = full_director.id
    LEFT JOIN film_person scenarist ON film.id = scenarist.film_id AND scenarist.department = 'Writing'
    LEFT JOIN person full_scenarist ON scenarist.person_id = full_scenarist.id

    LEFT JOIN film_genre fg ON film.id = fg.film_id
    LEFT JOIN genre genre ON fg.genre_id = genre.id

    LEFT JOIN economy ON film.economy_id = economy.id
    LEFT JOIN rating ON film.id = rating.film_id;

CREATE INDEX sub_index ON subsubtitle(subtitle_id);

DROP VIEW IF EXISTS all_subtitles;

CREATE VIEW all_subtitles AS
SELECT
    null as time_id,
    all_movies.time_year as time_year,
    null as time_month,
    null as time_date,
    subtitle.film_id as movie_id,
    all_movies.movie_name as movie_name,
    all_movies.movie_country as movie_country,
    all_movies.scenarist_id as scenarist_id,
    all_movies.scenarist_full_name as scenarist_name,
    all_movies.scenarist_gender as scenarist_gender,
    null as scenarist_year_of_birth,
    all_movies.director_id as director_id,
    all_movies.director_full_name as director_name,
    all_movies.director_gender as director_gender,
    null as director_year_of_birth,
    all_movies.genre_id as genre_id,
    all_movies.genre_name as genre_name,
    subtitle.total_words as word_count,
    CASE
        WHEN (SELECT count(*) FROM subsubtitle WHERE subsubtitle.subtitle_id = subtitle.id) > 0 THEN (SELECT count(*) FROM subsubtitle WHERE subsubtitle.subtitle_id = subtitle.id)
        ELSE null
    END as number_of_replicas,
    (SELECT sum(length(subsubtitle.text)) FROM subsubtitle WHERE subsubtitle.subtitle_id = subtitle.id) as number_of_characters
FROM subtitle
LEFT JOIN all_movies ON subtitle.film_id = all_movies.movie_id;

DROP TABLE IF EXISTS movie_fact_en;

CREATE TABLE movie_fact_en AS
SELECT 
    CAST(am.time_id AS DATE), am.time_year, CAST(am.time_month AS NUMERIC), CAST(am.time_date AS NUMERIC),
    am.movie_id, am.movie_name, am.movie_country,
    am.actor_id, am.actor_full_name, CAST(am.actor_gender AS character(1)), CAST(am.actor_year_of_birth AS NUMERIC),
    am.scenarist_id, am.scenarist_full_name, CAST(am.scenarist_gender AS character(1)), CAST(am.scenarist_year_of_birth AS NUMERIC),
    am.director_id, am.director_full_name, CAST(am.director_gender AS character(1)), CAST(am.director_year_of_birth AS NUMERIC),
    am.genre_id, am.genre_name,
    am.budget, CAST(am.number_of_votes AS BIGINT), am.rating, am.duration
FROM all_movies as am
WHERE am.movie_id <= 4000;

SELECT * FROM movie_fact_en;

DROP TABLE IF EXISTS subtitle_fact_en;

CREATE TABLE subtitle_fact_en AS
SELECT 
    3 as language_id, 'en' as language_code,
    CAST(time_id AS DATE), time_year, CAST(time_month AS NUMERIC), CAST(time_date AS NUMERIC),
    CAST(movie_id AS INTEGER), movie_name, movie_country, 
    scenarist_id, scenarist_name as scenarist_full_name, scenarist_gender, CAST(scenarist_year_of_birth AS NUMERIC),
    director_id, director_name as director_full_name, director_gender, CAST(director_year_of_birth AS NUMERIC),
    genre_id, genre_name,
    CAST(word_count as BIGINT), number_of_replicas , number_of_characters
FROM all_subtitles
WHERE movie_id <= 4000
ORDER BY movie_id;