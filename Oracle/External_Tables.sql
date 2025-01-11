select a.TABLE_NAME, a.OWNER, b.LOCATION, b.DIRECTORY_NAME, c.DIRECTORY_PATH
from dba_tables a, dba_external_locations b, dba_directories c
where a.TABLE_NAME = b.TABLE_NAME
and b.DIRECTORY_NAME= c.DIRECTORY_NAME
and a.LAST_ANALYZED is null
and a.owner='CMISV'
order by 5; 

lock external table stats:

select 'execute DBMS_STATS.LOCK_TABLE_STATS ('''||a.owner||''', '''||a.table_name||''');'
from ALL_EXTERNAL_TABLES a, dba_tab_statistics b
where a.table_name = b.table_name and
      a.owner = b.owner and
      (b.STATTYPE_LOCKED <> 'ALL' or  b.STATTYPE_LOCKED is null)
/

Checking if all external tables have been locked:

select a.owner,a.table_name,b.STATTYPE_LOCKED
from ALL_EXTERNAL_TABLES a, dba_tab_statistics b
where a.table_name = b.table_name and
      a.owner = b.owner and
      (b.STATTYPE_LOCKED <> 'ALL' or  b.STATTYPE_LOCKED is null)
/
