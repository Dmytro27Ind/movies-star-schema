DROP TABLE IF EXISTS subtitle_fact_un CASCADE;

CREATE TABLE subtitle_fact_un AS
SELECT * FROM (SELECT * FROM subtitles_fact) as subtitle_fact_it
UNION
SELECT * FROM (SELECT * FROM subtitle_fact_cs) as subtitle_fact_cs
UNION
SELECT * FROM (SELECT * FROM subtitle_fact_en) as subtitle_fact_en;

SELECT 'subtitle fact it' as name, count(*) as num FROM subtitles_fact
UNION
SELECT 'subtitle fact cs' as name, count(*) as num FROM subtitle_fact_cs
UNION
SELECT 'subtitle fact en' as name, count(*) as num FROM subtitle_fact_en
UNION
SELECT 'subtitle fact union' as name, count(*) as num FROM subtitle_fact_un
ORDER BY num;
