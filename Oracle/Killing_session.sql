ALTER SYSTEM KILL SESSION 'sid,serial#' IMMEDIATE;

ALTER SYSTEM KILL SESSION '655,1340' IMMEDIATE;

ALTER SYSTEM KILL SESSION '334,146' IMMEDIATE;

ALTER SYSTEM KILL SESSION '343,34791' IMMEDIATE;

ALTER SYSTEM KILL SESSION '393,61027' IMMEDIATE;


ALTER SYSTEM KILL SESSION '713,894' IMMEDIATE;

ALTER SYSTEM KILL SESSION '32,7427' IMMEDIATE;


select 'ALTER SYSTEM KILL SESSION '''||sid||','||serial#||''' IMMEDIATE;'
from v$session
where username is not null
--   and status = 'ACTIVE'
--   and username not in ('SYS', 'SYSMAN', 'DBSNMP')
--   and last_call_et > 1500
/

select 'ALTER SYSTEM KILL SESSION '''||sid||','||serial#||''' IMMEDIATE;'
from v$session
where username is not null
and username not in ('SYS', 'SYSMAN', 'DBSNMP','SYSTEM')
/