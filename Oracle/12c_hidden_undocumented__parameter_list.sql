
ollowing query can be use to see hidden parameters:

set lines 1000
col ksppinm format a30
col ksppstvl format a10
SELECT x.ksppinm "Parameter",
       Y.ksppstvl "Session Value",
       Z.ksppstvl "Instance Value"
FROM   x$ksppi X,
       x$ksppcv Y,
       x$ksppsv Z
WHERE  x.indx = Y.indx
AND    x.indx = z.indx
AND    x.ksppinm LIKE '/_%' escape '/'
AND    x.ksppinm LIKE '%awr_disabled_flush_tables%'
order by x.ksppinm;


-- Here is how to list all of the Oracle 12c hidden undocumented parameters:

select 
   ksppinm, 
   ksppdesc 
from 
   x$ksppi 
where
   subsur(ksppinm,1,1) = '_'
order by 
   1,2;
   

How Can I list all Hidden Parameters set in The database?

col name for A45
set lines 120
col value for A40
set pagesize 100
select name, value from v$parameter where name like '\_%' escape '\';


How can I set the value of a hidden parameter?

alter system set "_pga_max_size"=5G scope=spfile sid='*';