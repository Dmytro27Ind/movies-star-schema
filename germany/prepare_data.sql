-- DELETE FROM movie_fact_de_init as mf
-- WHERE mf.c2 = 'time_year';

-- DROP TABLE IF EXISTS movie_fact_de;

-- CREATE TABLE movie_fact_de AS
-- SELECT
-- CAST(null as date) as time_id,
-- CAST(mf.c2 as numeric) as time_year,
-- CAST(mf.c3 as numeric) as time_month,
-- CAST(mf.c4 as numeric) as time_date,

-- CAST(mf.c5 as integer) as movie_id,
-- CAST(mf.c6 as text) as movie_name,
-- CAST(mf.c7 as text) as movie_country,

-- CAST(mf.c8 as integer) as actor_id,
-- CAST(mf.c9 as text) as actor_full_name,
-- CAST(null as character(1)) as actor_gender,
-- CAST(null as numeric) as actor_year_of_birth,

-- CAST(mf.c12 as integer) as scenarist_id,
-- CAST(mf.c13 as text) as scenarist_full_name,
-- CAST(null as character(1)) as scenarist_gender,
-- CAST(null as numeric) as scenarist_year_of_birth,

-- CAST(mf.c16 as integer) as director_id,
-- CAST(mf.c17 as text) as director_full_name,
-- CAST(null as character(1)) as director_gender,
-- CAST(null as numeric) as director_year_of_birth,

-- CAST(mf.c24 as integer) as genre_id,
-- CAST(mf.c25 as text) as genre_name,

-- CAST(null as double precision) as budget,
-- CAST(null as bigint) as number_of_votes,
-- CAST(mf.c22 as real) as rating,
-- CAST(mf.c23 as integer)/(1000*60) as duration
-- FROM public.movie_fact_de_init as mf;



DELETE FROM subtitle_fact_de_init as mf
WHERE mf.c2 = 'time_year';

DROP TABLE IF EXISTS subtitle_fact_de;

CREATE TABLE subtitle_fact_de AS
SELECT
CAST('5' AS integer) as language_id,
CAST('de' as text) as language_code,
CAST(null as date) as time_id,
CAST(mf.c2 as numeric) as time_year,
CAST(mf.c3 as numeric) as time_month,
CAST(mf.c4 as numeric) as time_date,

CAST(mf.c5 as integer) as movie_id,
CAST(mf.c6 as text) as movie_name,
CAST(mf.c7 as text) as movie_country,

CAST(mf.c8 as integer) as scenarist_id,
CAST(mf.c9 as text) as scenarist_full_name,
CAST(null as character(1)) as scenarist_gender,
CAST(null as numeric) as scenarist_year_of_birth,

CAST(mf.c12 as integer) as director_id,
CAST(mf.c13 as text) as director_full_name,
CAST(null as character(1)) as director_gender,
CAST(null as numeric) as director_year_of_birth,

CAST(mf.c16 as integer) as genre_id,
CAST(mf.c17 as text) as genre_name,

CAST(c18 as bigint) as word_count,
CAST(c19 as bigint) as number_of_replicas,
CAST(c20 as bigint) as number_of_characters
FROM public.subtitle_fact_de_init as mf;