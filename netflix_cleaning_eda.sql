-- ============================================================
-- NETFLIX CONTENT CATALOG: DATA CLEANING & EXPLORATORY ANALYSIS
-- Author: Patricia Fagbola | AnalystLab Internship
-- ============================================================


-- A DETAILED EXPLORATORY ANALYSIS OF THE NETFLIX  CATALOG
-- ------------------------------------------------------------
CREATE TABLE netflix_titles_working  AS
SELECT *
FROM netflix_titles;


-- 1. Understanding the dataset
-- ------------------------------------------------------------
SELECT *
FROM netflix_titles_working
LIMIT 5;

DESC  netflix_titles_working;


-- 2. Data cleaning
-- ------------------------------------------------------------

-- HANDLING Duplicates
-- ------------------------------------------------------------
SELECT show_id, COUNT(*) 
FROM netflix_titles_working
GROUP BY show_id
HAVING COUNT(*) > 1;

SELECT title, type, COUNT(*) 
FROM netflix_titles_working
GROUP BY title, type
HAVING COUNT(*) > 1;

SELECT *
FROM netflix_titles_working
WHERE title IN (
    'Love in a Puff',
    'Esperando la carroza',
    'Sin senos sí hay paraíso',
    'Veronica'
)
ORDER BY title;


-- No duplicates were found in the dataset
-- ------------------------------------------------------------

-- Handling missing values
-- ------------------------------------------------------------
SELECT 
    SUM(`cast` = '') AS cast_empty,
    SUM(rating = '') AS rating_empty,
    SUM(country = '') AS country_empty
FROM netflix_titles_working;

UPDATE netflix_titles_working SET cast = 'Unknown' WHERE cast = '' OR cast IS NULL;

UPDATE netflix_titles_working SET rating = 'Unknown' WHERE rating = '' OR rating IS NULL;

UPDATE netflix_titles_working SET country = 'Unknown' WHERE country = '' OR country IS NULL;

SELECT * FROM netflix_titles_working WHERE date_added = ''
OR release_year = ''
OR duration ='';


-- Standardization
-- ------------------------------------------------------------
UPDATE netflix_titles_working
SET duration = rating,
    rating = NULL
WHERE rating LIKE '% min';

SELECT date_added, 
       STR_TO_DATE(TRIM(date_added), '%M %d, %Y') as converted
FROM netflix_titles_working
WHERE date_added IS NOT NULL
LIMIT 10;

UPDATE netflix_titles_working
SET date_added = STR_TO_DATE(TRIM(date_added), '%M %d, %Y')
WHERE date_added IS NOT NULL AND TRIM(date_added) != '';

UPDATE netflix_titles_working
SET date_added = NULL
WHERE TRIM(date_added) = '';

ALTER TABLE netflix_titles_working MODIFY date_added DATE;

UPDATE netflix_titles_working
SET title = TRIM(title),
    director = TRIM(director),
    country = TRIM(country);


-- Data transformation
-- ------------------------------------------------------------
ALTER TABLE netflix_titles_working ADD COLUMN duration_value INT;
ALTER TABLE netflix_titles_working ADD COLUMN duration_unit VARCHAR(10);

UPDATE netflix_titles_working
SET duration_value = CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED),
    duration_unit = TRIM(SUBSTRING(duration, LOCATE(' ', duration)+1))
WHERE duration IS NOT NULL AND TRIM(duration) != '';

CREATE TABLE netflix_titles_clean AS
SELECT * FROM netflix_titles_working;


-- 3. Exploratory data analysis
-- ------------------------------------------------------------

-- Dataset overview
-- ------------------------------------------------------------
SELECT 
    COUNT(*) as total_titles,
    SUM(type = 'Movie') as total_movies,
    SUM(type = 'TV Show') as total_tv_shows,
    MIN(release_year) as earliest_release,
    MAX(release_year) as latest_release
FROM netflix_titles_clean;


-- Distribution of content type
-- ------------------------------------------------------------
SELECT type, COUNT(*) as count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix_titles_working), 1) as pct
FROM netflix_titles_clean
GROUP BY type;


-- Growth of content over time
-- ------------------------------------------------------------
SELECT YEAR(date_added) as year_added, type, COUNT(*) as titles_added
FROM netflix_titles_clean
WHERE date_added IS NOT NULL
GROUP BY YEAR(date_added), type
ORDER BY year_added;


-- Most represented year in the netflix catalog
-- ------------------------------------------------------------
SELECT release_year, COUNT(*) as titles
FROM netflix_titles_clean
GROUP BY release_year
ORDER BY release_year DESC
LIMIT 15;


-- Top countries producing content
-- ------------------------------------------------------------
SELECT country, COUNT(*) as titles
FROM netflix_titles_clean
WHERE country != 'Unknown'
GROUP BY country
ORDER BY titles DESC
LIMIT 10;


-- Breakdown of content by maturity rating
-- ------------------------------------------------------------
SELECT rating, COUNT(*) as count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix_titles_working), 1) as pct
FROM netflix_titles_clean
GROUP BY rating
ORDER BY count DESC;


-- Most common genre combinations
-- ------------------------------------------------------------
SELECT listed_in, COUNT(*) as count
FROM netflix_titles_clean
GROUP BY listed_in
ORDER BY count DESC
LIMIT 10;


-- What's the range and average length of movies on Netflix
-- ------------------------------------------------------------
SELECT 
    MIN(duration_value) as shortest_movie,
    MAX(duration_value) as longest_movie,
    ROUND(AVG(duration_value), 1) as avg_runtime
FROM netflix_titles_clean
WHERE type = 'Movie' AND duration_unit = 'min';


-- season count of tv shows
-- ------------------------------------------------------------
SELECT duration_value as seasons, COUNT(*) as num_shows
FROM netflix_titles_clean
WHERE type = 'TV Show'
GROUP BY duration_value
ORDER BY duration_value;


-- Which directors have the most titles in the netflix catalog
-- ------------------------------------------------------------
SELECT director, COUNT(*) as titles
FROM netflix_titles_clean
WHERE director != 'Unknown'
GROUP BY director
ORDER BY titles DESC
LIMIT 10;


-- Time lag(date_added  release year) in movies and tv show
-- ------------------------------------------------------------
SELECT 
    type,
    ROUND(AVG(YEAR(date_added) - release_year), 1) as avg_years_lag
FROM netflix_titles_clean
WHERE date_added IS NOT NULL
GROUP BY type;


-- 4. Visualisation
-- ------------------------------------------------------------