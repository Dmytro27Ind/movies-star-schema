-- DROP TABLE IF EXISTS movie_fact_union;

-- CREATE TABLE movie_fact_union AS
-- SELECT * FROM movie_fact_un;

----------------------------------------------------------------------------------------
------                    DISTINCT SCENARIST WITH CORRECT ID                    --------
----------------------------------------------------------------------------------------

-- DROP VIEW IF EXISTS distinct_director CASCADE;

-- CREATE VIEW distinct_director AS
-- SELECT DISTINCT * FROM
-- (SELECT director_full_name, director_gender, director_year_of_birth FROM movie_fact_un
-- ORDER BY director_full_name) as all_director
-- WHERE director_full_name IS NOT NULL AND director_full_name != ''
-- ORDER BY director_full_name;

-- -- SELECT * FROM distinct_director;

-- DROP TABLE IF EXISTS director_correct_id;

-- CREATE TABLE director_correct_id(
--     director_id SERIAL PRIMARY KEY,
--     director_full_name TEXT,
--     director_gender CHARACTER(1),
--     director_year_of_birth NUMERIC
-- );

-- INSERT INTO director_correct_id(director_full_name, director_gender, director_year_of_birth)
-- SELECT director_full_name, director_gender, director_year_of_birth FROM distinct_director;

-- SELECT * FROM director_correct_id;


-- ----------------------------------------------------------------------------------------
-- ------                    DISTINCT SCENARIST WITH CORRECT ID                    --------
-- ----------------------------------------------------------------------------------------

-- DROP VIEW IF EXISTS distinct_scenarist CASCADE;

-- CREATE VIEW distinct_scenarist AS
-- SELECT DISTINCT * FROM
-- (SELECT scenarist_full_name, scenarist_gender, scenarist_year_of_birth FROM movie_fact_un
-- ORDER BY scenarist_full_name) as all_scenarist
-- WHERE scenarist_full_name IS NOT NULL AND scenarist_full_name != ''
-- ORDER BY scenarist_full_name;

-- -- SELECT * FROM distinct_scenarist;

-- DROP TABLE IF EXISTS scenarist_correct_id;

-- CREATE TABLE scenarist_correct_id(
--     scenarist_id SERIAL PRIMARY KEY,
--     scenarist_full_name TEXT,
--     scenarist_gender CHARACTER(1),
--     scenarist_year_of_birth NUMERIC
-- );

-- INSERT INTO scenarist_correct_id(scenarist_full_name, scenarist_gender, scenarist_year_of_birth)
-- SELECT scenarist_full_name, scenarist_gender, scenarist_year_of_birth FROM distinct_scenarist;

-- SELECT * FROM scenarist_correct_id;

-- ----------------------------------------------------------------------------------------
-- ------                    DISTINCT TIME WITH CORRECT ID                         --------
-- ----------------------------------------------------------------------------------------

-- DROP VIEW IF EXISTS distinct_time CASCADE;

-- CREATE VIEW distinct_time AS
-- SELECT DISTINCT * FROM
-- (SELECT time_year, time_month, time_date FROM movie_fact_un
-- ORDER BY time_year) as all_time
-- ORDER BY time_year;

-- -- SELECT * FROM distinct_time;

-- DROP TABLE IF EXISTS time_correct_id;

-- CREATE TABLE time_correct_id(
--     time_id SERIAL PRIMARY KEY,
--     time_year NUMERIC,
--     time_month NUMERIC,
--     time_date NUMERIC
-- );

-- INSERT INTO time_correct_id(time_year, time_month, time_date)
-- SELECT time_year, time_month, time_date FROM distinct_time;

-- SELECT * FROM time_correct_id;

-- ----------------------------------------------------------------------------------------
-- ------                    DISTINCT ACTOR WITH CORRECT ID                        --------
-- ----------------------------------------------------------------------------------------

-- DROP VIEW IF EXISTS distinct_actor CASCADE;

-- CREATE VIEW distinct_actor AS
-- SELECT DISTINCT * FROM
-- (SELECT actor_full_name, actor_gender, actor_year_of_birth FROM movie_fact_un
-- ORDER BY actor_full_name) as all_actor
-- ORDER BY actor_full_name;

-- -- SELECT * FROM distinct_actor;

-- DROP TABLE IF EXISTS actor_correct_id;

