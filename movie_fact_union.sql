
DROP TABLE IF EXISTS movie_fact_union;

CREATE TABLE movie_fact_union AS
SELECT * FROM (SELECT * FROM movie_fact_it) as movie_fact_it
UNION
SELECT * FROM (SELECT * FROM movie_fact_cs) as movie_fact_cs;

SELECT 'movie fact it' as name, count(*) as num FROM movie_fact_it
UNION
SELECT 'movie fact cs' as name, count(*) as num FROM movie_fact_cs
UNION
SELECT 'movie fact union' as name, count(*) as num FROM movie_fact_union
ORDER BY num;

