
# top 10 Movies By Revenue#
SELECT m.title, f.revenue, f.budget, 
       (f.revenue - f.budget) AS profit,
       f.currency
FROM moviesdb.movies m
JOIN moviesdb.financials f ON m.movie_id = f.movie_id
ORDER BY f.revenue DESC
LIMIT 10;

#------------------------------------------------------------------------#

#  Top 10 Actors by Number of Movie Appearances #

SELECT a.name AS actor_name, COUNT(ma.movie_id) AS total_movies
FROM moviesdb.actors a
JOIN moviesdb.movie_actor ma ON a.actor_id = ma.actor_id
GROUP BY a.name
ORDER BY total_movies DESC
LIMIT 10;

#-----------------------------------------------------------------------#

# Movie Count by Language #

SELECT l.name AS language, COUNT(*) AS movie_count
FROM moviesdb.movies m
JOIN moviesdb.languages l ON m.language_id = l.language_id
GROUP BY l.name
ORDER BY movie_count DESC;
#-----------------------------------------------------------------#

# Movies Released Per Year #

SELECT release_year, COUNT(*) AS movies_released
FROM moviesdb.movies
GROUP BY release_year
ORDER BY release_year;
-----------------------------------------------------------------------------

# Movies with Highest ROI (Return on Investment) #

SELECT m.title, f.budget, f.revenue, 
       ROUND((f.revenue - f.budget) * 1.0 / NULLIF(f.budget, 0), 2) AS roi
FROM moviesdb.movies m
JOIN moviesdb.financials f ON m.movie_id = f.movie_id
WHERE f.budget > 0
ORDER BY roi DESC
LIMIT 10;
#--------------------------------------------------------------------------------#

#Average IMDb Rating by Studio#

SELECT studio, ROUND(AVG(imdb_rating), 2) AS avg_rating, COUNT(*) AS total_movies
FROM moviesdb.movies
GROUP BY studio
ORDER BY avg_rating DESC;
#----------------------------------------#

# Top Rated Movies by Industry #

SELECT industry, title, imdb_rating
FROM (
    SELECT industry, title, imdb_rating,
           RANK() OVER (PARTITION BY industry ORDER BY imdb_rating DESC) AS rnk
    FROM moviesdb.movies
) ranked
WHERE rnk <= 3;
#-------------------------------------------------------------------------------#

#  Most Active Studios (Highest Movie Count) #
SELECT studio, COUNT(*) AS movie_count
FROM moviesdb.movies
GROUP BY studio
ORDER BY movie_count DESC
LIMIT 5;
#--------------------------------------------------#

#  Average Actor Age at Movie Release #

SELECT m.title, a.name AS actor_name,
       (m.release_year - a.birth_year) AS age_at_release
FROM moviesdb.movies m
JOIN moviesdb.movie_actor ma ON m.movie_id = ma.movie_id
JOIN moviesdb.actors a ON ma.actor_id = a.actor_id
WHERE a.birth_year IS NOT NULL
ORDER BY age_at_release DESC;
#---------------------------------------------------------------#

# Language-wise Revenue Contribution #

SELECT l.name AS language, SUM(f.revenue) AS total_revenue
FROM moviesdb.movies m
JOIN moviesdb.languages l ON m.language_id = l.language_id
JOIN moviesdb.financials f ON m.movie_id = f.movie_id
GROUP BY l.name
ORDER BY total_revenue DESC;


