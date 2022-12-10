SELECT count(*) FROM
(SELECT DISTINCT * FROM (
    SELECT director_id, director_full_name, director_gender, director_year_of_birth FROM subtitle_fact_union
) AS SCEN) AS SCE
GROUP BY director_id
HAVING count(*) > 1;

-- SELECT count(*) FROM
-- (SELECT DISTINCT * FROM (
--     SELECT scenarist_id, scenarist_full_name, scenarist_gender, scenarist_year_of_birth FROM subtitle_fact_union
-- ) AS SCEN) AS SCE
-- GROUP BY scenarist_id
-- HAVING count(*) > 1;