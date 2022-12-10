
DROP TABLE IF EXISTS movie_fact_un CASCADE;

CREATE TABLE movie_fact_un AS
SELECT * FROM (SELECT * FROM movie_fact_it) as movie_fact_it
UNION
SELECT * FROM (SELECT * FROM movie_fact_cs) as movie_fact_cs
UNION
SELECT * FROM (SELECT * FROM movie_fact_en) as movie_fact_en;

SELECT 'movie fact it' as name, count(*) as num FROM movie_fact_it
UNION
SELECT 'movie fact cs' as name, count(*) as num FROM movie_fact_cs
UNION
SELECT 'movie fact en' as name, count(*) as num FROM movie_fact_en
UNION
SELECT 'movie fact union' as name, count(*) as num FROM movie_fact_un
ORDER BY num;

