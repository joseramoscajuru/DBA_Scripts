
By querying v$database one can tell if the host is primary or standby

For primary

select database_role from v$database;

DATABASE_ROLE
—————-
PRIMARY

For Standby – Note you may need to connect to as sys as sysdba if the instance is in mount state

select database_role from v$database;

DATABASE_ROLE
—————-
PHYSICAL STANDBY

OR

On Primary database the value of controlfile_type in V$database is “CURRENT” and standby is “STANDBY”

Value on Primary:

SQL> SELECT controlfile_type FROM V$database;

CONTROL
——–
CURRENT

Value on Standby:
SQL> SELECT controlfile_type FROM V$database;

CONTROL
——–
STANDBY
