select /*+ ordered */ 
       fcp.user_concurrent_program_name
,      fcr.request_id
,      round(24*60*( sysdate - actual_start_date )) elapsed
,      fu.user_name
,      fcr.oracle_process_id
,      sess.sid
,      sess.serial#
,      inst.inst_name
,      sa.sql_text
,      cp.plsql_dir || '/' || cp.plsql_out outfile_tmp
,      cp.plsql_dir || '/' || cp.plsql_log logfile_tmp
from   apps.fnd_concurrent_requests fcr
,      apps.fnd_concurrent_programs_tl fcp
,      apps.fnd_concurrent_processes cp
,      apps.fnd_user fu
,      gv$process pro
,      gv$session sess
,      gv$sqlarea sa
,      sys.v_$active_instances inst
where  fcp.concurrent_program_id = fcr.concurrent_program_id
and    fcp.application_id = fcr.program_application_id
and    fcr.controlling_manager = cp.concurrent_process_id
and    fcr.requested_by = fu.user_id (+)
and    fcr.oracle_process_id = pro.spid (+)
and    pro.addr = sess.paddr (+)
and    sess.sql_address = sa.address (+)
and    sess.sql_hash_value = sa.hash_value (+)
and    sess.inst_id = inst.inst_number (+)
and    fcr.phase_code = 'R' 

---- Monitoramento da TEMP

script para monitorar tablespace temporria:

select * from (select
'Username : '||s.username || '(SID: '||s.sid||', Serial#: '||s.serial#||', SPID: '||p.spid||')'||chr(10)||
'Machine : '||s.machine ||chr(10)||
'OSUser : '||s.osuser ||chr(10)||
'Status : '||s.status ||chr(10)||
'Program : '||s.program ||chr(10)||
'Module : '||s.module ||chr(10)||
'Logon Time : '||to_char(s.logon_time,'dd/mm/yyyy hh24:mi:ss')||chr(10)||
'Tablespace : '||u.tablespace||chr(10)||
--'Utilizado : '||sum(u.blocks)*(select value from v$parameter where name = 'db_block_size')/1048576 ||'MB'||chr(10)||
'Last Call : '||s.last_call_et||chr(10)||
'Hash Value : '||t.hash_value||chr(10)||
'Command : '||substr(t.sql_text,1,960)
--' '||substr(t.sql_text,81,160)||chr(10)||
--' '||substr(t.sql_text,161,240)||chr(10)||
--' '||substr(t.sql_text,241,320)||chr(10)||
--' '||substr(t.sql_text,321,400)
from v$process p, v$session s, v$sql t, v$sort_usage u
where p.addr = s.paddr
and s.saddr = u.session_addr
and s.sql_address = t.address(+)
group by s.username,s.sid,s.serial#,p.spid,s.machine,s.osuser,s.status,s.program,s.module
,to_char(s.logon_time,'dd/mm/yyyy hh24:mi:ss'),
u.tablespace,s.last_call_et,substr(t.sql_text,1,960),t.hash_value,substr(t.sql_t
ext,1,960)
order by sum(u.blocks) desc) where rownum <= 10;

