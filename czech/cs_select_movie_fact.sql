-- actor_id, actor_full_name, actor_gender, actor_year_of_birth, 
-- time_id, time_year, time_month, time_date
-- movie_id, movie_name, movie_country, 
-- genre_id, genre_name,
-- scenarist_id, scenarist_full_name, scenarist_gender, scenarist_year_of_birth,
-- director_id, director_full_name, director_gender, director_year_of_birth,
-- budget, number_of_votes, rating, duration

DROP VIEW IF EXISTS movie_person CASCADE; 

CREATE VIEW movie_person AS (
SELECT film_crew.id_film as movie_id, person.id_person as person_id,
(person.first_name || ' ' || person.surname) as person_full_name,
person.gender as person_gender, EXTRACT(year FROM person.birth_date) as person_year_of_birth,
film_crew.job
FROM public.person
INNER JOIN film_crew ON film_crew.id_person = person.id_person
WHERE film_crew.job = 'Writer' OR film_crew.job = 'Author' OR film_crew.job = 'Story' OR film_crew.job = 'Director'
ORDER BY film_crew.id_film ASC
);

-- SELECT * FROM movie_person;

DROP VIEW IF EXISTS movie_person_sd CASCADE; 

CREATE VIEW movie_person_sd AS (
SELECT film.id_film as movie_id,
    scenarist.person_id as scenarist_id, scenarist.person_full_name as scenarist_full_name,
    scenarist.person_gender as scenarist_gender, scenarist.person_year_of_birth as scenarist_year_of_birth,
    director.person_id as director_id, director.person_full_name as director_full_name,
    director.person_gender as director_gender, director.person_year_of_birth as director_year_of_birth
FROM film
FULL JOIN (SELECT * FROM movie_person AS d WHERE d.job = 'Director') as director ON director.movie_id = film.id_film
FULL JOIN (SELECT * FROM movie_person AS s WHERE s.job = 'Writer' OR s.job = 'Author' OR s.job = 'Story') as scenarist ON scenarist.movie_id = film.id_film
);

CREATE VIEW movie_scen_dir AS (
SELECT DISTINCT * FROM movie_person_sd
);

-- SELECT * FROM movie_scen_dir;

DROP VIEW IF EXISTS movie_actor CASCADE; 

CREATE VIEW movie_actor AS (
SELECT film_cast.id_film as movie_id, person.id_person as person_id,
(person.first_name || ' ' || person.surname) as person_full_name,
person.gender as person_gender, EXTRACT(year FROM person.birth_date) as person_year_of_birth
FROM film_cast
INNER JOIN person ON person.id_person = film_cast.id_person
ORDER BY person.id_person ASC
);

-- SELECT * FROM movie_actor;

DROP VIEW IF EXISTS movie_fact_data CASCADE; 

CREATE VIEW movie_fact_data AS (
SELECT 
    film.release_date as time_id,
    EXTRACT(year FROM film.release_date) as time_year,
    EXTRACT(month FROM film.release_date) as time_month,
    EXTRACT(day FROM film.release_date) as time_date,
    film.id_film as movie_id, film.title as movie_name,
    genre.id_genre as genre_id, genre.name as genre_name,
    film.budget, null as number_of_votes, null as rating, film.runtime as duration
FROM public.film, public.genre, public.film_genre
WHERE film_genre.id_film = film.id_film AND film_genre.id_genre = genre.id_genre
ORDER BY film.id_film ASC
);

-- SELECT * FROM movie_fact_data;

DROP VIEW IF EXISTS movie_country CASCADE; 

CREATE VIEW movie_country AS (
SELECT fc.id_film as movie_id, country.name as movie_country, country.code as movie_country_code
FROM film_country as fc, country
WHERE fc.id_country = country.id_country
ORDER BY fc.id_film ASC
);

-- SELECT * FROM movie_country;

DROP TABLE IF EXISTS movie_fact CASCADE; 

CREATE TABLE movie_fact AS
SELECT
mfd.time_id, mfd.time_year, mfd.time_month, mfd.time_date,
mfd.movie_id, mfd.movie_name, mc.movie_country,
ma.person_id as actor_id, ma.person_full_name as actor_full_name, ma.person_gender as actor_gender, ma.person_year_of_birth as actor_year_of_birth,
msd.scenarist_id, msd.scenarist_full_name, msd.scenarist_gender, msd.scenarist_year_of_birth,
msd.director_id, msd.director_full_name, msd.director_gender, msd.director_year_of_birth,
mfd.genre_id, mfd.genre_name, 
CAST(mfd.budget AS DOUBLE PRECISION), CAST(mfd.number_of_votes AS BIGINT), CAST(mfd.rating AS REAL), mfd.duration
FROM movie_fact_data AS mfd
INNER JOIN movie_country AS mc ON mc.movie_id = mfd.movie_id
INNER JOIN movie_actor AS ma ON ma.movie_id = mfd.movie_id
FULL JOIN movie_scen_dir AS msd ON msd.movie_id = mfd.movie_id
ORDER BY mfd.movie_id ASC
;

-- SELECT * FROM movie_fact;

DROP TABLE IF EXISTS movie_fact_cs;

CREATE TABLE movie_fact_cs AS
SELECT * FROM movie_fact WHERE movie_id IS NOT NULL;

-- SELECT * FROM movie_fact_cs;