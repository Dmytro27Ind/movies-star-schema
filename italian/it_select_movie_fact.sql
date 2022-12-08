-- actor_id, actor_full_name, actor_gender, actor_year_of_birth,
-- time_id, time_year, time_month, time_date
-- movie_id, movie_name, movie_country,
-- genre_id, genre_name,
-- scenarist_id, scenarist_full_name, scenarist_gender, scenarist_year_of_birth,
-- director_id, director_full_name, director_gender, director_year_of_birth,
-- budget, number_of_votes, rating, duration

DROP VIEW IF EXISTS movie_person CASCADE;

CREATE VIEW movie_person AS (SELECT mp."movieID", mp."personID", p."primaryName", p.role
FROM public."moviesPersons" as mp, public.persons as p
WHERE mp."personID" = p.id
ORDER BY "movieID" ASC, "personID" ASC);

-- SELECT * FROM movie_person;

DROP VIEW IF EXISTS all_persons CASCADE;

CREATE VIEW all_persons AS (SELECT scenarist."movieID",
    scenarist."personID" as scenarist_id, scenarist."primaryName" as scenarist_full_name,
    director."personID" as director_id, director."primaryName" as director_full_name,
    actor."personID" as actor_id, actor."primaryName" as actor_full_name
FROM movie_person as scenarist
INNER JOIN movie_person as director
ON scenarist."movieID" = director."movieID"
INNER JOIN movie_person as actor
ON scenarist."movieID" = actor."movieID"
WHERE scenarist.role = 'SCENARIST' AND director.role = 'DIRECTOR' AND actor.role = 'ACTOR');

-- SELECT * FROM all_persons;

DROP VIEW IF EXISTS movie_fact_data CASCADE;

CREATE VIEW movie_fact_data AS (SELECT
    movies.published as time_id,
    EXTRACT(year FROM movies.published) as time_year,
    EXTRACT(month FROM movies.published) as time_month,
    EXTRACT(day FROM movies.published) as time_date,
    movies.id as movie_id,
    movies.name as movie_name,
    null as movie_country,
    genres.id as genre_id,
    genres.name as genre_name,
    movies.budget, movies.votes as number_of_votes, movies.rating, movies.duration
FROM public.movies, public."movieGenres", public.genres
WHERE
    "movieGenres"."movieID" = movies.id AND genres.id = "movieGenres"."genreID"
ORDER BY movies.id ASC);

-- SELECT * FROM movie_fact_data;

DROP TABLE IF EXISTS movie_fact CASCADE;

CREATE TABLE movie_fact AS
SELECT CAST(mfd.time_id AS DATE), mfd.time_year, mfd.time_month, mfd.time_date,
    CAST(mfd.movie_id AS INTEGER), CAST(mfd.movie_name AS TEXT), mfd.movie_country,
    CAST(ap.actor_id AS INTEGER), ap.actor_full_name, CAST(null AS character(1)) as actor_gender, CAST(null AS NUMERIC) as actor_year_of_birth,
    CAST(ap.scenarist_id AS INTEGER), ap.scenarist_full_name, CAST(null AS character(1)) as scenarist_gender, CAST(null AS NUMERIC) as scenarist_year_of_birth,
    CAST(ap.director_id AS INTEGER), ap.director_full_name, CAST(null AS character(1)) as director_gender, CAST(null AS NUMERIC) as director_year_of_birth,
    CAST(mfd.genre_id AS INTEGER), CAST(mfd.genre_name AS TEXT),
    mfd.budget, mfd.number_of_votes, mfd.rating, mfd.duration
FROM movie_fact_data as mfd
INNER JOIN all_persons as ap ON ap."movieID" = mfd.movie_id;

-- SELECT * FROM movie_fact LIMIT 100;