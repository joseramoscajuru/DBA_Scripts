http://www.oracle-wiki.net/startscriptcheckfrag

--
-- Check for Index Fragmentation
--
 
ACCEPT MySchema PROMPT 'Enter schema to be analysed: '
 
set term off
set feedback off
 
drop table analyze_strut_commands
 
create table analyze_strut_commands (
line_id  number,
sql_text varchar2(2000));
 
drop table frag_stats_all
 
create table frag_stats_all as
select *
from   index_stats
where  1 = 2;
 
set term on
prompt creating validation scripts ...
set term off
 
declare
    cursor ind_cur IS
       select owner
       ,      index_name
       from   dba_indexes where owner=upper('&&MySchema')
       order by owner
       ,        index_name;
 
    l_sql_text         varchar2(500);
    l_curr_line_id     number(38) := NULL;
 
begin
    declare
           function write_out (
           p_line_id     IN  NUMBER,
           p_sql_text    IN  VARCHAR2 ) return NUMBER
           is
           l_line_id   number(38) := null;
           begin
             insert into analyze_strut_commands
             values(p_line_id,p_sql_text);
             commit;
             l_line_id := p_line_id + 1;
             return(l_line_id);
           end write_out;
    begin
           l_curr_line_id := write_out(1,'-- start');
           for ind_rec in ind_cur LOOP
                --
                -- Firs get the prompts
                --
                l_sql_text := 'prompt ... processing index '||
                               ind_rec.owner||
                               '.'||
                               ind_rec.index_name||
                               ' ...';
                l_curr_line_id := write_out(l_curr_line_id,l_sql_text);
                --
                -- Second get the analyze commands
                --
                l_sql_text := 'analyze index '||
                               ind_rec.owner||
                               '.'||
                               ind_rec.index_name||
                               ' validate structure;';
                l_curr_line_id := write_out(l_curr_line_id,l_sql_text);
                --
                -- Third get the current statistics before it gets overwritten
                --
                l_sql_text := 'insert into frag_stats_all select * from index_stats;';
                l_curr_line_id := write_out(l_curr_line_id,l_sql_text);
           end loop;
           --
           -- commit the whole thing
           --
           l_curr_line_id := write_out(l_curr_line_id,'commit;');
    end;
end;
/
 
set pages 0
col sql_text format a132
 
select sql_text from analyze_strut_commands
order by line_id
 
spool ind.tmp
/
spool off
 
set term on
prompt running validation scripts ...
 
@ind.tmp
 
drop table analyze_strut_commands
/
 
!rm ind.tmp
 
set pause on;
pause Press any key to review the results
set pause off
 
SET VERIFY OFF
SET FEEDBACK OFF
 
COL name HEA 'Index Name' FOR a30
COL del_lf_rows HEAd 'Deleted|Leaf Rows' FOR 99999999
COL lf_rows_used HEA 'Used|Leaf Rows' FOR 99999999
COL ratio HEAd '% Deleted|Leaf Rows' FOR 999.99999
 
SET VERIFY ON
SET FEEDBACK ON
 
SELECT
   name, del_lf_rows, lf_rows - del_lf_rows lf_rows_used,
   DECODE(lf_rows,0,0,TO_CHAR( del_lf_rows / (lf_rows)*100,'999.99999' )) ratio
FROM
   frag_stats_all
ORDER BY
   4
/