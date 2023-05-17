/* Q1: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

WITH genre_total_amount_cte AS (SELECT first_name, invoice.billing_country AS country, SUM(invoice_line.unit_price*quantity) AS total_amount
FROM invoice
JOIN customer ON invoice.customer_id = customer.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
GROUP BY first_name,invoice.billing_country
),

row_num_cte AS (SELECT  country,first_name, MAX(total_amount) AS max_total, ROW_NUMBER()  OVER(PARTITION BY country ORDER BY MAX(total_amount) DESC) AS rn
FROM genre_total_amount_cte 
GROUP BY country,first_name)

SELECT country, first_name, max_total FROM row_num_cte 
WHERE rn = 1
ORDER BY 1, 3 DESC

/* Q2: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

SELECT DISTINCT first_name,last_name,email, g.name
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY 3

/* Q3: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

SELECT TOP 10 a.name,g.name, COUNT(*) no_of_songs
FROM artist a
JOIN album al ON a.artist_id = al.artist_id
JOIN track t ON al.album_id = t.album_id
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY a.name,g.name
HAVING g.name LIKE 'Rock'
ORDER BY 3 DESC

/* Q4: Who is the senior most employee based on job title? */
 
 SELECT TOP 1 first_name+ ' ' +last_name as full_name, title
 FROM employee
 ORDER BY levels DESC

 /* Q5: Which countries have the most Invoices? */

 SELECT billing_country country, COUNT(*) invoice_count
 FROM invoice 
 GROUP BY billing_country
 ORDER BY 2 DESC

 /* Q6: What are top 3 values of total invoice? */

 SELECT TOP 3 total
 FROM invoice
 ORDER BY 1 DESC

/* Q7: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

SELECT TOP 1 billing_city city, SUM(total) inoice_total
FROM  invoice
GROUP BY billing_city
ORDER BY 2 DESC

/* Q8: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

SELECT TOP 1 c.customer_id, c.first_name, SUM(total) inoice_total
FROM  invoice i
JOIN customer c
ON i.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name
ORDER BY SUM(total) DESC

/* Q9: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

SELECT name, milliseconds
FROM track 
WHERE milliseconds > (select  AVG( milliseconds) from track)
ORDER BY 2 DESC

/* Q10: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

WITH total_amount_cte AS (SELECT first_name,track_id, SUM(unit_price*quantity) total_amount
FROM [invoice_line]
JOIN invoice ON invoice_line.invoice_id = invoice.invoice_id
JOIN customer ON customer.customer_id = invoice.customer_id
GROUP BY first_name,track_id  
)

SELECT first_name, artist.name, SUM(total_amount)
FROM total_amount_cte
JOIN track ON track.track_id = total_amount_cte.track_id
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
GROUP BY first_name,artist.name  
ORDER BY 3 DESC

/* Q11: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

WITH genre_total_amount_cte AS (SELECT invoice.billing_country AS country,genre.name AS genre_name,  SUM(invoice_line.unit_price*quantity) AS total_amount
FROM invoice
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN genre ON track.genre_id = genre.genre_id
GROUP BY genre.name, invoice.billing_country
),

row_num_cte AS (SELECT  country, genre_name, MAX(total_amount) AS max_total, ROW_NUMBER()  OVER(PARTITION BY country ORDER BY MAX(total_amount) DESC) AS rn
FROM genre_total_amount_cte 
GROUP BY country, genre_name)

SELECT country, genre_name AS popular_genre, max_total FROM row_num_cte 
WHERE rn = 1
ORDER BY 1, 3 DESC
 
