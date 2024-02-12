#1.1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
SELECT title, 
max(length) AS max_duration ,
min(length) AS min_duration
FROM film;



## CHat gpt to get in the way i want 
SELECT 
    title,
    length AS duration
FROM 
    film
WHERE 
    length = (SELECT MAX(length) AS max_duration FROM film)
    OR 
    length = (SELECT MIN(length) AS min_duration FROM film)
 ORDER BY length;

 
#1.1.2. Express the average movie duration in hours and minutes. Don't use decimals.Hint: Look for floor and round functions.
SELECT ROUND(AVG(length)) AS round_minutes FROM film;
SELECT ROUND(AVG(length) / 60) FROM film;


#1.2.1 Calculate the number of days that the company has been operating.
#Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.
SELECT * FROM rental;

SELECT rental_date FROM rental
ORDER BY rental_date ASC;

SELECT rental_date FROM rental
ORDER BY rental_date DESC;

 SELECT  DATEDIFF(day, '2005-05-24','2006-02-14');# Why is not working ?
 
 SELECT DATEDIFF('2006-02-14', '2005-05-24');  #DATEDIFF(datepart, startdate, enddate)notes 
#1.2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
SELECT * FROM rental;
SELECT rental_date, DAY(rental_date) AS week_day, MONTH(rental_date) AS month_rent FROM rental
LIMIT 20;

# CHATgpt
# https://www.w3schools.com/sql/func_mysql_date_format.asp
SELECT 
    rental_id, 
    rental_date, 
    DATE_FORMAT(rental_date, '%M') AS rental_month, 
    DATE_FORMAT(rental_date, '%W') AS rental_weekday
FROM 
    rental
LIMIT 20;

#1.2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
#Hint: use a conditional expression.

SELECT * FROM rental;
    
SELECT 
    rental_id, 
    rental_date, 
    DATE_FORMAT(rental_date, '%M') AS rental_month, 
    DATE_FORMAT(rental_date, '%W') AS rental_weekday,
		CASE 
			WHEN DATE_FORMAT(rental_date, '%W') IN ("Monday","Tuesday","Wednesday","Thursday","Friday") THEN "workday"
			ELSE "weekend" 
		END AS DAY_TYPE
FROM rental;

# chat gpt solution	I used this after failing with above approach, but then i end up making it work. first the alias didnt work,  
 # then i try to put "DATE_FORMAT(rental_date, '%W')" nwxt to the CASE, but it wasnt working as well, and i end up with the above 
SELECT *, DATE_FORMAT(rental_date, '%M') AS rental_month,
    CASE 
        WHEN DAYOFWEEK(rental_date) IN (2, 3, 4, 5, 6) THEN "workday"
        ELSE "weekend"
    END AS DAY_TYPE
FROM rental;

#1.3 You need to ensure that customers can easily access information about the movie collection. 
#To achieve this, retrieve the film titles and their rental duration. 
#If any rental duration value is NULL, replace it with the string 'Not Available'. 
# Sort the results of the film title in ascending order.
# Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future.
# Hint: Look for the IFNULL() function.

SELECT * FROM  rental;
SELECT * FROM  film;
SELECT title, IFNULL(rental_duration, 'Not Available') AS rental_duration
FROM film
ORDER BY rental_duration ASC ;
#1.4 Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers.
 #To achieve this, you need to retrieve the concatenated first and last names of customers, along with the first 3 characters
 # of their email address, so that you can address them by their first name and use their email address to send personalized 
 # recommendations. The results should be ordered by last name in ascending order to make it easier to use the data.
SELECT * FROM customer;
SELECT * ,CONCAT(first_name,last_name,SUBSTRING(email,1,3))  AS full_name  # not sure if this is what you are asking
FROM customer
ORDER BY last_name;

# CHALLENGE 2
#Next, you need to analyze the films in the collection to gain some more insights. Using the film table, determine:
# 2.1 The total number of films that have been released.

SELECT count(DISTINCT title) from film;

#2.2 The number of films for each rating.

SELECT count(DISTINCT title), rating  from film
GROUP BY rating;
#2.3 The number of films for each rating, sorting the results in descending order of the number of films. 
#This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.

SELECT count(DISTINCT title) AS number_of_movies , rating  from film
GROUP BY rating
ORDER BY count(DISTINCT title);

# Using the film table, determine:
#2.2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration.
# Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.
SELECT count(DISTINCT title) AS number_of_movies , rating, ROUND(AVG(length)) AS average_length_rating
from film
GROUP BY rating
ORDER BY ROUND(AVG(length));

#2.2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers who prefer longer movies.

SELECT count(DISTINCT title) AS number_of_movies , rating, (AVG(length) / 60) AS average_length_rating_hour,
			CASE
			WHEN (AVG(length) / 60)>= 2 THEN "long film"
            ELSE "Short film"
            END AS Longmovies
FROM film
GROUP BY rating
ORDER BY (AVG(length));
# Bonus: determine which last names are not repeated in the table actor.
SELECT * FROM actor;
SELECT COUNT(DISTINCT last_name)
FROM actor;
SELECT last_name, COUNT(*) AS row_count
FROM actor
GROUP BY last_name;