-- CREATE TABLE actor_correct_id(
--     actor_id SERIAL PRIMARY KEY,
--     actor_full_name TEXT,
--     actor_gender CHARACTER(1),
--     actor_year_of_birth NUMERIC
-- );

-- INSERT INTO actor_correct_id(actor_full_name, actor_gender, actor_year_of_birth)
-- SELECT actor_full_name, actor_gender, actor_year_of_birth FROM distinct_actor;

-- SELECT * FROM actor_correct_id;

-- ------------------------------------------------------------------------------------------
-- --------                    DISTINCT GENRE WITH CORRECT ID                        --------
-- ------------------------------------------------------------------------------------------

-- DROP VIEW IF EXISTS distinct_genre CASCADE;

-- CREATE VIEW distinct_genre AS
-- SELECT DISTINCT * FROM
-- (SELECT genre_name FROM movie_fact_un
-- ORDER BY genre_name) as all_genre
-- ORDER BY genre_name;

-- -- SELECT * FROM distinct_genre;

-- DROP TABLE IF EXISTS genre_correct_id;

-- CREATE TABLE genre_correct_id(
--     genre_id SERIAL PRIMARY KEY,
--     genre_name TEXT
-- );

-- INSERT INTO genre_correct_id(genre_name)
-- SELECT lower(genre_name) FROM distinct_genre;

-- SELECT * FROM genre_correct_id;

-- ------------------------------------------------------------------------------------------
-- --------                    DISTINCT MOVIE WITH CORRECT ID                        --------
-- ------------------------------------------------------------------------------------------

-- DROP VIEW IF EXISTS distinct_movie CASCADE;

-- CREATE VIEW distinct_movie AS
-- SELECT DISTINCT * FROM
-- (SELECT movie_id, movie_name, movie_country FROM movie_fact_un
-- ORDER BY movie_id) as all_movie
-- ORDER BY movie_id;

-- -- SELECT * FROM distinct_movie;

-- DROP TABLE IF EXISTS movie_correct_id;

-- CREATE TABLE movie_correct_id(
--     movie_id SERIAL PRIMARY KEY,
--     movie_name TEXT,
--     movie_country TEXT
-- );

-- INSERT INTO movie_correct_id(movie_name, movie_country)
-- SELECT movie_name, movie_country FROM distinct_movie;

-- -- SELECT * FROM movie_correct_id;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--------                        MOVIE FACT WITH CORRECT MOVIE ID                  --------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

-- UPDATE movie_fact_union AS mfu
-- SET movie_id = mci.movie_id
-- FROM movie_correct_id AS mci
-- WHERE mfu.movie_name = mci.movie_name AND (mfu.movie_country = mci.movie_country OR (mfu.movie_country IS NULL AND mci.movie_country IS NULL));

------------------------------------------------------------------------------------------
--------                        MOVIE FACT WITH CORRECT GENRE ID                  --------
------------------------------------------------------------------------------------------

-- UPDATE movie_fact_union AS mfu
-- SET genre_id = gci.genre_id,
--     genre_name = gci.genre_name
-- FROM genre_correct_id AS gci
-- WHERE lower(mfu.genre_name) = gci.genre_name;

------------------------------------------------------------------------------------------
--------                        MOVIE FACT WITH CORRECT ACTOR ID                  --------
------------------------------------------------------------------------------------------

-- DO $$
-- declare
--     loop_count integer;
-- begin 
--     raise notice 'Sart: %',now();
--     SELECT count(DISTINCT movie_id)/100 FROM movie_fact_union into loop_count;
--     raise notice 'loop count: %', loop_count;
--     for i in 1..loop_count loop
--         raise notice 'i: %', i;
--         UPDATE movie_fact_union AS mfu
--         SET actor_id = aci.actor_id
--         FROM actor_correct_id AS aci
--         WHERE (mfu.actor_full_name = aci.actor_full_name OR (mfu.actor_full_name IS NULL AND aci.actor_full_name IS NULL))
--             AND (mfu.actor_gender = aci.actor_gender OR (mfu.actor_gender IS NULL AND aci.actor_gender IS NULL))
--             AND (mfu.actor_year_of_birth = aci.actor_year_of_birth OR (mfu.actor_year_of_birth IS NULL AND aci.actor_year_of_birth IS NULL))
--             AND (mfu.movie_id > (i-1)*100  AND mfu.movie_id <= i*100);
--     end loop;
--     DELETE FROM movie_fact_union WHERE movie_id > (loop_count * 100); 
-- end;
-- $$;

