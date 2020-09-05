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
