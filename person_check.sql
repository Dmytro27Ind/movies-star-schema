SELECT count(*) FROM
(SELECT DISTINCT * FROM (
    SELECT director_id, director_full_name, director_gender, director_year_of_birth FROM movie_fact_union
) AS SCEN) AS SCE
GROUP BY director_id
HAVING count(*) > 1;