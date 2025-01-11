#####|ORACLE_DB|Display all datafiles, tempfiles and logfiles (and their sizes)|######

set lines 100 pages 999
col name format a50
select name, bytes
from (select name, bytes
from v$datafile
union all
select name, bytes
from v$tempfile
union all
select lf.member "name", l.bytes
from v$logfile lf
, v$log l
where lf.group# = l.group#
union all
select name, 0
from v$controlfile) used
, (select sum(bytes) as p
from dba_free_space) free
/