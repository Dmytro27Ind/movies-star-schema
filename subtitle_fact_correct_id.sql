DROP TABLE IF EXISTS subtitle_fact_union;

CREATE TABLE subtitle_fact_union AS
SELECT * FROM subtitle_fact_un;

--------------------------------------------------------------------------------------
----                     DISTINCT DIRECTOR WITH CORRECT ID                    --------
--------------------------------------------------------------------------------------

DROP VIEW IF EXISTS distinct_director_sub CASCADE;

CREATE VIEW distinct_director_sub AS
SELECT DISTINCT * FROM
(SELECT director_full_name, director_gender, director_year_of_birth FROM subtitle_fact_un
ORDER BY director_full_name) as all_director
WHERE director_full_name IS NOT NULL AND director_full_name != ''
ORDER BY director_full_name;

-- SELECT * FROM distinct_director_sub;

DROP TABLE IF EXISTS director_correct_id_sub;

CREATE TABLE director_correct_id_sub(
    director_id SERIAL PRIMARY KEY,
    director_full_name TEXT,
    director_gender CHARACTER(1),
    director_year_of_birth NUMERIC
);

INSERT INTO director_correct_id_sub(director_full_name, director_gender, director_year_of_birth)
SELECT director_full_name, director_gender, director_year_of_birth FROM distinct_director_sub;

-- SELECT * FROM director_correct_id_sub;


----------------------------------------------------------------------------------------
------                    DISTINCT SCENARIST WITH CORRECT ID                    --------
----------------------------------------------------------------------------------------

DROP VIEW IF EXISTS distinct_scenarist_sub CASCADE;

CREATE VIEW distinct_scenarist_sub AS
SELECT DISTINCT * FROM
(SELECT scenarist_full_name, scenarist_gender, scenarist_year_of_birth FROM subtitle_fact_un
ORDER BY scenarist_full_name) as all_scenarist
WHERE scenarist_full_name IS NOT NULL AND scenarist_full_name != ''
ORDER BY scenarist_full_name;

-- SELECT * FROM distinct_scenarist_sub;

DROP TABLE IF EXISTS scenarist_correct_id_sub;

CREATE TABLE scenarist_correct_id_sub(
    scenarist_id SERIAL PRIMARY KEY,
    scenarist_full_name TEXT,
    scenarist_gender CHARACTER(1),
    scenarist_year_of_birth NUMERIC
);

INSERT INTO scenarist_correct_id_sub(scenarist_full_name, scenarist_gender, scenarist_year_of_birth)
SELECT scenarist_full_name, scenarist_gender, scenarist_year_of_birth FROM distinct_scenarist_sub;

-- SELECT * FROM scenarist_correct_id_sub;

----------------------------------------------------------------------------------------
------                    DISTINCT TIME WITH CORRECT ID                         --------
----------------------------------------------------------------------------------------

DROP VIEW IF EXISTS distinct_time_sub CASCADE;

CREATE VIEW distinct_time_sub AS
SELECT DISTINCT * FROM
(SELECT time_year, time_month, time_date FROM subtitle_fact_un
ORDER BY time_year) as all_time
ORDER BY time_year;

-- SELECT * FROM distinct_time_sub;

DROP TABLE IF EXISTS time_correct_id_sub;

CREATE TABLE time_correct_id_sub(
    time_id SERIAL PRIMARY KEY,
    time_year NUMERIC,
    time_month NUMERIC,
    time_date NUMERIC
);

INSERT INTO time_correct_id_sub(time_year, time_month, time_date)
SELECT time_year, time_month, time_date FROM distinct_time_sub;

-- SELECT * FROM time_correct_id_sub;

------------------------------------------------------------------------------------------
--------                    DISTINCT GENRE WITH CORRECT ID                        --------
------------------------------------------------------------------------------------------

DROP VIEW IF EXISTS distinct_genre_sub CASCADE;

CREATE VIEW distinct_genre_sub AS
SELECT DISTINCT * FROM
(SELECT genre_name FROM subtitle_fact_un
ORDER BY genre_name) as all_genre
ORDER BY genre_name;

-- SELECT * FROM distinct_genre;

DROP TABLE IF EXISTS genre_correct_id_sub;

CREATE TABLE genre_correct_id_sub(
    genre_id SERIAL PRIMARY KEY,
    genre_name TEXT
);

INSERT INTO genre_correct_id_sub(genre_name)
SELECT lower(genre_name) FROM distinct_genre_sub;

-- SELECT * FROM genre_correct_id_sub;

------------------------------------------------------------------------------------------
--------                    DISTINCT MOVIE WITH CORRECT ID                        --------
------------------------------------------------------------------------------------------

DROP VIEW IF EXISTS distinct_movie_sub CASCADE;

CREATE VIEW distinct_movie_sub AS
SELECT DISTINCT * FROM
(SELECT movie_id, movie_name, movie_country FROM subtitle_fact_un
ORDER BY movie_id) as all_movie
ORDER BY movie_id;

-- SELECT * FROM distinct_movie_sub;

DROP TABLE IF EXISTS movie_correct_id_sub;

CREATE TABLE movie_correct_id_sub(
    movie_id SERIAL PRIMARY KEY,
    movie_name TEXT,
    movie_country TEXT
);

