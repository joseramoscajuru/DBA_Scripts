set echo off
set heading off
set feedback off
set verify off
set pagesize 0
set linesize 132

define schema=&1
define CR=chr(10)
define TAB=chr(9)
col x noprint
col y noprint

select  table_name y,
        0 x,
        'CREATE TABLE ' ||
        rtrim(table_name) ||
        '('
from    dba_tables
where   owner = upper('&schema')
union
select  tc.table_name y,
        column_id x,
        decode(column_id,1,'    ','   ,')||
        rtrim(column_name)|| &TAB || &TAB ||
        rtrim(data_type) ||
        rtrim(decode(data_type,'DATE',null,'LONG',null,
               'NUMBER',decode(to_char(data_precision),null,null,'('),
               '(')) ||
        rtrim(decode(data_type,
               'DATE',null,
               'CHAR',data_length,
               'VARCHAR2',data_length,
               'NUMBER',decode(to_char(data_precision),null,null,
                 to_char(data_precision) || ',' || to_char(data_scale)),
               'LONG',null,
               '******ERROR')) ||
        rtrim(decode(data_type,'DATE',null,'LONG',null,
               'NUMBER',decode(to_char(data_precision),null,null,')'),
               ')')) || &TAB || &TAB ||
        rtrim(decode(nullable,'N','NOT NULL',null))
from    dba_tab_columns tc,
        dba_objects o
where   o.owner = tc.owner
and     o.object_name = tc.table_name
and     o.object_type = 'TABLE'
and     o.owner = upper('&schema')
union
select  table_name y,
        999999 x,
        ')'  || &CR
        ||'  STORAGE('                                   || &CR
        ||'  INITIAL '    || initial_extent              || &CR
        ||'  NEXT '       || next_extent                 || &CR
        ||'  MINEXTENTS ' || min_extents                 || &CR
        ||'  MAXEXTENTS ' || max_extents                 || &CR
        ||'  PCTINCREASE '|| pct_increase                || ')' ||&CR
        ||'  INITRANS '   || ini_trans                   || &CR
        ||'  MAXTRANS '   || max_trans                   || &CR
        ||'  PCTFREE '    || pct_free                    || &CR
        ||'  PCTUSED '    || pct_used                    || &CR
        ||'  PARALLEL (DEGREE ' || rtrim(DEGREE) || ') ' || &CR
        ||'  TABLESPACE ' || rtrim(tablespace_name)      ||&CR
        ||'/'||&CR||&CR
from    dba_tables
where   owner = upper('&schema')
order by 1,2;