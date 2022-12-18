DROP view IF exists movie_facts;
CREATE VIEW movie_facts AS (SELECT
    CAST(NULL as date) as time_id,
    CAST(films.start_year AS numeric) as time_year,
    CAST(NULL as numeric) as time_month,
    CAST(NULL as numeric) as time_date,
    CAST(NULL as integer) as movie_id,
    CAST(films.original_title as text) as movie_name,
    CAST(NULL as text) as movie_country,
    CAST(NULL as integer) as actor_id,
    CAST(NULL as text) as actor_full_name,
    CAST(NULL as character(1)) as actor_gender,
    CAST(NULL as numeric) as actor_year_of_birth,
    CAST(NULL as integer) as scenarist_id,
    CAST(NULL as text) as scenarist_full_name,
    CAST(NULL as character(1)) as scenarist_gender,
    CAST(NULL as numeric) as scenarist_year_of_birth,
    CAST(NULL as integer) as director_id,
    CAST(NULL as text) as director_full_name,
    CAST(NULL as character(1)) as director_gender,
    CAST(NULL as numeric) as director_year_of_birth,
    CAST(NULL as integer) as genre_id,
    CAST(NULL as text) as genre_name,
    CAST(NULL as double precision) as budget,
    CAST(ratings.number_of_votes as bigint) as number_of_votes,
    CAST(ratings.average_rating as real) as raiting,
    CAST(films.runtime_minutes as integer) as duration
  FROM public.films, public.ratings
  WHERE
    films.imdb_id = ratings.imdb_id);
-- SELECT * FROM movie_facts;

DROP view IF exists subtitle_facts;
CREATE VIEW subtitle_facts AS (SELECT
    CAST(4 as integer) as language_id,
    CAST('sk' as text) as language_code,
    CAST(NULL as date) as time_id,
    CAST(films.start_year AS numeric) as time_year,
    CAST(NULL as numeric) as time_month,
    CAST(NULL as numeric) as time_date,
    CAST(NULL as integer) as movie_id,
    CAST(films.original_title as text) as movie_name,
    CAST(NULL as text) as movie_country,
    CAST(NULL as integer) as scenarist_id,
    CAST(NULL as text) as scenarist_full_name,
    CAST(NULL as character(1)) as scenarist_gender,
    CAST(NULL as numeric) as scenarist_year_of_birth,
    CAST(NULL as integer) as director_id,
    CAST(NULL as text) as director_full_name,
    CAST(NULL as character(1)) as director_gender,
    CAST(NULL as numeric) as director_year_of_birth,
    CAST(NULL as integer) as genre_id,
    CAST(NULL as text) as genre_name,
    CAST(subtitles.num_of_words as bigint) as word_count,
    CAST(subtitles.num_of_sentences as bigint) as number_of_replicas,
    CAST(subtitles.num_of_characters as bigint) as number_of_characters
  FROM public.films, public.subtitles
  WHERE
    films.imdb_id = subtitles.imdb_id);
-- SELECT * FROM subtitle_facts;

DROP TABLE IF EXISTS movie_fact_sk;
DROP TABLE IF EXISTS subtitle_fact_sk;

CREATE TABLE movie_fact_sk AS SELECT * FROM movie_facts;
CREATE TABLE subtitle_fact_sk AS SELECT * FROM subtitle_facts;