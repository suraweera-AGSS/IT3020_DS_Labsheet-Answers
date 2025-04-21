--IT22339492_Lab07_Answers
--Create PLAN_TABLE
SQL> --Create PLAN_TABLE
SQL> @ C:\Users\sithu\Desktop\Downloads\IT3020_Prac07_supportfiles\utlxplan

--Output
Table Created!


--Create tables
SQL> -- Run the SampleDB.sql script to create tables
SQL> @ C:\Users\sithu\Desktop\Downloads\IT3020_Prac07_supportfiles\SampleDB

--Output : Tables and raws created successfully


---Alter the session
SQL> --Alter the session before proceed to see the CPU cost and IO costs.
SQL> ALTER SESSION SET OPTIMIZER_MODE = ALL_ROWS;

--Output
Session altered.

SQL> ALTER SESSION SET "_optimizer_cost_model"=CPU;

--Output
Session altered.



--(a)
SQL> -- Use EXPLAIN PLAN to find Oracle’s generated query plan
SQL>
SQL>     EXPLAIN PLAN FOR
  2      SELECT c.clno, c.name
  3      FROM client c, purch p
  4      WHERE c.clno = p.clno AND p.qty > 1000;

--Output
Explained.

--(b)
SQL> -- view the query plan and associated costs
SQL> @ C:\Users\sithu\Desktop\Downloads\IT3020_Prac07_supportfiles\utlxpls

--Output
Plan Table
--------------------------------------------------------------------------------
| Operation and options            |  Object  | cost     | cpu_cost | io_cost  |
--------------------------------------------------------------------------------
| SELECT STATEMENT                 |          | 5        |18009941  | 4        |
|  HASH JOIN                       |          | 5        |18009941  | 4        |
|   TABLE ACCESS FULL              |CLIENT    | 2        |7461      | 2        |
|   TABLE ACCESS FULL              |PURCH     | 2        |9721      | 2        |
--------------------------------------------------------------------------------

7 rows selected.

--(c)
SQL> -- Index on purch table
SQL> CREATE INDEX idx_purch_qty_clno ON purch(qty, clno);

--Output
Index created.

SQL> -- Index on client table
SQL> CREATE INDEX idx_client_clno_name ON client(clno, name);

--Output
Index created.

--(d)
SQL> --Re-run the EXPLAIN PLAN
SQL>
SQL> EXPLAIN PLAN FOR
  2  SELECT c.clno, c.name
  3  FROM client c, purch p
  4  WHERE c.clno = p.clno AND p.qty > 1000;

--Output
Explained.


SQL> @ C:\Users\sithu\Desktop\Downloads\IT3020_Prac07_supportfiles\utlxpls

Plan Table
--------------------------------------------------------------------------------
| Operation and options            |  Object  | cost     | cpu_cost | io_cost  |
--------------------------------------------------------------------------------
| SELECT STATEMENT                 |          | 3        |18007601  | 2        |
|  HASH JOIN                       |          | 3        |18007601  | 2        |
|   INDEX FULL SCAN                |IDX_CLIEN | 1        |7521      | 1        |
|   INDEX RANGE SCAN               |IDX_PURCH | 1        |7321      | 1        |
--------------------------------------------------------------------------------

7 rows selected.


SQL> -- Drop indexes if needed
SQL> --DROP INDEX idx_purch_qty_clno;
SQL> --DROP INDEX idx_client_clno_name;
SQL> --Check existing indexes
SQL> -- For client table
SQL> SELECT index_name
  2  FROM user_indexes
  3  WHERE table_name = 'CLIENT';

--Output
INDEX_NAME
------------------------------
SYS_C007247
IDX_CLIENT_CLNO_NAME


--Output
SQL> -- For purch table
SQL> SELECT index_name
  2  FROM user_indexes
  3  WHERE table_name = 'PURCH';

INDEX_NAME
------------------------------
SYS_C007251
IDX_PURCH_QTY_CLNO


--View index DDL
SQL> --View index DDL
SQL> SELECT DBMS_METADATA.GET_DDL('INDEX', u.index_name)
  2  FROM user_indexes u
  3  WHERE table_name = 'CLIENT';


--Output
DBMS_METADATA.GET_DDL('INDEX',U.INDEX_NAME)
--------------------------------------------------------------------------------

  CREATE UNIQUE INDEX "SYS"."SYS_C007247" ON "SYS"."CLIENT" ("CLNO")
  PCTFREE


  CREATE INDEX "SYS"."IDX_CLIENT_CLNO_NAME" ON "SYS"."CLIENT" ("CLNO", "NAME")










