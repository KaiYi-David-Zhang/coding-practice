SELECT title, rental_rate
FROM film
WHERE rental_rate = .99
;


-- format
SELECT
FROM
WHERE
;

-- find all customer name first and last, email that are customer of store 2
SELECT first_name, last_name, email
FROM customer
WHERE store_id = 2
;

-- count
select count(title)
FROM film
WHERE rental_rate = .99
;

-- group by
SELECT count(title), rental_rate
FROM film
GROUP BY rental_rate
;
-- can use group by using index

select count(title), rating
FROM film
group by rating
;

-- connecting tables

select customer.customer_id, customer.first_name, customer.last_name, address.address
FROM customer, address
WHERE customer.address_id = address.address_id
;

-- list of every film with film name, category and language
select film.title, film_list.category, language.name
FROM film, film_list, language
WHERE film.film_id = film_list.FID, language.language_id = film.language_id
;

-- how many times each movies has been rented out
select
  f.title, count(r.rental_id)
FROM
  film f,
  inventory i,
  rental r
WHERE
  f.film_id = i.film_id
  and r.inventory_id = i.inventory_id
GROUP BY
  f.title
;

-- how much money did each movie make
select
  f.title as title, count(r.rental_id), f.rental_rate, count(r.rental_id) * f.rental_rate as Revenue
FROM
  film f,
  inventory i,
  rental r
WHERE
  f.film_id = i.film_id
  and r.inventory_id = i.inventory_id
GROUP BY
  f.title
ORDER BY
  4 desc
;

-- what customer has paid us the most money
SELECT p.customer_id, SUM(p.amount)
FROM payment p
GROUP BY 1
ORDER BY 2 desc
;

-- what store has brought in the most revenue
SELECT i.store_id as "STORE ID", SUM(p.amount) as "REVENUE"
FROM payment p, inventory i, rental r
WHERE p.rental_id = r.rental_id and i.inventory_id = r.inventory_id
GROUP BY 1
ORDER BY 2 desc
;


-- how much rentals we had each month
SELECT left(r.rental_date, 7), count(r.rental_id)
FROM rental r
GROUP BY 1
ORDER BY 2 desc
;

-- min and max rental date
SELECT f.title, max(r.rental_date), min(r.rental_date)
FROM rental r, inventory i, film f
WHERE r.inventory_id = i.inventory_id and i.film_id = f.film_id
GROUP BY f.film_id
;


-- every customer's last rental date
SELECT c.first_name, c.last_name, max(r.rental_date)
FROM rental r, customer c
WHERE r.customer_id = c.customer_id
GROUP BY c.customer_id
;



-- revenue by each month
SELECT left(r.rental_date, 7), SUM(p.amount)
FROM rental r, payment p
WHERE r.rental_id = p.rental_id
GROUP BY 1
ORDER BY 1
;


-- how many distinct renters per month
SELECT left(r.rental_date, 7) as month, count(r.rental_id) as total_rentals,
        count(distinct r.customer_id) as unique_renters, count(r.rental_id)/count(distinct r.customer_id) as avg_rental_per_customer
FROM rental r
WHERE
;

-- the number of distinct films rented each month
SELECT left(r.rental_date, 7), count(distinct f.film_id)
FROM rental r, inventory i, film f
WHERE f.film_id = i.film_id and i.inventory_id = r.inventory_id
GROUP BY 1
;


-- the number of rentals in the comedy, sport and family
SELECT c.name, count(r.rental_id)
FROM rental r, inventory i, film f, film_category fc, category c
WHERE r.inventory_id = i.inventory_id
      and i.film_id = f.film_id
      and f.film_id = fc.film_id
      and fc.category_id =  c.category_id
      and c.name in ("Comedy", "Sports", "Family")
GROUP BY 1
;

-- user's who have rented at least 3 times
SELECT r.customer_id as customer, count(r.rental_id) as rentals
FROM rental r
GROUP BY 1
HAVING count(r.rental_id) >= 3
;

-- revenue for store 1 where film is rated  PG-13 or R
SELECT f.rating, sum(p.amount)
FROM rental r, film f, inventory i, payment p
WHERE r.rental_id = p.rental_id 
      and r.inventory_id = i.inventory_id 
      and i.film_id = f.film_id
      and i.store_id = 1
      and f.rating in ("PG-13", "R")
      and r.rental_date between '2005-06-08' and '2005-07-19'
GROUP BY 1
;

-- nested queries
-- rentals per customer
SELECT rpc.num_rentals, count(distinct rpc.customer_id), sum(p.amount)
FROM
  (SELECT r.customer_id, count(distinct r.rental_id) as num_rentals
    FROM rental r
    GROUP BY 1
  ) as rpc,
  payment p
WHERE rpc.customer_id = p.customer_id and rpc.num_rentals > 20
GROUP BY 1
;

-- temporary tables
create temporary table rpc as 
SELECT r.customer_id, count(distinct r.rental_id) as num_rentals
FROM rental r
GROUP BY 1
;

SELECT sum(p.amount)
FROM
  rpc,
  payment p
WHERE rpc.customer_id = p.customer_id and rpc.num_rentals > 20
;