INSERT INTO movie_correct_id_sub(movie_name, movie_country)
SELECT movie_name, movie_country FROM distinct_movie_sub;

-- SELECT * FROM movie_correct_id_sub;


------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--------                        MOVIE FACT WITH CORRECT MOVIE ID                  --------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

UPDATE subtitle_fact_union AS mfu
SET movie_id = mci.movie_id
FROM movie_correct_id_sub AS mci
WHERE mfu.movie_name = mci.movie_name AND (mfu.movie_country = mci.movie_country OR (mfu.movie_country IS NULL AND mci.movie_country IS NULL));

------------------------------------------------------------------------------------------
--------                        MOVIE FACT WITH CORRECT GENRE ID                  --------
------------------------------------------------------------------------------------------

UPDATE subtitle_fact_union AS mfu
SET genre_id = gci.genre_id,
    genre_name = gci.genre_name
FROM genre_correct_id_sub AS gci
WHERE lower(mfu.genre_name) = gci.genre_name;

------------------------------------------------------------------------------------------
--------                        MOVIE FACT WITH CORRECT SCENARIST ID             --------
------------------------------------------------------------------------------------------

DO $$
declare
    loop_count integer;
begin 
    raise notice 'Sart: %',now();
    SELECT count(DISTINCT movie_id)/100 FROM subtitle_fact_union into loop_count;
    raise notice 'loop count: %', loop_count;
    for i in 1..loop_count loop
        raise notice 'i: %', i;
        UPDATE subtitle_fact_union AS mfu
        SET scenarist_id = sci.scenarist_id
        FROM scenarist_correct_id_sub AS sci
        WHERE (mfu.scenarist_full_name = sci.scenarist_full_name OR (mfu.scenarist_full_name IS NULL AND sci.scenarist_full_name IS NULL))
            AND (mfu.scenarist_gender = sci.scenarist_gender OR (mfu.scenarist_gender IS NULL AND sci.scenarist_gender IS NULL))
            AND (mfu.scenarist_year_of_birth = sci.scenarist_year_of_birth OR (mfu.scenarist_year_of_birth IS NULL AND sci.scenarist_year_of_birth IS NULL))
            AND (mfu.movie_id > (i-1)*100  AND mfu.movie_id <= i*100);
    end loop;
    DELETE FROM subtitle_fact_union WHERE movie_id > (loop_count * 100); 
end;
$$;

------------------------------------------------------------------------------------------
--------                        MOVIE FACT WITH CORRECT DIRECTOR ID               --------
------------------------------------------------------------------------------------------

DO $$
declare
    loop_count integer;
begin 
    raise notice 'Sart: %',now();
    SELECT count(DISTINCT movie_id)/100 FROM subtitle_fact_union into loop_count;
    raise notice 'loop count: %', loop_count;
    for i in 1..loop_count loop
        raise notice 'i: %', i;
        UPDATE subtitle_fact_union AS mfu
        SET director_id = dci.director_id
        FROM director_correct_id_sub AS dci
        WHERE (mfu.director_full_name = dci.director_full_name OR (mfu.director_full_name IS NULL AND dci.director_full_name IS NULL))
            AND (mfu.director_gender = dci.director_gender OR (mfu.director_gender IS NULL AND dci.director_gender IS NULL))
            AND (mfu.director_year_of_birth = dci.director_year_of_birth OR (mfu.director_year_of_birth IS NULL AND dci.director_year_of_birth IS NULL))
            AND (mfu.movie_id > (i-1)*100  AND mfu.movie_id <= i*100);
    end loop;
    DELETE FROM subtitle_fact_union WHERE movie_id > (loop_count * 100); 
end;
$$;

------------------------------------------------------------------------------------------
--------                        MOVIE FACT WITH CORRECT TIME ID                   --------
------------------------------------------------------------------------------------------

ALTER TABLE subtitle_fact_union 
DROP COLUMN time_id;
ALTER TABLE subtitle_fact_union 
ADD COLUMN time_id INTEGER;

DROP TABLE IF EXISTS subtitle_fact_union_old;
ALTER TABLE subtitle_fact_union RENAME TO subtitle_fact_union_old;

CREATE TABLE subtitle_fact_union AS (
SELECT language_id, language_code, 
    time_id, time_year, time_month, time_date,
    movie_id, movie_name, movie_country,
    scenarist_id, scenarist_full_name, scenarist_gender, scenarist_year_of_birth,
    director_id, director_full_name, director_gender, director_year_of_birth,
    genre_id, genre_name,
    word_count, number_of_replicas, number_of_characters
FROM subtitle_fact_union_old
ORDER BY movie_id);

UPDATE subtitle_fact_union AS mfu
SET time_id = tci.time_id
FROM time_correct_id_sub AS tci
WHERE (mfu.time_year = tci.time_year OR (mfu.time_year IS NULL AND tci.time_year IS NULL))
    AND (mfu.time_month = tci.time_month OR (mfu.time_month IS NULL AND tci.time_month IS NULL))
    AND (mfu.time_date = tci.time_date OR (mfu.time_date IS NULL AND tci.time_date IS NULL));


---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------