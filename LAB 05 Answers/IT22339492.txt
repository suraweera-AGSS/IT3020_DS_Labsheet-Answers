--IT22339492

--EXERCISE 01

DECLARE
       v_company_name VARCHAR2(10) := 'IBM';
       v_current_price NUMBER(6,2);
 BEGIN
      SELECT c_price
      INTO v_current_price
      FROM stock
      WHERE company = v_company_name;
 
      DBMS_OUTPUT.PUT_LINE('Current price of ' || v_company_name || ' stock: ' || v_current_price);
     END;
   /

--EXERCISE 02

-- To see the results
set serveroutput on  

DECLARE
    v_company_name VARCHAR2(10) := 'IBM';
    v_current_price NUMBER(6,2);
    v_message VARCHAR2(50);
BEGIN
    
    SELECT c_price 
    INTO v_current_price
    FROM stock
    WHERE company = v_company_name;

    
    IF v_current_price < 45 THEN
        v_message := 'Current price is very low !';
    ELSIF v_current_price >= 45 AND v_current_price < 55 THEN
        v_message := 'Current price is low !';
    ELSIF v_current_price >= 55 AND v_current_price < 65 THEN
        v_message := 'Current price is medium !';
    ELSIF v_current_price >= 65 AND v_current_price < 75 THEN
        v_message := 'Current price is medium high !';
    ELSE
        v_message := 'Current price is high !';
    END IF;

    -- Display the result
    DBMS_OUTPUT.PUT_LINE('Company: ' || v_company_name);
    DBMS_OUTPUT.PUT_LINE('Stock Price: ' || v_current_price);
    DBMS_OUTPUT.PUT_LINE('Message: ' || v_message);
END;
/

--EXERCISE 03

BEGIN
       <<i_loop>> FOR i IN REVERSE 1 .. 9 LOOP
          <<j_loop>> FOR j IN 1 .. i LOOP
               DBMS_OUTPUT.PUT(i || ' ');
               END LOOP;
            DBMS_OUTPUT.NEW_LINE;
         END LOOP;
    END;
    /


-- EXERCISE 04

DECLARE
    CURSOR purchase_cursor IS
        SELECT client_id, stock_id, purchase_date, quantity 
        FROM purchase;

    bonus NUMBER;  -- Variable to hold bonus value

BEGIN
    FOR rec IN purchase_cursor LOOP
       
        IF rec.purchase_date < TO_DATE('01-JAN-2000', 'DD-MON-YYYY') THEN
            bonus := 150;
        ELSIF rec.purchase_date < TO_DATE('01-JAN-2001', 'DD-MON-YYYY') THEN
            bonus := 100;
        ELSIF rec.purchase_date < TO_DATE('01-JAN-2002', 'DD-MON-YYYY') THEN
            bonus := 50;
        ELSE
            bonus := 0;  -- No bonus for purchases after 1st January 2002
        END IF;

        -- Update the purchase table if a bonus is applicable
        IF bonus > 0 THEN
            UPDATE purchase
            SET quantity = quantity + bonus
            WHERE client_id = rec.client_id
              AND stock_id = rec.stock_id
              AND purchase_date = rec.purchase_date;
        END IF;
    END LOOP;

    -- Check if any rows were updated and output the result
    IF SQL%NOTFOUND THEN
        dbms_output.put_line('No quantities were updated.');
    ELSE
        dbms_output.put_line('Quantities updated successfully.');
    END IF;

END;
/


--EXERCISE 05

DECLARE
    -- Declare explicit cursor 
    CURSOR purchase_cursor IS
        SELECT client_id, stock_id, purchase_date, quantity
        FROM purchase;
    
    -- Variables to store the data 
    v_client_id purchase.client_id%TYPE;
    v_stock_id purchase.stock_id%TYPE;
    v_purchase_date purchase.purchase_date%TYPE;
    v_quantity purchase.quantity%TYPE;
    
    
    bonus NUMBER := 0;

BEGIN
    -- Open the cursor
    OPEN purchase_cursor;
    
    -- Loop through all records fetched by the cursor
    FETCH purchase_cursor INTO v_client_id, v_stock_id, v_purchase_date, v_quantity;

    -- While loop to process each record
    WHILE purchase_cursor%FOUND LOOP
        -- Check the purchase date and assign bonus accordingly
        IF v_purchase_date < TO_DATE('01-JAN-2000', 'DD-MON-YYYY') THEN
            bonus := 150;
        ELSIF v_purchase_date < TO_DATE('01-JAN-2001', 'DD-MON-YYYY') THEN
            bonus := 100;
        ELSIF v_purchase_date < TO_DATE('01-JAN-2002', 'DD-MON-YYYY') THEN
            bonus := 50;
        ELSE
            bonus := 0;  -- No bonus for purchases after 1st January 2002
        END IF;

        -- Update the purchase table if a bonus is applicable
        IF bonus > 0 THEN
            UPDATE purchase
            SET quantity = v_quantity + bonus
            WHERE client_id = v_client_id
              AND stock_id = v_stock_id
              AND purchase_date = v_purchase_date;
        END IF;

        -- Fetch the next record
        FETCH purchase_cursor INTO v_client_id, v_stock_id, v_purchase_date, v_quantity;
    END LOOP;

    -- Close the cursor
    CLOSE purchase_cursor;

    -- Check if any rows were updated and output the result
    IF SQL%NOTFOUND THEN
        dbms_output.put_line('No quantities were updated.');
    ELSE
        dbms_output.put_line('Quantities updated successfully.');
    END IF;

    COMMIT;
END;
/

