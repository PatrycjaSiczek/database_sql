-- 0
create sequence empIdSequ
start with 26
increment by 1;

create table empTopN as select id, last_name, first_name, salary from emp;
create or replace package pracownicy as

-- 1
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

-- 2
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

-- 3
procedure deleteEmp(in_id emp.id%TYPE
);

-- 4 
procedure changeSalary(in_id emp.id%TYPE,
    in_percent number
);

-- 5     
procedure empTopN(in_n number
);

-- 6
procedure changeDept(in_id emp.id%TYPE,
    in_dept_id emp.dept_id%TYPE
);

-- 7
function statEmp(in_parameter varchar2
) return number;

END pracownicy;
/

create or replace package body pracownicy as

-- 1
procedure addEmp(in_last_name emp.last_name%TYPE,
    in_first_name emp.first_name%TYPE,
    in_userid emp.userid%TYPE,
    in_start_date emp.start_date%TYPE,
    in_manager_id emp.manager_id%TYPE,
    in_title emp.title%TYPE,
    in_dept_id emp.dept_id%TYPE,
    in_salary emp.salary%TYPE,
    in_commission_pct emp.commission_pct%TYPE)
is
    uv_last_name_null exception;
begin
    if in_last_name is null then
    raise uv_last_name_null;
    end if;
insert into emp(id, last_name, first_name, userid, start_date,
    manager_id, title, dept_id, salary, commission_pct)
select emp_id_seq.nextval, in_last_name, in_first_name, in_userid, in_start_date,
    in_manager_id, in_title, in_dept_id, in_salary, in_commission_pct
from emp;
exception 
when uv_last_name_null then
    dbms_output.put_line('last_name nie moze byc null');
when VALUE_ERROR then
    dbms_output.put_line('Zly format danych');
end addEmp;

-- 2
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
)
is
uv_last_name_null exception;
begin
    if in_last_name is null then
    RAISE uv_last_name_null;
    end if;
    update emp
    set last_name = in_last_name,
    first_name = in_first_name,
    userid = in_userid,
    start_date = in_start_date,
    manager_id = in_manager_id,
    title = in_title,
    dept_id = in_dept_id,
    salary = in_salary, 
    commission_pct = in_commission_pct
    where id = in_id;
exception 
when uv_last_name_null then
    dbms_output.put_line('last_name nie moze byc null');
when VALUE_ERROR then
    dbms_output.put_line('Zly format danych');
END changeEmp;

-- 3
procedure deleteEmp(in_id emp.id%TYPE)
is
begin
    delete from emp
    where id = in_id;
exception
when NO_DATA_FOUND then
    dbms_output.put_line('Nie znaleziono danych');
end deleteEmp;

-- 4
procedure changeSalary(in_id emp.id%TYPE,
    in_percent number)
is
begin
    update emp
    set salary = (salary + ((in_percent/100)*salary))
    where id = in_id;
end changeSalary;

-- 5
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

-- 6
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

-- 7
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
    elsif in_parameter = 'AVG' then
        select AVG(salary)
        into uv_value
        from emp;
    else 
        dbms_output.put_line('z³y parametr');
        uv_value := null;
    end if;
return uv_value;
exception
when NO_DATA_FOUND then
    dbms_output.put_line('nie znaleziono danych');
end statEmp;
        
end pracownicy;
/