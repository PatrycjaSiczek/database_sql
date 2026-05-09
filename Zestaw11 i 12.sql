Zestaw 11
SET SERVEROUTPUT ON

--1
DECLARE
licznik CONSTANT NUMBER := 3;
data DATE := TO_DATE('09-06-2024', 'DD/MM/YYYY');
napis VARCHAR2(20) := 'GOOD';
BEGIN
DBMS_OUTPUT.put_line(licznik);
DBMS_OUTPUT.put_line(data);
DBMS_OUTPUT.put_line(napis);
END;


--2
DECLARE
data DATE := TO_DATE('28-04-2005', 'DD/MM/YYYY');
datasys DATE := SYSDATE;
BEGIN
DBMS_OUTPUT.put_line(TO_CHAR(FLOOR(datasys - data))||' DNI');
DBMS_OUTPUT.put_line(TO_CHAR(FLOOR((datasys - data))/7)||' TYGODNI');
DBMS_OUTPUT.put_line(TO_CHAR(FLOOR(datasys - data)/365)||' LAT');
END;

--3
DECLARE
name emp.fisrt_name%type;
last_name emp.last_name%type;
BEGIN
SELECT first_name, last_name
INTO name, last_name
FROM emp
WHERE salary = (SELECT MAX(salary) FROM emp);
DBMS_OUTPUT_LINE('MAX: '||name||' '||last_name);
SELECT fisrt_name, last_name
INTO name, last_name
FROm emp
WHERE salary = (SELECT MIN(salary) FROM emp);
DBMS_OUTPUT.PUT_LINE('MIN: '||VAR_NAME|| ' ' ||last_name);
EXCEPTION
WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('brak');
WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('za duzo');
END;

--4
--a
DECLARE
name VARCHAR(20);
last_name VARCHAR(20);
CURSOR i IS SELECT first_name, last_name FROM emp;
BEGIN 
OPEN i;
LOOP
FETCH i INTO name, last_name;
EXIT WHEN i%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(i%ROWCOUNT||' ' ||name||last_name);
END LOOP;
CLOSE i;
END;

--b
BEGIN 
FOR i IN(SELECT id, first_name, last_name FROM emp)
LOOP DbMS_OUTPUT.PUT_LINE(i.id||' '||i.first_name||' '||i.last_name);
END LOOP;
END;

--5
DECLARE 
od DATE := TO_DATE('01/03/2000', 'DD/MM/YYYY');
doo DATE := TO_DATE('01/04/2000', 'DD/MM/YYYY');
id1 ord.id%TYPE;
customer_id1 ord.customer_id%TYPE;
sales_rep_id ord.sales_rep_id%TYPE;
dateord ord.date_ordered%TYPE;
total1 ord.total%TYPE;
customer_name1 customer.name%TYPE;
CURSOR i IS
SELECT id, customer_id, sales_rep_id, date_ordered
FROM ord WHERE date_ordered > od AND date_ordered <doo;

BEGIN
OPEN i;
 LOOP
 FETCH i INTO id1, customer_id1, sales_rep_id, dateord, total1;
 EXIT WHEN i%NOTFOUND;
 SELECT first_name, last_name
 FROM emp where id = vsales_rep_last_name
 FROm emp WHERE id = sales_rep_id;
 SELECT name
 INTO customer_name1
 FROm customer WHERE id = customer_id1;
 DBMS_OUTPUT.PUT_LINE(i%ROWCOUNT || 'id' || id1|| 'imie '||customer_name1||' data zamowienia' ||
 dateord);
 END LOOP;
 CLOSE i;
END; 

--6
DECLARE
n NUMBER;
BEGIN
SELECT AVG(salary) 
INTO n
FROM emp_new;
FOR i IN (SELECT * FROM emp_new ORDER BY salary)
LOOP 
IF(i.salary< n/2) THEN UPDATE emp SET salary = (salary*1.2) WHERE id = i.id;
ELSIF(i.salary <= n/2 AND i.salary > n * (5/6)) THEN 
UPDATE emp_new SET salary = (salary*1.1) WHERE id = i.id;
ELSE
UPDATE emp_new SET SALARY = (salary*1.05) WHERE id = i.id;
END if;
END LOOP;
END;

Zestaw 12

--1
create table empTopN as select id, last_name, first_name, salary from emp;
create or replace package pracownicy as

--2
procedure addEmp (in_last_name emp.last_name%TYPE,
    in_first_name emp.first_name%TYPE,
    in_userid emp.userid%TYPE,
    in_start_date emp.start_date%TYPE,
    in_manager_id emp.manager_id%TYPE,
    in_title emp.title%TYPE,
    in_dept_id emp.dept_id%TYPE,
    in_salary emp.salary%TYPE,
    in_commission_pct emp.commission_pct%TYPE
);

-- 3
procedure changeEmp(in_id emp.id%TYPE,
    in_last_name emp.last_name%TYPE,
    in_first_name emp.first_name%TYPE,
    in_userid emp.userid%TYPE,
    in_start_date emp.start_date%TYPE,
    in_manager_id emp.manager_id%TYPE,
    in_title emp.title%TYPE,
    in_dept_id emp.dept_id%TYPE,
    in_salary emp.salary%TYPE,
    in_commission_pct emp.commission_pct%TYPE
);

-- 4
procedure deleteEmp(in_id emp.id%TYPE)
is
begin
    delete from emp
    where id = in_id;
exception
when NO_DATA_FOUND then
    dbms_output.put_line('Nie znaleziono danych');
end deleteEmp;

-- 5
procedure changeSalary(in_id emp.id%TYPE,
    in_percent number)
is
begin
    update emp
    set salary = (salary + ((in_percent/100)*salary))
    where id = in_id;
end changeSalary;

-- 6
procedure empTopN(in_n number)
is
    uv_last_name emp.last_name%TYPE;
    uv_first_name emp.first_name%TYPE;
    uv_salary emp.salary%TYPE;

cursor cTopN is
    select last_name, first_name, salary 
    from (select last_name, first_name, salary from emp order by salary desc)
    whenwhere ROWNUM <= in_n;
begin
    open cTopN;

loop
    fetch cTopN into uv_last_name, uv_first_name, uv_salary;
    exit when cTopN%notfound;
        dbms_output.put_line(uv_last_name ||' '|| uv_first_name ||' '|| uv_salary);
        insert into empTopN(last_name, first_name, salary)
        select uv_last_name, uv_first_name, uv_salary
        from empTopN;
        
end loop;
close cTopN;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('Nie znaleziono danych');
end empTopN;

-- 7
procedure changeDept(in_id emp.id%TYPE,
in_dept_id emp.dept_id%TYPE)
is  
update emp
set dept_id = in_dept_id
where id = in_id;
exception
when uv_deptid_not_exist then
    dbms_output.put_line('dept_id nie istnieje');
end changeDept;

-- 8
function statEmp(in_parameter varchar2) return number
as
uv_value emp.salary%TYPE;
begin
    if in_parameter = 'MAX' then
        select max(salary)
        into uv_value
        from emp;
    elsif in_parameter = 'MIN' then
        select min(salary)
        into uv_value
        from emp;
    elsif in_parameter = 'SUM' then
        selrct SUM(salary)
        into uv_value
        from emp;
    else in_parameter = 'AVG' then
        select AVG(salary)
        into uv_value
        from emp;
return uv_value;
end statEmp;
        
end pracownicy;
/