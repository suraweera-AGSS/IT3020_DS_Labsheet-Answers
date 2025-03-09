--IT22339492--
--Lab04 Answers--

--DROP TYPE BODY stock_t;
--DROP TYPE BODY client_t;

ALTER TYPE stock_t 
ADD MEMBER FUNCTION calculate_yield 
RETURN NUMBER CASCADE;

ALTER TYPE stock_t 
ADD MEMBER FUNCTION convert_to_usd(exchange_rate NUMBER) 
RETURN NUMBER CASCADE;

ALTER TYPE stock_t 
ADD MEMBER FUNCTION count_exchanges 
RETURN NUMBER CASCADE;

ALTER TYPE client_t 
ADD MEMBER FUNCTION calculate_purchase_value 
RETURN NUMBER CASCADE;

ALTER TYPE client_t 
ADD MEMBER FUNCTION calculate_total_profit 
RETURN NUMBER CASCADE;


CREATE OR REPLACE TYPE BODY stock_t AS
    MEMBER FUNCTION calculate_yield 
    RETURN NUMBER 
    IS
    BEGIN
        RETURN (self.dividend / self.c_price) * 100;
    END calculate_yield;

    MEMBER FUNCTION convert_to_usd(exchange_rate NUMBER) 
    RETURN NUMBER 
    IS
    BEGIN
        RETURN self.c_price * exchange_rate;
    END convert_to_usd;

    MEMBER FUNCTION count_exchanges 
    RETURN NUMBER 
    IS
    BEGIN
        RETURN self.exchanges.COUNT;
    END count_exchanges;
END;
/

CREATE OR REPLACE TYPE BODY client_t AS
    MEMBER FUNCTION calculate_purchase_value 
    RETURN NUMBER 
    IS
    BEGIN
        SELECT SUM(i.price * i.Qty)
        INTO total_value
        FROM TABLE(self.investments) i;
        RETURN total_value;
    END calculate_purchase_value;

    MEMBER FUNCTION calculate_total_profit 
    RETURN NUMBER 
    IS
    BEGIN
        
        SELECT SUM((DEREF(i.company).c_price - i.price) * i.Qty)
        INTO total_profit
        FROM TABLE(self.investments) i;
        RETURN total_profit;
    END calculate_total_profit;
END;
/

--(a)
SELECT s.company AS stock_name,
       s.exchanges AS exchanges,
       s.calculate_yield() AS yield,
       s.convert_to_usd(0.74) AS price_in_usd
FROM stock s;


--(b)
SELECT s.company AS stock_name,
       s.c_price AS current_price,
       s.count_exchanges() AS num_exchanges
FROM stock s
WHERE s.count_exchanges() > 1;


--(c)
SELECT c.name AS client_name,
       DEREF(i.company).company AS stock_name,
       DEREF(i.company).calculate_yield() AS yield,
       DEREF(i.company).c_price AS current_price,
       DEREF(i.company).shares AS earnings_per_share
FROM client c, TABLE(c.investments) i;


--(d)
SELECT c.name AS client_name,
       c.calculate_purchase_value() AS total_purchase_value
FROM client c;

--(e)
SELECT c.name AS client_name,
       c.calculate_total_profit() AS book_profit
FROM client c;
