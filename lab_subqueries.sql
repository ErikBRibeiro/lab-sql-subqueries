SELECT COUNT(inventory.inventory_id) AS NumberOfCopies
FROM film
JOIN inventory ON film.film_id = inventory.film_id
WHERE film.title = 'Hunchback Impossible';

SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

SELECT actor.first_name, actor.last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
WHERE film_actor.film_id = (
    SELECT film.film_id
    FROM film
    WHERE film.title = 'Alone Trip'
);

SELECT film.title
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';

SELECT customer.first_name, customer.last_name, customer.email
FROM customer
WHERE customer.address_id IN (
    SELECT address.address_id
    FROM address
    WHERE address.city_id IN (
        SELECT city.city_id
        FROM city
        WHERE city.country_id = (
            SELECT country.country_id
            FROM country
            WHERE country.country = 'Canada'
        )
    )
);

SELECT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada';

SELECT film.title
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id = (
    SELECT actor_id
    FROM (
        SELECT actor_id, COUNT(*) AS film_count
        FROM film_actor
        GROUP BY actor_id
        ORDER BY film_count DESC
        LIMIT 1
    ) AS subquery
);

SELECT film.title
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.customer_id = (
    SELECT customer_id
    FROM (
        SELECT customer_id, SUM(amount) AS total_spent
        FROM payment
        GROUP BY customer_id
        ORDER BY total_spent DESC
        LIMIT 1
    ) AS subquery
);

SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total_amount)
    FROM (
        SELECT SUM(amount) AS total_amount
        FROM payment
        GROUP BY customer_id
    ) AS subquery
);
