--1
SELECT id, total FROM ord
WHERE total = (SELECT MAX(total) FROM ord);

--2
SELECT * FROM ord
WHERE total = (SELECT MAX(total) FROM ord WHERE payment_type='CASH');

--3
SELECT * FROM ord
WHERE total > (SELECT AVG(total) FROM ord);
    
--4
SELECT name, suggested_whlsl_price FROM product
WHERE suggested_whlsl_price < (SELECT AVG(suggested_whlsl_price) FROM product WHERE name LIKE 'Prostar%'); 
    
--5
SELECT warehouse_id, product_id, amount_in_stock FROM inventory
WHERE (warehouse_id, amount_in_stock) IN 
    (SELECT warehouse_id, MAX(amount_in_stock)
        FROM inventory
        GROUP BY warehouse_id);
-- Magazyn 301 wystepuje dwukrotnie, ponieważ dwa rekordy posiadajı amount_in_stock = 102

--6
SELECT warehouse_id, product_id, amount_in_stock FROM inventory I1
WHERE amount_in_stock = (SELECT MAX(amount_in_stock) FROM inventory I2 WHERE I1.warehouse_id = I2.warehouse_id);

--7
SELECT W.city, P.name, I1.amount_in_stock FROM product P, warehouse W, inventory I1
WHERE I1.amount_in_stock = (SELECT MAX(amount_in_stock) FROM inventory I2 WHERE I1.warehouse_id = I2.warehouse_id) AND W.id = I1.warehouse_id AND P.id = I1.product_id;
    
--8
SELECT name FROM customer
WHERE NOT EXISTS (SELECT * FROM ord WHERE ord.customer_id = customer.id);

--9
SELECT customer.id, customer.name, ord.id FROM customer, ord
WHERE EXISTS (SELECT * FROM ord WHERE ord.customer_id = customer.id) AND customer.id = ord.customer_id
ORDER BY customer.id;
    
--10
SELECT customer_id, id FROM ord
ORDER BY customer_id;

--11
SELECT emp.last_name FROM emp
WHERE emp.last_name IN (SELECT last_name FROM emp, ord WHERE emp.id = ord.sales_rep_id AND ord.id < 100);

--12
SELECT emp.last_name FROM emp, ord
WHERE emp.id = ord.sales_rep_id AND ord.id < 100;

    
--13
SELECT first_name || ' ' || last_name "Imie i nazwisko" FROM emp
WHERE (SELECT COUNT(ord.id) FROM ord WHERE ord.sales_rep_id = emp.id) > 3; 