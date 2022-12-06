-- language_id, code
-- time_id, time_year, time_month, time_date
-- movie_id, movie_name, movie_country,
-- genre_id, genre_name,
-- scenarist_id, scenarist_full_name, scenarist_gender, scenarist_year_of_birth,
-- director_id, director_full_name, director_gender, director_year_of_birth,
-- word_count, number_of_replicas, number_of_characters

DROP TABLE IF EXISTS language;
CREATE TABLE language(
    language_id INT         NOT NULL PRIMARY KEY,
    code        VARCHAR(2)  NOT NULL
);
INSERT INTO language VALUES ('1', 'it');

-- SELECT * FROM language;

DROP VIEW IF EXISTS movie_person CASCADE;

CREATE VIEW movie_person AS (SELECT mp."movieID", mp."personID", p."primaryName", p.role
FROM public."moviesPersons" as mp, public.persons as p
WHERE mp."personID" = p.id
ORDER BY "movieID" ASC, "personID" ASC);

-- SELECT * FROM movie_person;

DROP VIEW IF EXISTS all_persons CASCADE;

CREATE VIEW all_persons AS (SELECT scenarist."movieID",
    scenarist."personID" as scenarist_id, scenarist."primaryName" as scenarist_name,
    director."personID" as director_id, director."primaryName" as director_name
FROM movie_person as scenarist
INNER JOIN movie_person as director
ON scenarist."movieID" = director."movieID"
WHERE scenarist.role = 'SCENARIST' AND director.role = 'DIRECTOR');

-- SELECT * FROM all_persons;

DROP VIEW IF EXISTS subtitles_count_data CASCADE;

CREATE VIEW subtitles_count_data AS (SELECT sub."movieID" as movie_id,
    sum(array_length(regexp_split_to_array(sub.text, '\s'),1)) as word_count,
    count(*) as number_of_replicas,
    sum(length(sub.text)) as number_of_characters
FROM subtitles as sub
GROUP BY sub."movieID");

-- SELECT * FROM subtitles_count_data;

DROP VIEW IF EXISTS subtitle_fact_data CASCADE;

CREATE VIEW subtitle_fact_data AS (SELECT
    movies.published as time_id,
    EXTRACT(year FROM movies.published) as time_year,
    EXTRACT(month FROM movies.published) as time_month,
    EXTRACT(day FROM movies.published) as time_date,
    movies.id as movie_id,
    movies.name as movie_name,
    null as movie_country,
    genres.id as genre_id,
    genres.name as genre_name
FROM public.movies, public."movieGenres", public.genres
WHERE
    "movieGenres"."movieID" = movies.id AND genres.id = "movieGenres"."genreID"
ORDER BY movies.id ASC);

-- SELECT * FROM subtitle_fact_data;

DROP TABLE IF EXISTS subtitles_fact CASCADE;

CREATE TABLE subtitles_fact AS
SELECT sfd.time_id, sfd.time_year, sfd.time_month, sfd.time_date,
    sfd.movie_id, sfd.movie_name, sfd.movie_country,
    ap.scenarist_id, ap.scenarist_name, null as scenarist_gender, null as scenarist_year_of_birth,
    ap.director_id, ap.director_name, null as director_gender, null as director_year_of_birth,
    sfd.genre_id, sfd.genre_name,
    scd.word_count,
    scd.number_of_replicas,
    scd.number_of_characters
FROM subtitle_fact_data as sfd
INNER JOIN all_persons as ap ON ap."movieID" = sfd.movie_id
INNER JOIN subtitles_count_data as scd ON scd.movie_id = sfd.movie_id;

SELECT * FROM subtitles_fact;
