--1
set echo on
DROP TABLE ocena CASCADE CONSTRAINTS;
DROP TABLE przedmiot CASCADE CONSTRAINTS;
DROP TABLE uczen CASCADE CONSTRAINTS;
DROP TABLE nauczyciel CASCADE CONSTRAINTS;
DROP TABLE klasa CASCADE CONSTRAINTS;
set echo off

--3
SELECT table_name FROM user_tables;

--4
DESCRIBE customer;
DESCRIBE item;
DESCRIBE orders;
DESCRIBE product;

--5
SELECT constraint_name, RPAD(constraint_type, 15) "CONSTRAINT_TYPE", search_condition
FROM user_constraints;

--6
--a) metoda kolumnowa:
CREATE TABLE warehouse(
w_id INTEGER NOT NULL,
amount INTEGER,
product_id INTEGER
CONSTRAINT id_product_fk
REFERENCES product(productid),
PRIMARY KEY(w_id)
);

--b) metoda tablicowa:
CREATE TABLE warehouse(
w_id INTEGER NOT NULL,
amount INTEGER,
product_id INTEGER,
PRIMARY KEY(w_id),
CONSTRAINT id_product_fk
FOREIGN KEY(product_id)
REFERENCES product(productid)
);

--c) metoda ALTER TABLE
--tworze tabelę
CREATE TABLE warehouse(
w_id INTEGER NOT NULL,
amount INTEGER,
product_id INTEGER,
PRIMARY KEY(w_id)
);

ALTER TABLE warehouse
ADD CONSTRAINT id_product_fk
FOREIGN KEY(product_id)
REFERENCES product(productid);

--7
ALTER TABLE customer
ADD CONSTRAINT unique_email
UNIQUE(email)

ALTER TABLE customer
ADD CONSTRAINT login_email
FOREIGN KEY(login)
REFERENCES customer(email);

--8
INSERT INTO customer VALUES (201, 'Robert', 'Kubica', 'Gleboka', '20-612', 'Lublin', 'rkubica', 'robert02', 'rkubica@gmail.com');
INSERT INTO customer VALUES (202, 'Robert', 'Lewandowski', 'Plytka', '25-678', 'Lubin', 'lewy123', 'prawy321', 'rlew@onet.pl');
INSERT INTO customer VALUES (203, 'Robert', 'Korzeniowski', 'Taka nijaka', '99-999', 'Lublinek', 'swietejpamieci', 'RIPkorzon', 'chodzebolubie@wp.pl');
INSERT INTO item VALUES (11,184,34);
INSERT INTO item VALUES (12,184,9875);
INSERT INTO orders VALUES (184,202,'26-05-2000',NULL,NULL);
INSERT INTO product VALUES (11,'maseczki',10,NULL,NULL,NULL);
INSERT INTO product VALUES (12,'papier toaletowy',20,NULL,NULL,NULL);

--9
SELECT * FROM customer;

--10
UPDATE customer
SET name = 'JuzNieRobert'
WHERE customer.name = 'Robert';

--11
SELECT * FROM customer;

--12
CREATE TABLE image 
(id                         NUMBER(7) 
   CONSTRAINT image_id_nn NOT NULL,
 format                     VARCHAR2(25),
 use_filename               VARCHAR2(1),
 filename                   VARCHAR2(255),
 image                      LONG RAW,
     CONSTRAINT image_id_pk
        PRIMARY KEY (id),
     CONSTRAINT image_format_ck
        CHECK (format in ('JFIFF', 'JTIFF')),
     CONSTRAINT image_use_filename_ck
        CHECK (use_filename in ('Y', 'N')));

INSERT INTO image VALUES (
   1001, 'JTIFF', 'Y', 'bunboot.tif', NULL);
INSERT INTO image VALUES (
   1002, 'JTIFF', 'Y', 'aceboot.tif', NULL);
INSERT INTO image VALUES (
   1003, 'JTIFF', 'Y', 'proboot.tif', NULL);
INSERT INTO image VALUES (
   1011, 'JTIFF', 'Y', 'bunpole.tif', NULL);
INSERT INTO image VALUES (
   1012, 'JTIFF', 'Y', 'acepole.tif', NULL);
INSERT INTO image VALUES (
   1013, 'JTIFF', 'Y', 'propole.tif', NULL);
INSERT INTO image VALUES (
   1291, 'JTIFF', 'Y', 'gpbike.tif', NULL);
INSERT INTO image VALUES (
   1296, 'JTIFF', 'Y', 'himbike.tif', NULL);
INSERT INTO image VALUES (
   1829, 'JTIFF', 'Y', 'safthelm.tif', NULL);
INSERT INTO image VALUES (
   1381, 'JTIFF', 'Y', 'probar.tif', NULL);
INSERT INTO image VALUES (
   1382, 'JTIFF', 'Y', 'curlbar.tif', NULL);
INSERT INTO image VALUES (
   1119, 'JTIFF', 'Y', 'baseball.tif', NULL);
INSERT INTO image VALUES (
   1223, 'JTIFF', 'Y', 'chaphelm.tif', NULL);
INSERT INTO image VALUES (
   1367, 'JTIFF', 'Y', 'grglove.tif', NULL);
INSERT INTO image VALUES (
   1368, 'JTIFF', 'Y', 'alglove.tif', NULL);
INSERT INTO image VALUES (
   1369, 'JTIFF', 'Y', 'stglove.tif', NULL);
INSERT INTO image VALUES (
   1480, 'JTIFF', 'Y', 'cabbat.tif', NULL);
INSERT INTO image VALUES (
   1482, 'JTIFF', 'Y', 'pucbat.tif', NULL);
INSERT INTO image VALUES (
   1486, 'JTIFF', 'Y', 'winbat.tif', NULL);
   
--13
INSERT INTO product (productid, name) SELECT id, filename FROM image;

--14
SELECT * from product;