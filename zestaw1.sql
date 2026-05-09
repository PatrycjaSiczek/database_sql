--1
SELECT * FROM dept;
    
--2
SELECT dept_id, last_name, manager_id FROM emp;
    
--3
SELECT last_name, salary*12 FROM emp;
    
--4
SELECT first_name, last_name, salary, (salary*12)+1000 FROM emp;
    
--5
SELECT first_name, last_name, (salary*1.08), (salary*12*1.08) FROM emp;
    
--6
SELECT last_name, (salary*12.05) "ROCZNY DOCHÓD" FROM emp;
    
--7
SELECT CONCAT(first_name, last_name) "Imię i nazwisko" FROM emp;
    
--8
SELECT first_name || last_name || title "Super pracownicy" FROM emp;
    
--9 niektóre rekordy mają null, ponieważ mnożenie nulla to dalej null
SELECT first_name, last_name, title, salary, (salary*commission_pct*0.01) FROM emp;
    
--10
SELECT first_name, last_name, title, salary, NVL((salary*commission_pct*0.01), 0) FROM emp;
    
--11
SELECT UNIQUE(name) FROM dept;

--12
SELECT last_name, dept_id, salary, start_date FROM emp
ORDER BY salary DESC;

--13
SELECT last_name, dept_id, start_date FROM emp
ORDER BY start_date ASC;

--14
SELECT first_name, last_name, title FROM emp
WHERE last_name='Patel';
    
--15
SELECT first_name, last_name, start_date FROM emp
WHERE start_date BETWEEN TO_DATE('02-05-1991','dd-mm-yyyy') AND TO_DATE('15-06-1991','dd-mm-yyyy')

--16
SELECT id, name, region_id FROM dept
WHERE region_id=1 OR region_id=3;


--17
SELECT * FROM emp
WHERE last_name LIKE 'M%';


--18
SELECT * FROM emp
WHERE NOT last_name LIKE '%a%';


--19
SELECT last_name, start_date FROM emp
WHERE start_date BETWEEN TO_DATE('01-01-1991','dd-mm-yy') AND TO_DATE('31-12-1991','dd-mm-yy');


--20
SELECT last_name FROM emp
WHERE last_name LIKE '_a%';

--21
SELECT name FROM customer
WHERE name LIKE '%s_o%';