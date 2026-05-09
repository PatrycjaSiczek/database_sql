--1
SELECT first_name, last_name, salary FROM emp
WHERE salary<1300
ORDER BY last_name;

--2
SELECT date_ordered || ' | ' || total "Data zamowienia ||| wartosc" FROM ord;

--3
SELECT first_name, last_name FROM emp
WHERE title='Stock Clerk' AND salary > (SELECT AVG(salary) FROM emp WHERE title='Warehouse Manager');

--4
SELECT COUNT(*) "Liczba pracowników" FROM emp
WHERE salary < (SELECT AVG(salary) FROM emp);

--5
SELECT first_name, last_name, start_date FROM emp
WHERE START_DATE < '01-mar-1991' --taki format daty jest u mnie domyślnie ustawiony
ORDER BY START_DATE ASC;

--6
SELECT emp.id, SUM(total) FROM emp, ord
WHERE emp.id = ord.sales_rep_id
GROUP BY emp.id;

--7 
SELECT * FROM (SELECT emp.id, SUM(total) FROM emp, ord WHERE emp.id = ord.sales_rep_id GROUP BY emp.id)
WHERE rownum = 1;

--8
SELECT last_name FROM (SELECT last_name, SUM(total) FROM emp, ord WHERE emp.id = ord.sales_rep_id GROUP BY emp.id, last_name)
WHERE rownum = 1;

--9
SELECT start_date, COUNT(start_date) FROM emp
GROUP BY start_date
ORDER BY start_date ASC;

--10
SELECT product.name FROM product, inventory
WHERE product.id = inventory.product_id AND amount_in_stock = 0 AND out_of_stock_explanation IS NOT NULL;

--11
SELECT product.name FROM product, inventory 
WHERE product.id=inventory.product_id
GROUP BY inventory.product_id, product.name
HAVING SUM(inventory.amount_in_stock) < 500;

--12 

SELECT product.name FROM product
WHERE name LIKE '% % %' AND name NOT LIKE '% % % %';
-- druga wersja, zmyślna i chyba niepotrzebna
SELECT product.name FROM product
WHERE LENGTH(name) - LENGTH(REPLACE(name, ' ', '')) = 2;