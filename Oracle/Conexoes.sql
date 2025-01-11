
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';

set pagesize 200

select count(*) as "TOTAL DE CONEXOES", sysdate as "DATA - HORA", instance_name as "INSTANCIA" from v$session, v$instance GROUP BY instance_name;

select distinct username, count(*) as CONEXOES from v$session group by username order by 2;

select distinct username, count(*) as CONEXOES, machine, program from v$session having count(*) > 5 group by username, machine, program order by 2;

