--1 (skrypt)
set echo off

alter session set nls_date_language='american';
alter session set nls_date_format='dd-mon-yyyy';
alter session set nls_numeric_characters='.,';

Rem Drop tables.
DROP TABLE customer cascade constraints;
DROP TABLE orders cascade constraints;
DROP TABLE item cascade constraints;
DROP TABLE product cascade constraints;

Rem Create and populate tables.

CREATE TABLE customer 
(customerID                     INTEGER 
   CONSTRAINT customer_pesel_nn NOT NULL,
 name                    VARCHAR2(25) 
   CONSTRAINT customer_name_nn NOT NULL,
 surname                     	VARCHAR2(35)
   CONSTRAINT customer_surname_nn NOT NULL,
 addr_street                    VARCHAR2(45),
 addr_zip                    CHAR(5),
 addr_city                    VARCHAR2(45),
 login                    VARCHAR2(14)
   CONSTRAINT customer_login_nn NOT NULL,
 passwd                    VARCHAR2(12)
   CONSTRAINT customer_passwd_nn NOT NULL,
     CONSTRAINT customer_customerid_pk PRIMARY KEY (customerID));
 
CREATE TABLE orders 
(orderID                         INTEGER 
   CONSTRAINT orders_orderid_nn NOT NULL,
 IDcustomer                       INTEGER 
   CONSTRAINT orders_idcustomer_nn NOT NULL,
 orDATE                  DATE,
     CONSTRAINT orders_id_kat_pk PRIMARY KEY (orderID));
 
CREATE TABLE item 
(IDproduct                    INTEGER 
	CONSTRAINT item_idproduct_nn NOT NULL,
 IDorder                  INTEGER
	CONSTRAINT item_idorder_nn NOT NULL,
 quantity                 	INTEGER,
	CONSTRAINT item_double_pk PRIMARY KEY (IDproduct, IDorder));

CREATE TABLE product 
(productID                    INTEGER 
	CONSTRAINT product_productid_nn NOT NULL,
 name                  VARCHAR2(35) 
	CONSTRAINT product_pesel_nn NOT NULL,
 price_net                 	FLOAT,
 price_gross                     FLOAT,
 description						CLOB,
	CONSTRAINT product_productid_pk PRIMARY KEY (productID));

Rem Add foreign key constraints.

ALTER TABLE orders 
   ADD CONSTRAINT orders_customer_id_fk
   FOREIGN KEY (IDcustomer) REFERENCES customer (customerID);
ALTER TABLE item 
   ADD CONSTRAINT item_ord_id_fk
   FOREIGN KEY (IDorder) REFERENCES orders (orderID);
ALTER TABLE item 
   ADD CONSTRAINT item_product_id_fk
   FOREIGN KEY (IDproduct) REFERENCES product (productID);

set echo on

--2
--1
ALTER TABLE customer
	ADD email VARCHAR2(20) constraint;

--2
ALTER TABLE customer
	RENAME COLUMN addr_zip TO addr_postalcode;  
ALTER TABLE customer
    MODIFY addr_postalcode CHAR(7);
	
--3
ALTER TABLE orders
    ADD order_filled VARCHAR2(1);
ALTER TABLE orders
    ADD CONSTRAINT ord_order_filled_ck 
        CHECK (order_filled in ('Y', 'N'));
		
--4 
ALTER TABLE orders
	ADD date_shipped DATE; --DATE przechowuje informacje o godzinie, żeby je potem wydobyć 
						   --wystarczy wyświetlić datę w formie TO_DATE(date_ordered,'YYYY-MON-DD HH24:MI')
	
--5 Pomyślałem, żeby zmienić informację czy zamówienie zrealizowane na kolumnę ze statusem zamówienia.
ALTER TABLE orders
	RENAME COLUMN order_filled TO status;
ALTER TABLE orders
    MODIFY status VARCHAR2(25);
ALTER TABLE orders
    DROP CONSTRAINT ord_order_filled_ck;
ALTER TABLE orders
    ADD CONSTRAINT ord_status_ck
        CHECK (status in('Nowe zamówienie', 'Realizowane', 'Przesyłka wysłana', 'Realizacja zakończona'));
		
--6
ALTER TABLE product
	ADD tax INTEGER;
ALTER TABLE product
    DROP COLUMN price_gross;
ALTER TABLE product
    ADD price_gross FLOAT AS(price_net+price_net*tax*0.01);
	
	
--7
CREATE INDEX customer_ix
    ON customer (surname, login, email);
	
--8
ALTER TABLE customer
    ADD CONSTRAINT login_u UNIQUE (login);