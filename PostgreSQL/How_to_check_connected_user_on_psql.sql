
To get information about current connection from the psql command prompt:

\conninfo

To change user:

\c - a_new_user

‘-’ substitutes for the current database.

To change database and user:

\c a_new_database a_new_user

The SQL command to get this information:

SELECT session_user, current_user;

Edit: To make things simpler, I define the following alias in my ~/.psqlrc:

\set whoami 'SELECT session_user, current_user, :''HOST'' host, :''PORT'' port, :''DBNAME'' dbname;'

postgres=# :whoami
 session_user | current_user | host | port |  dbname  
--------------+--------------+------+------+----------
 postgres     | postgres     | /tmp | 5432 | postgres
(1 row)
