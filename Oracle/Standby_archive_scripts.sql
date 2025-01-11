set lines 100
col name format a60
select	name
,	floor(space_limit / 1024 / 1024) "Size MB"
,	ceil(space_used  / 1024 / 1024) "Used MB"
from	v$recovery_file_dest
order by name
/

