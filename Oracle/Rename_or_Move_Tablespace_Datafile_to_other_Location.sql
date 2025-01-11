If the datafiles that need to be changed or moved do not belong to SYSTEM tablespaces, and do not contain active rollback segments or temporary segments, there is another workaround that does not require database instance to be shutdown. Instead, only the particular tablespace that contains the date files is taken offline.

Login to SQLPlus.

Connect as SYS DBA with CONNECT / AS SYSDBA command.

Make offline the affected tablespace with 

ALTER TABLESPACE <tablespace name> OFFLINE; 
    
Modify the name or location of datafiles in Oracle data dictionary using following command syntax:

ALTER TABLESPACE <tablespace name> RENAME DATAFILE ‘<fully path to original data file name>’ TO ‘<new or original fully path to new or original data file name>';

Bring the tablespace online again with 

ALTER TABLESPACE <tablespace name> ONLINE;