------------------------------------------------------------------------------------------
--------                        MOVIE FACT WITH CORRECT TIME ID                   --------
------------------------------------------------------------------------------------------

-- ALTER TABLE movie_fact_union 
-- DROP COLUMN time_id;
-- ALTER TABLE movie_fact_union 
-- ADD COLUMN time_id INTEGER;

-- ALTER TABLE movie_fact_union RENAME TO movie_fact_union_old;

-- CREATE TABLE movie_fact_union AS (
-- SELECT time_id, time_year, time_month, time_date,
--     movie_id, movie_name, movie_country,
--     actor_id, actor_full_name, actor_gender, actor_year_of_birth,
--     scenarist_id, scenarist_full_name, scenarist_gender, scenarist_year_of_birth,
--     director_id, director_full_name, director_gender, director_year_of_birth,
--     genre_id, genre_name,
--     budget, number_of_votes, rating, duration
-- FROM movie_fact_union_old
-- ORDER BY movie_id);

-- UPDATE movie_fact_union AS mfu
-- SET time_id = tci.time_id
-- FROM time_correct_id AS tci
-- WHERE mfu.time_year = tci.time_year AND mfu.time_month = tci.time_month AND mfu.time_date = tci.time_date;

------------------------------------------------------------------------------------------
--------                        MOVIE FACT WITH CORRECT SCENARIST ID             --------
------------------------------------------------------------------------------------------

-- DO $$
-- declare
--     loop_count integer;
-- begin 
--     raise notice 'Sart: %',now();
--     SELECT count(DISTINCT movie_id)/100 FROM movie_fact_union into loop_count;
--     raise notice 'loop count: %', loop_count;
--     for i in 1..loop_count loop
--         raise notice 'i: %', i;
--         UPDATE movie_fact_union AS mfu
--         SET scenarist_id = sci.scenarist_id
--         FROM scenarist_correct_id AS sci
--         WHERE (mfu.scenarist_full_name = sci.scenarist_full_name OR (mfu.scenarist_full_name IS NULL AND sci.scenarist_full_name IS NULL))
--             AND (mfu.scenarist_gender = sci.scenarist_gender OR (mfu.scenarist_gender IS NULL AND sci.scenarist_gender IS NULL))
--             AND (mfu.scenarist_year_of_birth = sci.scenarist_year_of_birth OR (mfu.scenarist_year_of_birth IS NULL AND sci.scenarist_year_of_birth IS NULL))
--             AND (mfu.movie_id > (i-1)*100  AND mfu.movie_id <= i*100);
--     end loop;
--     DELETE FROM movie_fact_union WHERE movie_id > (loop_count * 100); 
-- end;
-- $$;

------------------------------------------------------------------------------------------
--------                        MOVIE FACT WITH CORRECT DIRECTOR ID               --------
------------------------------------------------------------------------------------------

-- DO $$
-- declare
--     loop_count integer;
-- begin 
--     raise notice 'Sart: %',now();
--     SELECT count(DISTINCT movie_id)/100 FROM movie_fact_union into loop_count;
--     raise notice 'loop count: %', loop_count;
--     for i in 1..loop_count loop
--         raise notice 'i: %', i;
--         UPDATE movie_fact_union AS mfu
--         SET director_id = dci.director_id
--         FROM director_correct_id AS dci
--         WHERE (mfu.director_full_name = dci.director_full_name OR (mfu.director_full_name IS NULL AND dci.director_full_name IS NULL))
--             AND (mfu.director_gender = dci.director_gender OR (mfu.director_gender IS NULL AND dci.director_gender IS NULL))
--             AND (mfu.director_year_of_birth = dci.director_year_of_birth OR (mfu.director_year_of_birth IS NULL AND dci.director_year_of_birth IS NULL))
--             AND (mfu.movie_id > (i-1)*100  AND mfu.movie_id <= i*100);
--     end loop;
--     DELETE FROM movie_fact_union WHERE movie_id > (loop_count * 100); 
-- end;
-- $$;


---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------


-- SELECT * FROM movie_fact_union
-- ORDER BY movie_id;