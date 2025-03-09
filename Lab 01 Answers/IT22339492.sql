--Create client table

CREATE TABLE client (
    clno char(3),
    name varchar(12),
    address varchar(30)
);

ALTER TABLE client ADD PRIMARY KEY (clno);

--Create stock table

CREATE TABLE stock(
    company char(7) PRIMARY KEY,
    price number(6,2),
    dividend number(4,2),
    eps number(4,2)
);

--Create trading table

CREATE TABLE trading(
    company char(7),
    exchange varchar(12),
    PRIMARY KEY(company,exchange),
    FOREIGN KEY(company) REFERENCES stock(company)
);

--Create purchase table

CREATE TABLE purchase(
    clno char(3),
    company char(7),
    pdate date,
    qty number(6),
    price number(6,2),
    Primary key(clno,company,pdate),
    foreign key (clno) references client(clno),
    foreign key (company) references stock(company)
);

-- Insert data into client table
INSERT INTO client VALUES ('c01', 'John Smith', '3 East Av, Bentley, WA 6102');
INSERT INTO client VALUES ('c02', 'Jill Brody', '42 Bent St, Perth, WA 6001');

-- Insert data into stock table
INSERT INTO stock VALUES ('BHP', 10.50, 1.50, 3.20);
INSERT INTO stock VALUES ('IBM', 70.00, 4.25, 10.00);
INSERT INTO stock VALUES ('INTEL', 76.50, 5.00, 12.40);
INSERT INTO stock VALUES ('FORD', 40.00, 2.00, 8.50);
INSERT INTO stock VALUES ('GM', 60.00, 2.50, 9.20);
INSERT INTO stock VALUES ('INFOSYS', 45.00, 3.00, 7.80);

-- Insert data into trading table
INSERT INTO trading VALUES ('BHP', 'Sydney');
INSERT INTO trading VALUES ('BHP', 'New York');
INSERT INTO trading VALUES ('IBM', 'New York');
INSERT INTO trading VALUES ('IBM', 'London');
INSERT INTO trading VALUES ('IBM', 'Tokyo');
INSERT INTO trading VALUES ('INTEL', 'New York');
INSERT INTO trading VALUES ('INTEL', 'London');
INSERT INTO trading VALUES ('FORD', 'New York');
INSERT INTO trading VALUES ('GM', 'New York');
INSERT INTO trading VALUES ('INFOSYS', 'New York');

-- Insert data into purchase table

INSERT INTO purchase VALUES ('c01', 'BHP', TO_DATE('02-10-2001', 'DD-MM-YYYY'), 1000, 12.00);
INSERT INTO purchase VALUES ('c01', 'BHP', TO_DATE('08-06-2002', 'DD-MM-YYYY'), 2000, 10.50);
INSERT INTO purchase VALUES ('c01', 'IBM', TO_DATE('12-02-2000', 'DD-MM-YYYY'), 500, 58.00);
INSERT INTO purchase VALUES ('c01', 'IBM', TO_DATE('10-04-2001', 'DD-MM-YYYY'), 1200, 65.00);
INSERT INTO purchase VALUES ('c01', 'INFOSYS', TO_DATE('11-08-2001', 'DD-MM-YYYY'), 1000, 64.00);
INSERT INTO purchase VALUES ('c02', 'INTEL', TO_DATE('30-01-2000', 'DD-MM-YYYY'), 300, 35.00);
INSERT INTO purchase VALUES ('c02', 'INTEL', TO_DATE('30-01-2001', 'DD-MM-YYYY'), 400, 54.00);
INSERT INTO purchase VALUES ('c02', 'INTEL', TO_DATE('02-10-2001', 'DD-MM-YYYY'), 200, 60.00);
INSERT INTO purchase VALUES ('c02', 'FORD', TO_DATE('05-10-1999', 'DD-MM-YYYY'), 300, 40.00);
INSERT INTO purchase VALUES ('c02', 'GM', TO_DATE('12-12-2000', 'DD-MM-YYYY'), 500, 55.50);

select * from client
select * from stock
select * from trading
select * from purchase

--Question 3(a)

SELECT c.name, p.company, s.price, s.dividend, s.eps
FROM client c, purchase p, stock s
WHERE c.clno = p.clno AND p.company = s.company;

--Question 3(b)

SELECT c.name, p.company, SUM(p.qty), SUM(p.qty * p.price) / SUM(p.qty)
FROM client c, purchase p
WHERE c.clno = p.clno
GROUP BY c.name, p.company;

--Question 3(c)

SELECT p.company, c.name, SUM(p.qty) AS shares_held, SUM(p.qty * s.price) AS current_value
FROM client c, purchase p, stock s, trading t
WHERE c.clno = p.clno AND p.company = s.company AND s.company = t.company AND t.exchange = 'New York'
GROUP BY p.company, c.name;

--Question 3(d)

SELECT c.name, SUM(p.qty * p.price)
FROM client c, purchase p
WHERE c.clno = p.clno
GROUP BY c.name;

--Question 3(e)

SELECT c.name, SUM(p.qty * s.price) - SUM(p.qty * p.price)
FROM client c, purchase p, stock s
WHERE c.clno = p.clno AND p.company = s.company
GROUP BY c.name;
