B.2 Checking if Oracle Database Vault Is Enabled or Disabled

You can check if Oracle Database Vault has already been enabled or disabled by querying the V$OPTIONS table. Any user can query this table. If Oracle Database Vault is enabled, the query returns TRUE. Otherwise, it returns FALSE.

For example:

SQL> SELECT * FROM V$OPTION WHERE PARAMETER = 'Oracle Database Vault';

PARAMETER                     VALUE
----------------------------- -----------------------
Oracle Database Vault         TRUE

https://web.stanford.edu/dept/itss/docs/oracle/10gR2/server.102/b25166/dvdisabl.htm
