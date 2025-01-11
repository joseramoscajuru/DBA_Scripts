
ALTER SESSION SET statistics_level=ALL;

SELECT * FROM TABLE (DBMS_XPLAN.display_cursor ('&sql_id', NULL, 'ADVANCED'));
