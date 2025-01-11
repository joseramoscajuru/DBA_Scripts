How to determine history of DB startup in Oracle 11g

SQL> SELECT STARTUP_TIME FROM dba_hist_database_instance ORDER BY startup_time DESC;

STARTUP_TIME
—————————————————————————
29-SEP-13 03.43.07.000 AM
29-SEP-13 03.42.31.000 AM
29-SEP-13 03.12.45.000 AM
29-SEP-13 03.11.28.000 AM
28-SEP-13 11.56.35.000 PM
07-SEP-13 10.04.07.000 PM

6 rows selected.