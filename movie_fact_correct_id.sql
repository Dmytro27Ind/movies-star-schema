-- DROP TABLE IF EXISTS movie_fact_union;

-- CREATE TABLE movie_fact_union AS
-- SELECT * FROM movie_fact_un;

------------------------------------------------------------------------------------------
--------                    DISTINCT ACTOR WITH CORRECT ID                        --------
------------------------------------------------------------------------------------------

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

-- -- SELECT * FROM genre_correct_id;

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
--------                        MOVIE FACT WITH CORRECT ID                        --------
------------------------------------------------------------------------------------------

-- UPDATE movie_fact_union AS mfu
-- SET movie_id = mci.movie_id
-- FROM movie_correct_id AS mci
-- WHERE mfu.movie_name = mci.movie_name AND (mfu.movie_country = mci.movie_country OR (mfu.movie_country IS NULL AND mci.movie_country IS NULL));

-- UPDATE movie_fact_union AS mfu
-- SET genre_id = gci.genre_id,
--     genre_name = gci.genre_name
-- FROM genre_correct_id AS gci
-- WHERE lower(mfu.genre_name) = gci.genre_name;

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

SELECT * FROM movie_fact_union
ORDER BY movie_id;