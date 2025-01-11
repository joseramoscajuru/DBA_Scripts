
sqlplus rman@RMAN 

SQL>  SELECT db_key, dbid, name FROM rman.rc_database WHERE name ='myDB' ORDER BY DBID ;

    DB_KEY       DBID NAME
---------- ---------- --------
     11349 2790586635 myDB
   1179854 2800799356 myDB

SQL> EXECUTE rman.dbms_rcvcat.unregisterdatabase(11349,2790586635) ;

https://dba.stackexchange.com/questions/73237/delete-backups-from-old-incarnation-in-rman

