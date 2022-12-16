DROP view IF exists movie_facts;

CREATE VIEW movie_facts AS (
	SELECT 
		STR_TO_DATE(movies.released, "%d %M %Y") as time_id,
		EXTRACT(YEAR FROM STR_TO_DATE(movies.released, "%d %M %Y")) as time_year, 
		EXTRACT(MONTH FROM STR_TO_DATE(movies.released, "%d %M %Y")) as time_month,
		EXTRACT(DAY FROM STR_TO_DATE(movies.released, "%d %M %Y")) as time_date, 
		movies.id as movie_id,
		movies.title as movie_name,
		movies.country as movie_country,
		actors.id as actor_id,
		actors.actor as actor_full_name,
		null as actor_gender,
		null as actor_year_of_birth,
		writers.id as scenarist_id,  
		writers.writer as scenarist_full_name,
		null as scenarist_gender,
		null as scenarist_year_of_birth,
		directors.id as director_id,  
		directors.director as director_full_name,
		null as director_gender,
		null as director_year_of_birth,
		null as budget,
		null as number_of_votes,
		movies.rating as rating,
		movies.time as duration,
		genere.id as genere_id,
		genere.genere as genere_name
	FROM movies
	JOIN movie_genere ON movies.id = id_movie
	JOIN genere ON movie_genere.id_genere = genere.id 
	JOIN movie_actors ON movies.id = id_actor 
	JOIN actors ON movie_actors.id_actor = actors.id
	JOIN movie_writers ON movies.id = id_writer 
	JOIN writers ON movie_writers.id_writer = writers.id
	JOIN movie_directors ON movies.id = id_director 
	JOIN directors ON movie_directors.id_director = directors.id
);


SELECT * FROM movie_facts;

CREATE VIEW subtitle_facts AS (
	SELECT 
		STR_TO_DATE(movies.released, "%d %M %Y") as time_id,
		EXTRACT(YEAR FROM STR_TO_DATE(movies.released, "%d %M %Y")) as time_year, 
		EXTRACT(MONTH FROM STR_TO_DATE(movies.released, "%d %M %Y")) as time_month,
		EXTRACT(DAY FROM STR_TO_DATE(movies.released, "%d %M %Y")) as time_date, 
		movies.id as movie_id,
		movies.title as movie_name,
		movies.country as movie_country,
		writers.id as scenarist_id,  
		writers.writer as scenarist_name,
		null as scenarist_gender,
		null as scenarist_year_of_birth,
		directors.id as director_id,  
		directors.director as director_name,
		null as director_gender,
		null as director_year_of_birth,
		genere.id as genere_id,
		genere.genere as genere_name,
		subtitles.words_count  as word_count,
		subtitles.sentences_count as number_of_replicas,
		subtitles.letters_count as number_of_characters
	FROM movies
	JOIN subtitles ON movies.id = subtitles.movie_id
	JOIN movie_genere ON movies.id = id_movie
	JOIN genere ON movie_genere.id_genere = genere.id 
	JOIN movie_actors ON movies.id = id_actor 
	JOIN actors ON movie_actors.id_actor = actors.id
	JOIN movie_writers ON movies.id = id_writer 
	JOIN writers ON movie_writers.id_writer = writers.id
	JOIN movie_directors ON movies.id = id_director 
	JOIN directors ON movie_directors.id_director = directors.id
);

SELECT * FROM subtitle_facts;

