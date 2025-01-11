####
Checar o quanto ser necessrio aumentar para a tablespace ficar abaixo do threshold de 80%:

set pages 999 lines 100
col    "Tablespace"    for a30
col    "Size MB"     for 999999999
col    "%Used"     for 999
col    "Add (80%)"     for 999999
select    tsu.tablespace_name "Tablespace"
,    ceil(tsu.used_mb) "Size MB"
,    100 - floor(tsf.free_mb/tsu.used_mb*100) "%Used"
,    ceil((tsu.used_mb - tsf.free_mb) / .8) - tsu.used_mb "Add (80%)"
,    tsu.autoextensible "AUTOEXT"
from    (select tablespace_name, sum(bytes)/1024/1024 used_mb, autoextensible
    from dba_data_files group by tablespace_name, autoextensible) tsu
,        (select ts.tablespace_name
    ,       nvl(sum(bytes)/1024/1024, 0) free_mb
    from    dba_tablespaces ts, dba_free_space fs
    where   ts.tablespace_name = fs.tablespace_name (+)
    group by ts.tablespace_name) tsf
where    tsu.tablespace_name = tsf.tablespace_name (+)
and    100 - floor(tsf.free_mb/tsu.used_mb*100) >= 80
order    by 3,4
/


### 80%
set pages 999 lines 100
col	"Tablespace"	for a50
col	"Size MB" 	for 999999999
col	"%Used" 	for 999
col	"Add (80%)" 	for 999999
select	tsu.tablespace_name "Tablespace"
,	ceil(tsu.used_mb) "Size MB"
,	100 - floor(tsf.free_mb/tsu.used_mb*100) "%Used"
,	ceil((tsu.used_mb - tsf.free_mb) / .8) - tsu.used_mb "Add (80%)"
from	(select tablespace_name, sum(bytes)/1024/1024 used_mb
	from    dba_data_files group by tablespace_name) tsu
,		(select ts.tablespace_name
	,       nvl(sum(bytes)/1024/1024, 0) free_mb
	from    dba_tablespaces ts, dba_free_space fs
	where   ts.tablespace_name = fs.tablespace_name (+)
	group by ts.tablespace_name) tsf
where	tsu.tablespace_name = tsf.tablespace_name (+)
and	100 - floor(tsf.free_mb/tsu.used_mb*100) >= 80
order	by 3,4
/

### 75%
set pages 999 lines 100
col	"Tablespace"	for a50
col	"Size MB" 	for 999999999
col	"%Used" 	for 999
col	"Add (75%)" 	for 999999
select	tsu.tablespace_name "Tablespace"
,	ceil(tsu.used_mb) "Size MB"
,	100 - floor(tsf.free_mb/tsu.used_mb*100) "%Used"
,	ceil((tsu.used_mb - tsf.free_mb) / .75) - tsu.used_mb "Add (75%)"
from	(select tablespace_name, sum(bytes)/1024/1024 used_mb
	from    dba_data_files group by tablespace_name) tsu
,		(select ts.tablespace_name
	,       nvl(sum(bytes)/1024/1024, 0) free_mb
	from    dba_tablespaces ts, dba_free_space fs
	where   ts.tablespace_name = fs.tablespace_name (+)
	group by ts.tablespace_name) tsf
where	tsu.tablespace_name = tsf.tablespace_name (+)
and	100 - floor(tsf.free_mb/tsu.used_mb*100) >= 75
order	by 3,4
/

### 79%
set pages 999 lines 100
col	"Tablespace"	for a50
col	"Size MB" 	for 999999999
col	"%Used" 	for 999
col	"Add (79%)" 	for 999999
select	tsu.tablespace_name "Tablespace"
,	ceil(tsu.used_mb) "Size MB"
,	100 - floor(tsf.free_mb/tsu.used_mb*100) "%Used"
,	ceil((tsu.used_mb - tsf.free_mb) / .79) - tsu.used_mb "Add (79%)"
from	(select tablespace_name, sum(bytes)/1024/1024 used_mb
	from    dba_data_files group by tablespace_name) tsu
,		(select ts.tablespace_name
	,       nvl(sum(bytes)/1024/1024, 0) free_mb
	from    dba_tablespaces ts, dba_free_space fs
	where   ts.tablespace_name = fs.tablespace_name (+)
	group by ts.tablespace_name) tsf
where	tsu.tablespace_name = tsf.tablespace_name (+)
and	100 - floor(tsf.free_mb/tsu.used_mb*100) >= 79
order	by 3,4
/
