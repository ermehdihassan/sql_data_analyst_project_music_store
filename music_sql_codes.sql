Create database music_sql_final;
use  my_project;

-- Who is the senior most employee based on job title?
select employee_id, concat(first_name," ",last_name) as name,
title, levels from employee
order by levels desc limit 1;

-- What are the top 5 countries with the most Invoices?
select billing_country,count(invoice_id) as number_of_invoices from invoice
group by billing_country order by number_of_invoices desc limit 5;

-- What are the top 3 values of the total invoice?
select total from invoice order by total desc limit 3;

/* Which city has the best customers? We would like to throw a promotional Music Festival in the city 
we made the most money. Write a query that returns one city that has the highest sum of invoice totals.
Return both the city name & sum of all invoice totals. */

select billing_city,sum(total) as invoice_total from invoice
group by billing_city order by invoice_total desc limit 1;

/* Who is the best customer? The customer who has spent the most money will be declared the best customer.
Write a query that returns the person who has spent the most money. */

select c.customer_id, concat(first_name," ",last_name) as customer_name, sum(total) as total_money_spent  
from customer c join invoice i on c.customer_id = i.customer_id
group by c.customer_id, customer_name order by total_money_spent desc limit 1; 

/* Write query to return the email, first name, last name, & Genre of all Rock Music listeners.
Return your list ordered alphabetically by email startng with A. */

select distinct email,first_name,last_name,g.name from customer c 
join invoice i on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id =il.track_id
join genre g on g.genre_id=t.genre_id
where g.name = "Rock" order by email;

/* Lets invite the artists who have written the most rock music in our dataset. Write a query that returns
the Artist name and total track count of the top 10 rock bands. */
select ar.artist_id,ar.name,count(ar.artist_id) as track_count from artist ar 
join album al on ar.artist_id=al.artist_id
join track t on t.album_id = al.album_id
join genre g on g.genre_id=t.genre_id 
where g.name = "Rock"
group by ar.artist_id,ar.name order by track_count desc limit 10;

/*Return all the track names that have a song length longer than the average song length. Return the Name and 
Milliseconds for each track. Order by the song length with longest songs listed first.*/

select name,milliseconds from track 
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc;

/*Find how much amount spent by each customer on artists? Write 
a query to return customer_name, artist name and total spent.*/

select concat(first_name," ",last_name) as customer_name,ar.name as artist_name,
sum(il.unit_price*quantity) as total_spent from customer c 
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on t.track_id = il.track_id
join album a on a.album_id=t.album_id
join artist ar on ar.artist_id =a.artist_id  
group by customer_name, artist_name order  by total_spent desc;



/* We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre
with highest amount of purchases. Write a query that returns each country along with the top Genre. */

with cte as (select i.billing_country as country,g.name as genre_name, count(g.genre_id) as total_number_of_purchase,
row_number() over(partition by i.billing_country order by count(g.genre_id) desc) as rnk
 from Invoice i join invoice_line il on i.invoice_id=il.invoice_id
join track t on t.track_id=il.track_id
join genre g on g.genre_id=t.genre_id
group by billing_country,g.name order by country,total_number_of_purchase desc)
select cte.country,cte.genre_name, cte.total_number_of_purchase from cte where rnk=1
order by cte.country;

/* Write a query that determines the customer that has spent the most on music for each country. Write a query that 
returns the country along with the top customer and how much they spent.*/

with cte as (select c.country as country,concat(first_name," ",last_name) as customer,sum(quantity*t.unit_price) as total_spent,
row_number() over(partition by c.country order by sum(quantity*t.unit_price) desc) as rnk
 from customer c join invoice i on c.customer_id=i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
group by c.country,customer)
select cte.country,customer,total_spent from cte where rnk=1;
































