CREATE OR REPLACE TABLE housemusic-463214.DiscogsRAW.house_music_clean AS
SELECT
  id,
  title,
  country,
  styles,
  genres,
  label,

  -- Clean date string first
  SAFE.PARSE_DATE('%Y-%m-%d', 
    CASE
      WHEN REGEXP_CONTAINS(year, r'^\d{4}-\d{2}-\d{2}$') THEN
        REGEXP_REPLACE(REGEXP_REPLACE(year, '-00', '-01'), '-00', '-01')
      WHEN REGEXP_CONTAINS(year, r'^\d{4}-\d{2}$') THEN
        CONCAT(year, '-01')
      WHEN REGEXP_CONTAINS(year, r'^\d{4}$') THEN
        CONCAT(year, '-01-01')
      ELSE NULL
    END
  ) AS parsed_date,

  -- Extract only the year
  EXTRACT(YEAR FROM SAFE.PARSE_DATE('%Y-%m-%d', 
    CASE
      WHEN REGEXP_CONTAINS(year, r'^\d{4}-\d{2}-\d{2}$') THEN
        REGEXP_REPLACE(REGEXP_REPLACE(year, '-00', '-01'), '-00', '-01')
      WHEN REGEXP_CONTAINS(year, r'^\d{4}-\d{2}$') THEN
        CONCAT(year, '-01')
      WHEN REGEXP_CONTAINS(year, r'^\d{4}$') THEN
        CONCAT(year, '-01-01')
      ELSE NULL
    END
  )) AS release_year

FROM
  housemusic-463214.DiscogsRAW.house_music_all
WHERE
  year IS NOT NULL
  AND country IS NOT NULL;

