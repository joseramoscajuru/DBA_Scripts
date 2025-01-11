
set trimspool on pagesize 0 lines 500
set echo off
set serveroutput off
set feedback off
set verify off
set term off
spool compress_remaining_tables.sh replace
select 'brspace -p initNSP.sap -c force -f tbreorg -a reorg -s PSAPDAT -o SAPDAT -t "'||table_name||'" -c ctablobind -n PSAPDAT_COMP -p 7'
from (
select num_rows,blocks,table_name
from dba_tables
where owner = 'SAPDAT'
and tablespace_name='PSAPDAT'
and table_name not in ('ARFCSSTATE','ARFCSDATA','ARFCRSTATE','TRFCQDATA','TRFCQIN','TRFCQOUT','TRFCQSTATE','QRFCTRACE','QRFCLOG','NRIV')
and compression = 'DISABLED'
and blocks is not null
order by 2 desc  )
/
spool off