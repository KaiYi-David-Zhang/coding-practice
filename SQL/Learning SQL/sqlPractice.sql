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